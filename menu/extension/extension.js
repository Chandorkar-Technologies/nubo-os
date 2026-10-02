// Nubo logo at the left of the top bar. Click opens the app overview.

import Clutter from 'gi://Clutter';
import GObject from 'gi://GObject';
import St from 'gi://St';

import * as Main from 'resource:///org/gnome/shell/ui/main.js';
import * as PanelMenu from 'resource:///org/gnome/shell/ui/panelMenu.js';
import {Extension} from 'resource:///org/gnome/shell/extensions/extension.js';

const NuboMenu = GObject.registerClass(
class NuboMenu extends PanelMenu.Button {
    _init() {
        // No drop-down: the logo opens the app overview, like a start button.
        super._init(0.0, 'Nubo', true);
        const box = new St.BoxLayout({style_class: 'nubo-brand'});
        box.add_child(new St.Icon({icon_name: 'nubo-logo-symbolic', style_class: 'nubo-logo-icon'}));
        box.add_child(new St.Label({text: 'Nubo OS 1', style_class: 'nubo-brand-label', y_align: Clutter.ActorAlign.CENTER}));
        this.add_child(box);
        this.connect('button-press-event', () => {
            Main.overview.toggle();
            return Clutter.EVENT_STOP;
        });
        this.connect('touch-event', () => {
            Main.overview.toggle();
            return Clutter.EVENT_STOP;
        });
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
