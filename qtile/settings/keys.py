# Antonio Sarosi
# https://youtube.com/c/antoniosarosi
# https://github.com/antoniosarosi/dotfiles

# Qtile keybindings

from libqtile.config import Key, KeyChord
from libqtile.command import lazy

import subprocess


@lazy.function
def logout_session(qtile):
    out = subprocess.check_output(["loginctl"]).decode()
    out = out.split("\n")[1].split()[0]
    logout_cmd = ["loginctl", "kill-session", out]
    subprocess.call(logout_cmd)


mod = "mod4"
launch_emacs = "emacsclient -c -a 'emacs'"

keys = [Key(key[0], key[1], *key[2:]) for key in [
    # ------------ Window Configs ------------

    # Switch between windows in current stack pane
    ([mod], "j", lazy.layout.down()),
    ([mod], "k", lazy.layout.up()),
    ([mod], "h", lazy.layout.left()),
    ([mod], "l", lazy.layout.right()),

    # move to groups right and left
    ([mod], "Right", lazy.screen.next_group()),
    ([mod], "Left", lazy.screen.prev_group()),

    # Change window sizes (MonadTall)
    ([mod, "shift"], "l", lazy.layout.grow()),
    ([mod, "shift"], "h", lazy.layout.shrink()),

    # Toggle floating
    ([mod, "shift"], "f", lazy.window.toggle_floating()),

    # Move windows up or down in current stack
    ([mod, "shift"], "j", lazy.layout.shuffle_down()),
    ([mod, "shift"], "k", lazy.layout.shuffle_up()),

    # Toggle between different layouts as defined below
    ([mod], "Tab", lazy.next_layout()),
    ([mod, "shift"], "Tab", lazy.prev_layout()),

    # Kill window
    ([mod], "q", lazy.window.kill()),

    # Switch focus of monitors
    ([mod], "period", lazy.next_screen()),
    ([mod], "comma", lazy.prev_screen()),

    # Restart Qtile
    ([mod, "control"], "r", lazy.restart()),

    ([mod, "control"], "q", lazy.shutdown()),
    # ([mod], "r", lazy.spawncmd()),

    # ------------ App Configs ------------

    # Menu
    ([mod], "m", lazy.spawn("rofi -show drun")),
    ([mod], "s", lazy.spawn("rofi -show ssh")),
    ([mod], "p", lazy.spawn("rofi -show p -modi p:rofi-power-menu")),

    # Window Nav
    ([mod, "shift"], "m", lazy.spawn("rofi -show window")),

    # Browser
    ([mod], "b", lazy.spawn("firefox")),

    # File Explorer
    # ([mod], "f", lazy.spawn("nautilus")),
    ([mod], "f", lazy.spawn("pcmanfm")),

    # filezill
    ([mod, "shift"], "z", lazy.spawn("filezilla")),

    # Terminal
    ([mod], "Return", lazy.spawn("alacritty")),

    # Emacs
    ([mod], "e", lazy.spawn(
        f"{launch_emacs} --eval '(dashboard-refresh-buffer)'")),
    ([mod], "t", lazy.spawn(
        f"{launch_emacs} --eval '(+vterm/here nil)'")),

    # vscode
    ([mod], "c", lazy.spawn("code")),

    # Zoom
    ([mod], "z", lazy.spawn("zoom")),

    # scratchpad
    # ([mod, "shift"], "s", lazy.group["scratchpad"].dropdown_toggle('term')),
    (["mod1"], "s", lazy.group["scratchpad"].dropdown_toggle("term")),

    # Screenshot
    # ([mod], "s", lazy.spawn("spotify")),

    # Cisco VPN
    ([mod], "v", lazy.spawn("/opt/cisco/anyconnect/bin/vpnui")),

    # gnome session controls
    # ([mod, "control"], "l", lazy.spawn("gnome-screensaver-command -l")),
    # ([mod, "control"], "q", lazy.spawn("gnome-session-quit --logout --no-prompt")),
    ([mod, "control"], "q", logout_session()),
    ([mod, "shift", "control"], "q", lazy.spawn("gnome-session-quit --power-off")),

    # ------------ Hardware Configs ------------

    # Volume
    ([], "XF86AudioLowerVolume", lazy.spawn(
        "pactl set-sink-volume @DEFAULT_SINK@ -5%"
    )),
    ([], "XF86AudioRaiseVolume", lazy.spawn(
        "pactl set-sink-volume @DEFAULT_SINK@ +5%"
    )),
    ([], "XF86AudioMute", lazy.spawn(
        "pactl set-sink-mute @DEFAULT_SINK@ toggle"
    )),

    # Brightness
    ([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +10%")),
    ([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 10%-")),

    # media controls
    ([], "XF86AudioPlay", lazy.spawn("playerctl -p spotify play-pause")),
    ([], "XF86AudioNext", lazy.spawn("playerctl -p spotify next")),
    ([], "XF86AudioPrev", lazy.spawn("playerctl -p spotify previous")),
    # ([], "XF86AudioPause", lazy.spawn("playerctl -p spotify pause")),

    # ------------ Session Configs -------------
    # Lock Screen
    # ([mod, "mod1"], "l", lazy.spawn("light-locker-command -l")),
]]

key_chords = [
    KeyChord([], "space", [
        Key([], "w", [
            Key([], "j", lazy.layout.down())
    ])]),
    KeyChord([], "space", [
        Key([], "w", [
            Key([], "k", lazy.layout.up())
    ])]),
    KeyChord([], "space", [
        Key([], "w", [
            Key([], "h", lazy.layout.left())
    ])]),
    KeyChord([], "space", [
        Key([], "w", [
            Key([], "l", lazy.layout.right())
    ])]),
]

# keys.extend(key_chords)
