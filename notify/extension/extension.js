// Nubo Notification Center.
//
// Records every notification any app sends to the shell (apps, Flatpaks, the
// browser's web apps, phone notifications from GSConnect), keeps a history
// grouped by app, counts unread ones and offers Do Not Disturb.
//
// History stays on this computer, in the person's own data folder, and can be
// cleared at any time. Notifications that arrive while an app has no window
// still show up, because the nubo-notify-agent keeps the app running.

import Clutter from 'gi://Clutter';
import GLib from 'gi://GLib';
import GObject from 'gi://GObject';
import Gio from 'gi://Gio';
import St from 'gi://St';

import * as Main from 'resource:///org/gnome/shell/ui/main.js';
import * as PanelMenu from 'resource:///org/gnome/shell/ui/panelMenu.js';
import * as PopupMenu from 'resource:///org/gnome/shell/ui/popupMenu.js';
import {Extension} from 'resource:///org/gnome/shell/extensions/extension.js';

const MAX_ITEMS = 200;
const MAX_AGE_SECONDS = 7 * 24 * 3600;
const HISTORY_FILE = GLib.build_filenamev([GLib.get_user_data_dir(), 'nubo', 'notification-history.json']);

function relativeTime(ts) {
    const s = Math.max(0, Math.floor(Date.now() / 1000 - ts));
    if (s < 60) return 'now';
    if (s < 3600) return `${Math.floor(s / 60)}m`;
    if (s < 86400) return `${Math.floor(s / 3600)}h`;
    return `${Math.floor(s / 86400)}d`;
}

