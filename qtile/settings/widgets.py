from libqtile import widget
from .volume import Volume
from .theme import colors
from .owm import OpenWeatherMap
from .net_ssid import NetSSID
from .my_battery import Battery
from .font_config.xlib_utils import get_highest_available_res
from libqtile.log_utils import logger
import os
import json

# Get the icons at https://www.nerdfonts.com/cheat-sheet (you need a Nerd Font)


def load_font_config():
    high_res = get_highest_available_res()
    config_file = os.path.expanduser("~/.config/qtile/settings/font_config/font_config.json")
    with open(config_file, "r") as f:
        config = json.load(f)
    return config.get(high_res, config["1920x1080"])["qtile"]


def base(fg="text", bg="dark"):
    return {"foreground": colors[fg], "background": colors[bg]}


def separator():
    return widget.Sep(**base(), linewidth=0, padding=5)


def icon(fg="text", bg="dark", fontsize=16, text="?"):
    return widget.TextBox(**base(fg, bg), fontsize=(fontsize), text=text, padding=3)


def powerline(fg="light", bg="dark", fontsize=36, padding=0):
    return widget.TextBox(
        **base(fg, bg),
        # text="", # Icon: nf-oct-triangle_left
        text="\ue0be",
        fontsize=int(fontsize),
        # padding=-5 if fontsize==36 else -9
        padding=padding,
    )


def workspaces(fontsize=19):
    return [
        separator(),
        widget.GroupBox(
            **base(fg="light"),
            font="DejaVu Sans Mono Nerd Font",
            fontsize=fontsize,
            margin_y=3,
            margin_x=0,
            padding_y=8,
            padding_x=5,
            borderwidth=1,
            active=colors["active"],
            inactive=colors["inactive"],
            rounded=False,
            highlight_method="block",
            urgent_alert_method="block",
            urgent_border=colors["urgent"],
            this_current_screen_border=colors["focus"],
            this_screen_border=colors["grey"],
            other_current_screen_border=colors["dark"],
            other_screen_border=colors["dark"],
            disable_drag=True,
        ),
        separator(),
        widget.WindowName(**base(fg="focus"), fontsize=fontsize - 5, padding=5),
        separator(),
    ]


def make_widgets(font_config):
    try:
        keyfile = os.path.expanduser("~/.privatekeys/owmkey.txt")
        with open(keyfile, "r") as f:
            key = f.readlines()[0].strip("\n\r")
    except FileNotFoundError:
        key = ""

    widgets = []

    widgets.extend(workspaces(fontsize=font_config["large_text"]))
    logger.debug("WORKSPACES LOADED")
    widgets.append(separator())
    widgets.append(
        powerline(
            "color4",
            "dark",
            fontsize=font_config["large_icon"],
            padding=font_config["powerline_padding"],
        )
    )
    logger.debug("POWERLINE CREATED")
    widgets.append(
        OpenWeatherMap(
            api_key=key,
            latitude=35.779591,
            longitude=-78.638176,
            background=colors["color4"],
            foreground=colors["text"],
            fontsize=font_config["small_text"]
            # icon_font="Material Design Icons"
        )
    )
    logger.debug("OWM LOADED")
    # icon(bg="color4", text=' ', fontsize=font_config["small_text"]), # Icon: nf-fa-download
    # widget.CheckUpdates(
    #     background=colors['color4'],
    #     colour_have_updates=colors['text'],
    #     colour_no_updates=colors['text'],
    #     no_update_string='0',
    #     display_format='{updates}',
    #     update_interval=1800,
    #     custom_command='checkupdates',
    #     fontsize=font_config["small_text"]
    # ),
    widgets.append(
        powerline(
            "color3",
            "color4",
            fontsize=font_config["large_icon"],
            padding=font_config["powerline_padding"],
        )
    )

    # icon(bg="color3", text=' ', fontsize=font_config["small_text"]),  # Icon: nf-fa-feed
    # widget.Net(**base(bg='color3'), fontsize=font_config["small_text"]),
    widgets.append(
        NetSSID(
            background=colors["color3"],
            foreground=colors["text"],
            fontsize=font_config["small_text"],
        )
    )
    logger.debug("NetSSID LOADED")
    widgets.append(
        powerline(
            "color2",
            "color3",
            fontsize=font_config["large_icon"],
            padding=font_config["powerline_padding"],
        )
    )
    widgets.append(widget.CurrentLayoutIcon(**base(bg="color2"), scale=0.65))
    widgets.append(
        widget.CurrentLayout(
            **base(bg="color2"), padding=0, fontsize=font_config["small_text"]
        )
    )
    logger.debug("Current Layout LOADED")
    widgets.append(
        powerline(
            "color1",
            "color2",
            fontsize=font_config["large_icon"],
            padding=font_config["powerline_padding"],
        )
    )
    widgets.append(
        icon(bg="color1", fontsize=font_config["small_text"], text=" ")
    )  # Icon: nf-mdi-calendar_clock
    widgets.append(
        widget.Clock(
            **base(bg="color1"),
            format="%m/%d/%y - %I:%M%p",
            fontsize=font_config["small_text"],
        )
    )
    logger.debug("CALENDAR LOADED")
    widgets.append(
        powerline(
            "color4",
            "color1",
            fontsize=font_config["large_icon"],
            padding=font_config["powerline_padding"],
        )
    )
    widgets.append(
        Battery(
            **base(bg="color4", fg="dark"),
            format="{char} {percent:2.0%}",
            charge_char="",
            discharge_char=["", "", "", "", ""],
            full_char="",
            fontsize=font_config["small_text"],
        )
    )
    logger.debug("BATTERY LOADED")
    widgets.append(
        powerline(
            "color3",
            "color4",
            fontsize=font_config["large_icon"],
            padding=font_config["powerline_padding"],
        )
    )
    widgets.append(
        Volume(
            **base(bg="color3"),
            cardid=0,
            channel="Master",
            padding=10,
            emoji=True,
            fontsize=font_config["small_text"],
        )
    )
    logger.debug("VOLUME LOADED")

    return widgets


sfs = 16
pfs = 36

font_config = load_font_config()
logger.debug(get_highest_available_res())

my_widgets = [
    make_widgets(font_config),
    make_widgets(font_config),
    make_widgets(font_config),
]

widget_defaults = {
    "font": "DejaVu Sans Mono Nerd Font Bold",
    "fontsize": 14,
    "padding": 2,
}
extension_defaults = widget_defaults.copy()
