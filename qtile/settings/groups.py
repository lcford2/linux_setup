# Antonio Sarosi
# https://youtube.com/c/antoniosarosi
# https://github.com/antoniosarosi/dotfiles

# Qtile workspaces

from libqtile.config import Key, Group
from libqtile.command import lazy
# from libqtile.command.client import InteractiveCommandCliecnt
from .keys import mod, keys
import subprocess
import re


# Get the icons at https://www.nerdfonts.com/cheat-sheet (you need a Nerd Font)
# Icons: 
# nf-fa-firefox, 
# nf-fae-python, 
# nf-dev-terminal, 
# nf-fa-code, 
# nf-oct-git_merge, 
# nf-linux-docker, 
# nf-custom-folder, 
# nf-mdi-image, 
# nf-mdi-layers, 
# nf-fa-spotify, 

names = ["browser", "python", "terminal", "vpn",
         "slack", "music", "scratch", "files"]

spawns = ["", "", "", "",
          "slack", "", "", ""]

display_names = ["   ", "   ", "   ", " 嬨  ",
                 "   ", "   ", "   ", "   "]

groups = [Group(
    name=n,
    spawn=s if s != "" else None,
    label=i
    ) for n, s, i in zip(names, spawns, display_names)
]


for i, group in enumerate(groups):
    actual_key = str(i + 1)
    kp_key = f"KP_{i+1}"
    keys.extend([
        # Switch to workspace N
        Key([mod], actual_key, lazy.group[group.name].toscreen()),
        # Send window to workspace N
        Key([mod, "shift"], actual_key, lazy.window.togroup(group.name)),
        # Keypad keys
        # Switch to workspace N
        Key([mod], kp_key, lazy.group[group.name].toscreen()),
        # Send window to workspace N
        Key([mod, "shift"], kp_key, lazy.window.togroup(group.name))
    ])