const Indicator = GObject.registerClass(
class NuboNotifyIndicator extends PanelMenu.Button {
    _init() {
        super._init(0.5, 'Nubo Notification Center', false);
        this._items = this._load();
        this._unread = 0;
        this._saveId = 0;
        this._sources = new Map();
        this._notifySettings = new Gio.Settings({schema_id: 'org.gnome.desktop.notifications'});

        const box = new St.BoxLayout({style_class: 'panel-status-menu-box'});
        this._icon = new St.Icon({icon_name: 'preferences-system-notifications-symbolic', style_class: 'system-status-icon'});
        this._badge = new St.Label({style_class: 'nubo-nc-badge', y_align: Clutter.ActorAlign.CENTER, visible: false});
        box.add_child(this._icon);
        box.add_child(this._badge);
        this.add_child(box);

        this._dnd = new PopupMenu.PopupSwitchMenuItem('Do Not Disturb', !this._notifySettings.get_boolean('show-banners'));
        this._dnd.connect('toggled', (_i, state) => this._notifySettings.set_boolean('show-banners', !state));
        this._dndId = this._notifySettings.connect('changed::show-banners', () => {
            this._dnd.setToggleState(!this._notifySettings.get_boolean('show-banners'));
        });
        this.menu.addMenuItem(this._dnd);

        this._clear = new PopupMenu.PopupMenuItem('Clear all');
        this._clear.connect('activate', () => { this._items = []; this._unread = 0; this._changed(); });
        this.menu.addMenuItem(this._clear);
        this.menu.addMenuItem(new PopupMenu.PopupSeparatorMenuItem());

        this._section = new PopupMenu.PopupMenuSection();
        this._scroll = new St.ScrollView({style_class: 'nubo-nc-scroll', overlay_scrollbars: true});
        this._list = new St.BoxLayout({vertical: true});
        this._scroll.add_child(this._list);
        this._section.actor.add_child(this._scroll);
        this.menu.addMenuItem(this._section);

        this.menu.connect('open-state-changed', (_m, open) => {
            if (open) { this._unread = 0; this._updateBadge(); this._render(); }
        });

        this._render();
        this._updateBadge();
    }

    track() {
        for (const source of Main.messageTray.getSources())
            this._watch(source);
        this._trayId = Main.messageTray.connect('source-added', (_t, source) => this._watch(source));
    }

    _watch(source) {
        if (this._sources.has(source)) return;
        const id = source.connect('notification-added', (_s, notification) => this._record(source, notification));
        this._sources.set(source, id);
    }

    _record(source, notification) {
        try {
            const title = notification.title ?? '';
            const body = notification.body ?? '';
            if (!title && !body) return;
            this._items.unshift({
                app: source.title || 'System',
                title, body,
                ts: Math.floor(Date.now() / 1000),
            });
            this._items.length = Math.min(this._items.length, MAX_ITEMS);
            if (!this.menu.isOpen) this._unread++;
            this._changed();
        } catch (e) {
            console.error(`nubo-notify-center: ${e}`);
        }
    }

    _changed() {
        this._updateBadge();
        if (this.menu.isOpen) this._render();
        if (this._saveId) return;
        this._saveId = GLib.timeout_add_seconds(GLib.PRIORITY_LOW, 2, () => { this._saveId = 0; this._save(); return GLib.SOURCE_REMOVE; });
    }

    _updateBadge() {
        this._badge.visible = this._unread > 0;
        this._badge.text = this._unread > 99 ? '99+' : `${this._unread}`;
    }

    _render() {
        this._list.destroy_all_children();
        if (this._items.length === 0) {
            this._list.add_child(new St.Label({style_class: 'popup-menu-item nubo-nc-empty', text: 'No notifications', opacity: 170}));
            return;
        }
        const groups = new Map();
        for (const item of this._items) {
            if (!groups.has(item.app)) groups.set(item.app, []);
            groups.get(item.app).push(item);
        }
        for (const [app, items] of groups) {
            this._list.add_child(new St.Label({style_class: 'popup-menu-item nubo-nc-app', text: app.toUpperCase(), reactive: false, opacity: 170}));
            for (const item of items.slice(0, 20)) {
                const row = new St.BoxLayout({vertical: true, style_class: 'popup-menu-item nubo-nc-item', reactive: true});
                const head = new St.BoxLayout();
                const title = new St.Label({style_class: 'nubo-nc-title', text: item.title, x_expand: true});
                title.clutter_text.ellipsize = 3;
                head.add_child(title);
                head.add_child(new St.Label({style_class: 'nubo-nc-time', text: relativeTime(item.ts), opacity: 150}));
                row.add_child(head);
                if (item.body) {
                    const body = new St.Label({style_class: 'nubo-nc-body', text: item.body, opacity: 200});
                    body.clutter_text.line_wrap = true;
                    body.clutter_text.ellipsize = 3;
                    row.add_child(body);
                }
                this._list.add_child(row);
            }
        }
    }

    _load() {
        try {
            const [ok, bytes] = GLib.file_get_contents(HISTORY_FILE);
            if (!ok) return [];
            const cutoff = Date.now() / 1000 - MAX_AGE_SECONDS;
            return JSON.parse(new TextDecoder().decode(bytes)).filter(i => i.ts > cutoff).slice(0, MAX_ITEMS);
        } catch (_e) {
            return [];
        }
    }

    _save() {
        try {
            GLib.mkdir_with_parents(GLib.path_get_dirname(HISTORY_FILE), 0o700);
            GLib.file_set_contents(HISTORY_FILE, JSON.stringify(this._items));
        } catch (e) {
            console.error(`nubo-notify-center: could not save history: ${e}`);
        }
    }

    destroy() {
        if (this._trayId) Main.messageTray.disconnect(this._trayId);
        for (const [source, id] of this._sources) source.disconnect(id);
        this._sources.clear();
        if (this._dndId) this._notifySettings.disconnect(this._dndId);
        if (this._saveId) { GLib.source_remove(this._saveId); this._save(); }
        super.destroy();
    }
});

export default class NuboNotifyCenter extends Extension {
    enable() {
        this._indicator = new Indicator();
        Main.panel.addToStatusArea(this.uuid, this._indicator, 0, 'right');
        this._indicator.track();
    }

    disable() {
        this._indicator?.destroy();
        this._indicator = null;
    }
}
