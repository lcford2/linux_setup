# Qtile Config File
# http://www.qtile.org/

# Antonio Sarosi
# https://youtube.com/c/antoniosarosi
# https://github.com/antoniosarosi/dotfiles


from libqtile import hook
from libqtile.command import lazy

from settings.keys import mod, keys
from settings.groups import groups
from settings.layouts import layouts, floating_layout
from settings.widgets import widget_defaults, extension_defaults
from settings.screens import screens
from settings.mouse import mouse
from settings.path import qtile_path

from os import path
import os
import subprocess


@hook.subscribe.startup_once
def autostart():
    subprocess.call([path.join(qtile_path, 'autostart.sh')])
    lazy.restart()



@hook.subscribe.startup
def dbus_register():
    dt_id = os.environ.get("DESKTOP_AUTOSTART_ID")
    if not dt_id:
        return
    subprocess.Popen(["dbus-send",
                      "--session",
                      "--print-reply",
                      "--dest=org.gnome.SessionManager",
                      "/org/gnome/SessionManager",
                      "org.gnome.SessionManager.RegisterClient",
                      "string:qtile",
                      "string:" + dt_id])

main = None
dgroups_key_binder = None
dgroups_app_rules = []
follow_mouse_focus = True
bring_front_click = False
cursor_warp = True
auto_fullscreen = True
focus_on_window_activation = 'urgent'
wmname = 'LG3D'
