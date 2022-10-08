#!/usr/bin/python

from Xlib import display
from Xlib.ext import randr
from IPython import embed as II


def find_screen_mode(id, modes):
    for mode in modes:
        if id == mode.id:
            return "{}x{}".format(mode.width, mode.height)

                        
def get_display_info():
    d = display.Display(':0')
    screen_count = d.screen_count()
    def_screen = d.get_default_screen()
    
    result = []
    screen = 0
    info = d.screen(screen)
    window = info.root
    
    res = randr.get_screen_resources(window)
    
    for output in res.outputs:
        params = d.xrandr_get_output_info(output, res.config_timestamp)
        if not params.crtc:
            continue
        crtc = d.xrandr_get_crtc_info(params.crtc, res.config_timestamp)
        modes = set()
        for mode in params.modes:
            modes.add(find_screen_mode(mode, res.modes))
        result.append({
            "name": params.name,
            "resolution": "{}x{}".format(crtc.width, crtc.height),
            "resolution_ratio": int(crtc.width) / int(crtc.height),
            "available_resolution": list(modes)
        })
    return result
    

def filter_resolution_by_ratio(ratio, avail_res):
    output = []
    for res in avail_res:
        width, height = res.split("x")
        res_ratio = int(width) / int(height)
        if abs(res_ratio - ratio) < 0.00001:
            output.append(res)
    return output
    

def find_highest_similar_res(*monitor_res):
    highest_res = ""
    highest_val = 0
    all_res = []
    for m in monitor_res:
        for res in m:
            num_res = list(map(int, res.split("x")))
            all_res.append(num_res)

    all_res.sort(key=lambda x: x[0] * x[1], reverse=True)
    n_res = len(monitor_res)
    for res in all_res:
        if all_res.count(res) == n_res:
            highest_res = "{}x{}".format(*res)
            break
    return highest_res
    

def get_highest_available_res():
    result = get_display_info()
    avail_res = [
        filter_resolution_by_ratio(i["resolution_ratio"], i["available_resolution"])
        for i in result
    ]
    return find_highest_similar_res(*avail_res)
    
        
if __name__ == "__main__":
    print(get_highest_available_res())
