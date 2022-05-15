"""Display network ssid in status bar for QTile"""

import subprocess

from libqtile import pangocffi
from libqtile.log_utils import logger
from libqtile.widget import base

__author__ = "Lucas Ford <lcford185@gmail.com>"
__version__ = "0.1"

ICON = " "

# Handle the change of widget base class in the Qtile project
BaseClass = base.ThreadPoolText
NewWidgetBase = True

class NetSSID(BaseClass):
    """OpenWeatherMap widget for QTile"""

    orientations = base.ORIENTATION_HORIZONTAL
    defaults = [
        ("update_interval", 3600, "Update interval in seconds between look ups"),
    ]

    def __init__(self, **config):
        if NewWidgetBase:
            super().__init__("", **config)
        else:
            super().__init__(**config)

        self.add_defaults(NetSSID.defaults)
        self.markup = True

    def poll(self):
        try:
            result = subprocess.check_output(["iwgetid","-r"])
            ssid = result.decode().strip()
        except subprocess.CalledProcessError as e:
            ssid = "Error"

        return f"{ICON} {ssid}"
