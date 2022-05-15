# Antonio Sarosi
# https://youtube.com/c/antoniosarosi
# https://github.com/antoniosarosi/dotfiles

# Multimonitor support

from libqtile.config import Screen
from libqtile import bar
from libqtile.log_utils import logger
from .widgets import my_widgets
import subprocess


def status_bar(widgets, height=24):
    return bar.Bar(widgets, height, opacity=0.92)


# screens = [Screen(top=status_bar(primary_widgets))]

xrandr = "xrandr | grep -w 'connected' | cut -d ' ' -f 2 | wc -l"

command = subprocess.run(
    xrandr,
    shell=True,
    stdout=subprocess.PIPE,
    stderr=subprocess.PIPE,
)

if command.returncode != 0:
    error = command.stderr.decode("UTF-8")
    logger.error(f"Failed counting monitors using {xrandr}:\n{error}")
    connected_monitors = 1
else:
    connected_monitors = int(command.stdout.decode("UTF-8"))

if connected_monitors > 1:
    screens = [Screen(top=status_bar(my_widgets[0]))]
    for i in range(1, connected_monitors):
        # screens.append(Screen(top=status_bar(secondary_widgets)))
        # screens.append(Screen(top=status_bar(
            # copy.deepcopy(primary_widgets))))
        screens.append(Screen(top=status_bar(my_widgets[i])))
else:
    screens = [Screen(top=status_bar(my_widgets[0]))]



