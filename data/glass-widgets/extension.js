/*
 * Nubo build of glass-widgets (original: Peter Njoroge, GPL-3.0).
 * Changes: every widget is its own draggable card, positions are remembered,
 * a month calendar card is added, and the rectangular blur layer behind the
 * cards (which showed as dark square corners) is gone.
 */

'use strict';

import St from 'gi://St';
import Clutter from 'gi://Clutter';
import GLib from 'gi://GLib';
import Gio from 'gi://Gio';

import {Extension} from 'resource:///org/gnome/shell/extensions/extension.js';
import * as Main from 'resource:///org/gnome/shell/ui/main.js';

import {GlassClockWidget} from './widgets/clock.js';
import {GlassStatsWidget} from './widgets/stats.js';

// Centre of each card as a fraction of the primary monitor.
const DEFAULTS = {
    clock: [0.5, 0.2],
    stats: [0.84, 0.32],
    calendar: [0.16, 0.34],
};

function makeCalendar() {
    const card = new St.BoxLayout({style_class: 'glass-card glass-cal-card', vertical: true});
    const title = new St.Label({style_class: 'glass-stats-title', x_align: Clutter.ActorAlign.CENTER});
    card.add_child(title);
    const grid = new St.Widget({layout_manager: new Clutter.GridLayout()});
    card.add_child(grid);

    const draw = () => {
        grid.destroy_all_children();
        const now = GLib.DateTime.new_now_local();
        title.text = now.format('%B %Y');
        const first = GLib.DateTime.new_local(now.get_year(), now.get_month(), 1, 0, 0, 0);
        const lead = first.get_day_of_week() - 1; // Monday first
        const days = GLib.Date.get_days_in_month(now.get_month(), now.get_year());
        'MTWTFSS'.split('').forEach((d, i) =>
            grid.layout_manager.attach(new St.Label({style_class: 'glass-cal-head', text: d}), i, 0, 1, 1));
        for (let d = 1; d <= days; d++) {
            const slot = lead + d - 1;
            const today = d === now.get_day_of_month();
            grid.layout_manager.attach(new St.Label({
                style_class: today ? 'glass-cal-day glass-cal-today' : 'glass-cal-day',
                text: String(d),
            }), slot % 7, 1 + Math.floor(slot / 7), 1, 1);
        }
    };
    draw();
    card._timer = GLib.timeout_add_seconds(GLib.PRIORITY_DEFAULT, 3600, () => {
        draw();
        return GLib.SOURCE_CONTINUE;
    });
    card.connect('destroy', () => {
        if (card._timer)
            GLib.Source.remove(card._timer);
    });
    return card;
}

export default class GlassWidgetsExtension extends Extension {
    enable() {
        this._settings = this.getSettings();
        this._cards = new Map();
        this._file = Gio.File.new_for_path(
            GLib.build_filenamev([GLib.get_user_config_dir(), 'nubo', 'widgets.json']));
        this._pos = this._load();
        this._build();
        this._monId = Main.layoutManager.connect('monitors-changed', () => this._placeAll());
        this._setId = this._settings.connect('changed', (_s, key) => {
            if (key.startsWith('show-'))
                this._build();
        });
    }

    disable() {
        Main.layoutManager.disconnect(this._monId);
        this._settings.disconnect(this._setId);
        this._clear();
        this._settings = null;
    }

    _load() {
        try {
            const [ok, bytes] = this._file.load_contents(null);
            if (ok)
                return JSON.parse(new TextDecoder().decode(bytes));
        } catch (e) {
            // first run
        }
        return {};
    }

    _save() {
        try {
            GLib.mkdir_with_parents(this._file.get_parent().get_path(), 0o755);
            this._file.replace_contents(JSON.stringify(this._pos), null, false,
                Gio.FileCreateFlags.NONE, null);
        } catch (e) {
            logError(e, 'nubo widgets: cannot save positions');
        }
    }

    _clear() {
        for (const card of this._cards.values())
            card.destroy();
        this._cards.clear();
    }

    _build() {
        this._clear();
        const want = [];
        if (this._settings.get_boolean('show-clock'))
            want.push(['clock', () => new GlassClockWidget(this._settings)]);
        if (this._settings.get_boolean('show-stats'))
            want.push(['stats', () => new GlassStatsWidget()]);
        if (this._settings.get_boolean('show-calendar'))
            want.push(['calendar', makeCalendar]);

        for (const [id, make] of want) {
            const card = make();
            card.reactive = true;
            card.x_expand = false;
            card.y_expand = false;
            const drag = new Clutter.DragAction();
            drag.connect('drag-end', () => {
                const m = Main.layoutManager.primaryMonitor;
                this._pos[id] = [
                    (card.x + card.width / 2 - m.x) / m.width,
                    (card.y + card.height / 2 - m.y) / m.height,
                ];
                this._save();
            });
            card.add_action(drag);
            Main.layoutManager._backgroundGroup.add_child(card);
            this._cards.set(id, card);
            card.connect('notify::width', () => this._place(id));
            card.connect('notify::height', () => this._place(id));
            this._place(id);
        }
    }

    _place(id) {
        const card = this._cards.get(id);
        const m = Main.layoutManager.primaryMonitor;
        if (!card || !m || card.get_children === undefined)
            return;
        const [fx, fy] = this._pos[id] ?? DEFAULTS[id];
        card.set_position(
            Math.round(m.x + m.width * fx - card.width / 2),
            Math.round(m.y + m.height * fy - card.height / 2));
    }

    _placeAll() {
        for (const id of this._cards.keys())
            this._place(id);
    }
}
