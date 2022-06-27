from libqtile import widget
from .volume import Volume
from .theme import colors
from .owm import OpenWeatherMap
from .net_ssid import NetSSID
from libqtile.log_utils import logger
import subprocess

# Get the icons at https://www.nerdfonts.com/cheat-sheet (you need a Nerd Font)
font_scale = 1
xrandr = "xrandr | grep -w 'connected' | cut -d ' ' -f 2 | wc -l"

command = subprocess.run(
        xrandr,
        shell=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
)

if command.returncode != 0:
    error = command.stderr.decode("UTF-8")
    logger.error(f"Failed counting monitors in widgets.py using {xrandr}:\n{error}")
    connected_monitors = 1
else:
    connected_monitors = int(command.stdout.decode("UTF-8"))

if connected_monitors == 1:
    font_scale = 2

def base(fg='text', bg='dark'): 
    return {
        'foreground': colors[fg],
        'background': colors[bg]
    }


def separator():
    return widget.Sep(**base(), linewidth=0, padding=5)


def icon(fg='text', bg='dark', fontsize=16, text="?"):
    return widget.TextBox(
        **base(fg, bg),
        fontsize=int(fontsize*font_scale),
        text=text,
        padding=3
    )


def powerline(fg="light", bg="dark", fontsize=36):
    fontsize=26
    padding = 10
    if font_scale == 2:
        padding = 24
    return widget.TextBox(
        **base(fg, bg),
        # text="", # Icon: nf-oct-triangle_left
        text=u"\ue0be",
        fontsize=int(fontsize*font_scale),
        # padding=-5 if fontsize==36 else -9
        padding=padding
    )


def workspaces(fontsize=19): 
    return [
        separator(),
        widget.GroupBox(
            **base(fg='light'),
            font='DejaVu Sans Mono Nerd Font',
            fontsize=fontsize,
            margin_y=3,
            margin_x=0,
            padding_y=8,
            padding_x=5,
            borderwidth=1,
            active=colors['active'],
            inactive=colors['inactive'],
            rounded=False,
            highlight_method='block',
            urgent_alert_method='block',
            urgent_border=colors['urgent'],
            this_current_screen_border=colors['focus'],
            this_screen_border=colors['grey'],
            other_current_screen_border=colors['dark'],
            other_screen_border=colors['dark'],
            disable_drag=True
        ),
        separator(),
        widget.WindowName(**base(fg='focus'), fontsize=fontsize-5, padding=5),
        separator(),
    ]

def make_widgets(sfs=None, pfs=None):
    sfs_args = {"fontsize":int(sfs*font_scale)} if sfs else {}
    pfs_args = {"fontsize":int(pfs*font_scale)} if pfs else {}
    if font_scale == 2:
        cal_args = {"fontsize":int(sfs*font_scale/1.5)} if sfs else {}
    else:
        cal_args = {"fontsize":int(sfs)} if sfs else {}

    
    try:
        with open("/home/lford/.config/qtile/settings/owm_key.txt", "r") as f:
            key = f.readlines()[0].strip("\n\r")
    except FileNotFoundError as e:
        key = ""

    with open("/home/lford/.config/qtile/settings/key.out", "w") as f:
        f.write(key)

    widgets = [
        *workspaces(**sfs_args),

        separator(),

        powerline('color4', 'dark', **pfs_args),
        
        OpenWeatherMap(
           api_key=key,
           latitude=35.779591,
           longitude=-78.638176,
           background=colors["color4"],
           foreground=colors["text"],
           **sfs_args
           # icon_font="Material Design Icons"
        ),

        # icon(bg="color4", text=' ', **sfs_args), # Icon: nf-fa-download
        
        # widget.CheckUpdates(
        #     background=colors['color4'],
        #     colour_have_updates=colors['text'],
        #     colour_no_updates=colors['text'],
        #     no_update_string='0',
        #     display_format='{updates}',
        #     update_interval=1800,
        #     custom_command='checkupdates',
        #     **sfs_args
        # ),

       powerline('color3', 'color4', **pfs_args),

        # icon(bg="color3", text=' ', **sfs_args),  # Icon: nf-fa-feed
        
        # widget.Net(**base(bg='color3'), **sfs_args),
       NetSSID(
           background=colors["color3"],
           foreground=colors["text"],
           **sfs_args
       ),

        powerline('color2', 'color3', **pfs_args),

        widget.CurrentLayoutIcon(**base(bg='color2'), scale=0.65),

        widget.CurrentLayout(**base(bg='color2'), padding=0, **sfs_args),

        powerline('color1', 'color2', **pfs_args),

        icon(bg="color1", **cal_args, text=' '), # Icon: nf-mdi-calendar_clock

        widget.Clock(**base(bg='color1'), format='%m/%d/%y - %I:%M%p', **sfs_args),

        powerline('color4', 'color1', **pfs_args),
        
        widget.Battery(**base(bg='color4', fg='dark'), 
                       # format='{char} {percent:2.0%} {hour:d}:{min:02d} {watt:.2f} W',
                       format='{char} {percent:2.0%}',
                       **sfs_args
        ),
        
        powerline('color3', 'color4', **pfs_args),

        Volume(**base(bg='color3'),
                      cardid=0,
                      channel='Master',
                      padding=10,
                      emoji=True,
                      **sfs_args
        ),

        # powerline('color2', 'color3', **pfs_args),

        # widget.Notify(**base(bg='color2'), **sfs_args),

    ]
    return widgets


sfs = 16
pfs = 36

my_widgets = [make_widgets(sfs,pfs),make_widgets(),make_widgets()]

widget_defaults = {
    'font': 'DejaVu Sans Mono Nerd Font Bold',
    'fontsize': 14,
    'padding': 2,
}
extension_defaults = widget_defaults.copy()
