"""Display network ssid in status bar for QTile"""

import subprocess
import re
from datetime import datetime

from libqtile import pangocffi
from libqtile.log_utils import logger
from libqtile.widget import base

__author__ = "Lucas Ford <lcford185@gmail.com>"
__version__ = "0.1"

WIFI_ICON = " "
ETH_ICON = " "
NO_I_ICON = "睊 "
VPN_ON_ICON = " "
# VPN_OFF_ICON = " "
VPN_OFF_ICON = " "

log_file = "/home/lford/net_ssid.log"


def log_message(string, file=log_file):
    dt = datetime.now().strftime("[%Y-%m-%d %H:%M:%S]")
    with open("/home/lford/net_ssid.log", "a") as f:
        f.write(f"{dt} {string}\n")


# Handle the change of widget base class in the Qtile project
BaseClass = base.ThreadPoolText
NewWidgetBase = True


class NetSSID(BaseClass):
    """OpenWeatherMap widget for QTile"""

    orientations = base.ORIENTATION_HORIZONTAL
    defaults = [
        ("update_interval", 1, "Update interval in seconds between look ups"),
    ]

    def __init__(self, **config):
        if NewWidgetBase:
            super().__init__("", **config)
        else:
            super().__init__(**config)

        self.add_defaults(NetSSID.defaults)
        self.markup = True

    def check_wifi(self):
        try:
            result = subprocess.check_output(["iwgetid", "-r"])
            ssid = result.decode().strip()
            # log_message(f"WIFI SSID: {ssid}")
            return ssid
        except subprocess.CalledProcessError:
            return False

    def check_wired(self):
        result = subprocess.check_output(["nmcli", "--overview", "c"])
        res_text = result.decode().split("\n")
        pattern = re.compile("Wired.*ethernet +(.*)")
        match = None
        for i in res_text:
            m = re.search(pattern, i)
            if m:
                match = m
                # log_message(f"WIRED NMCLI: {match.groups(0)[0]}")
                break
        # get group (is returned as a tuple)
        try:
            interface = match.groups(1)[0].strip()
        except AttributeError:
            # no match
            return False

        try:
            with open(f"/sys/class/net/{interface}/operstate", "r") as f:
                state = f.read().strip("\n")
            # log_message(f"WIRED STATUS: {state}")
        except FileNotFoundError as e:
            # log_message(f"WIRED STATUS: {e}")
            return False

        if state == "up":
            return interface
        else:
            return False
            
    def check_vpn_connected(self):
        cmd = ["piactl", "get", "connectionstate"]
        try:
            result = subprocess.check_output(cmd)
            res_text = result.decode().strip("\n")
        except Exception as e:
            log_message(f"Error getting VPN status: {e}")
            return False
        return res_text == "Connected"

    def poll(self):
        wifi_result = self.check_wifi()
        wired_result = self.check_wired()
        vpn_connected = self.check_vpn_connected()
        max_len = 10
        
        VPN_ICON = VPN_ON_ICON if vpn_connected else VPN_OFF_ICON
        if wifi_result:
            if len(wifi_result) > max_len:
                wifi_result = f"{wifi_result[:max_len]}..."
            return f"{WIFI_ICON} {VPN_ICON}{wifi_result}"
        elif wired_result:
            if len(wired_result) > max_len:
                wired_result = f"{wired_result[:10]}..."
            return f"{ETH_ICON} {VPN_ICON}{wired_result}"
        else:
            return f"{NO_I_ICON} Error"
