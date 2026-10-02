// Nubo menu: the logo at the left of the top bar, with About, Settings, the
// store, help and the power actions.

import GLib from 'gi://GLib';
import GObject from 'gi://GObject';
import St from 'gi://St';

import * as Main from 'resource:///org/gnome/shell/ui/main.js';
import * as PanelMenu from 'resource:///org/gnome/shell/ui/panelMenu.js';
import * as PopupMenu from 'resource:///org/gnome/shell/ui/popupMenu.js';
import {Extension} from 'resource:///org/gnome/shell/extensions/extension.js';

function run(command) {
    try {
        GLib.spawn_command_line_async(command);
    } catch (e) {
        console.error(`nubo-menu: ${command}: ${e}`);
    }
}

const NuboMenu = GObject.registerClass(
class NuboMenu extends PanelMenu.Button {
    _init() {
        super._init(0.0, 'Nubo Menu', false);
        this.add_child(new St.Icon({icon_name: 'nubo-logo-symbolic', style_class: 'system-status-icon'}));

        const add = (label, command) => {
            const item = new PopupMenu.PopupMenuItem(label);
            item.connect('activate', () => run(command));
            this.menu.addMenuItem(item);
        };
        const separator = () => this.menu.addMenuItem(new PopupMenu.PopupSeparatorMenuItem());

        add('About Nubo OS', 'gnome-control-center system about');
        separator();
        add('System Settings…', 'gnome-control-center');
        add('Nubo Store…', 'gnome-software');
        add('Help…', 'xdg-open https://support.nubo.email');
        separator();
        add('Lock Screen', 'loginctl lock-session');
        add('Log Out…', 'gnome-session-quit --logout');
        add('Restart…', 'gnome-session-quit --reboot');
        add('Shut Down…', 'gnome-session-quit --power-off');
    }
});

export default class NuboMenuExtension extends Extension {
    enable() {
        this._button = new NuboMenu();
        Main.panel.addToStatusArea(this.uuid, this._button, 0, 'left');
    }

    disable() {
        this._button?.destroy();
        this._button = null;
    }
}
