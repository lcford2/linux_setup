from libqtile import widget
from .volume import Volume
from .theme import colors
from .owm import OpenWeatherMap
from .net_ssid import NetSSID

# Get the icons at https://www.nerdfonts.com/cheat-sheet (you need a Nerd Font)

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
        fontsize=fontsize,
        text=text,
        padding=3
    )


def powerline(fg="light", bg="dark", fontsize=36):
    fontsize=26
    return widget.TextBox(
        **base(fg, bg),
        # text="", # Icon: nf-oct-triangle_left
        text=u"\ue0be",
        fontsize=fontsize,
        # padding=-5 if fontsize==36 else -9
        padding=10
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
    sfs_args = {"fontsize":sfs} if sfs else {}
    pfs_args = {"fontsize":pfs} if pfs else {}
    widgets = [
        *workspaces(**sfs_args),

        separator(),

        powerline('color4', 'dark', **pfs_args),

        OpenWeatherMap(
           api_key="0b0aae7b2ec162c2279f0edf23d0a2b3",
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

        icon(bg="color1", **sfs_args, text=' '), # Icon: nf-mdi-calendar_clock

        widget.Clock(**base(bg='color1'), format='%m/%d/%Y - %I:%M %p', **sfs_args),

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
