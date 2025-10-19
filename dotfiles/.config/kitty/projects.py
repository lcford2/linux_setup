import os
import re
import sys
import json
import glob
import argparse
from contextlib import suppress
from typing import (
    TYPE_CHECKING,
    Callable,
    Dict,
    Iterator,
    List,
    NamedTuple,
    Optional,
    Tuple,
    Union
)

from kitty.constants import cache_dir
from kitty.fast_data_types import truncate_point_for_length, wcswidth
from kitty.typing import BossType, KeyEventType, TypedDict
from kitty.utils import ScreenSize
from kitty.boss import Boss

from kittens.tui.handler import Handler, result_handler
from kittens.tui.loop import Loop, MouseEvent, debug
from kittens.tui.operations import MouseTracking, styled

if TYPE_CHECKING:
    import readline

    debug
else:
    readline = None

PROJ_FILE = os.path.expanduser("~/.config/kitty/projects.json")
STATE_FILE = os.path.expanduser("~/.config/kitty/project_state.json")


def get_history_items() -> List[str]:
    return list(
        map(
            readline.get_history_item,
            range(1, readline.get_current_history_length() + 1),
        )
    )


def sort_key(item: str) -> Tuple[int, str]:
    return len(item), item.lower()


class HistoryCompleter:
    def __init__(self, name: Optional[str] = None):
        self.matches: List[str] = []
        self.history_path = None
        if name:
            ddir = os.path.join(cache_dir(), "ask")
            with suppress(FileExistsError):
                os.makedirs(ddir)
            self.history_path = os.path.join(ddir, name)

    def complete(self, text: str, state: int) -> Optional[str]:
        response = None
        if state == 0:
            history_values = get_history_items()
            if text:
                self.matches = sorted(
                    (h for h in history_values if h and h.startswith(text)),
                    key=sort_key,
                )
            else:
                self.matches = []
        try:
            response = self.matches[state]
        except IndexError:
            response = None
        return response

    def __enter__(self) -> "HistoryCompleter":
        if self.history_path:
            with suppress(Exception):
                readline.read_history_file(self.history_path)
            readline.set_completer(self.complete)
        return self

    def __exit__(self, *a: object) -> None:
        if self.history_path:
            readline.write_history_file(self.history_path)


class Response(TypedDict):
    items: List[str]
    response: Optional[str]


class Choice(NamedTuple):
    text: str
    idx: int
    color: str
    letter: str


class Range(NamedTuple):
    start: int
    end: int
    y: int

    def has_point(self, x: int, y: int) -> bool:
        return y == self.y and self.start <= x <= self.end


def truncate_at_space(text: str, width: int) -> Tuple[str, str]:
    p = truncate_point_for_length(text, width)
    if p < len(text):
        i = text.rfind(" ", 0, p + 1)
        if i > 0 and p - i < 12:
            p = i + 1
    return text[:p], text[p:]


def extra_for(width: int, screen_width: int) -> int:
    return max(0, screen_width - width) // 2 + 1


class ChooseProject(Handler):  # {{{
    mouse_tracking = MouseTracking.buttons_only

    def __init__(self, projects: dict) -> None:
        self.prefix_style_pat = re.compile(r"(?:\x1b\[[^m]*?m)+")
        # self.cli_opts = cli_opts
        self.projects = projects
        self.choices: Dict[str, Choice] = {}
        self.clickable_ranges: Dict[str, List[Range]] = {}

        allowed = []
        for name, project in projects.items():
            letter = name[0]
            letter = letter.lower()
            idx = 0
            while letter in allowed:
                idx += 1
                try:
                    letter = name[idx].lower()
                except IndexError:
                    letter = ""
                    idx = -1

            color = ""
            allowed.append(letter)
            self.choices[letter] = Choice(name, idx, color, letter)

        self.allowed = frozenset(allowed)
        self.response = ""
        self.response_on_accept = self.choices[allowed[0]].text

        self.message = "Select which project to load:"
        # self.hidden_text_start_pos = self.hidden_text_end_pos = -1
        # self.hidden_text = ''
        # self.replacement_text = t = f'Press {styled(self.cli_opts.unhide_key, fg="green")} or click to show'
        # self.replacement_range = Range(-1, -1, -1)
        # if self.message and self.cli_opts.hidden_text_placeholder:
        #     self.hidden_text_start_pos = self.message.find(self.cli_opts.hidden_text_placeholder)
        #     if self.hidden_text_start_pos > -1:
        #         self.hidden_text = sys.stdin.read().rstrip()
        #         self.hidden_text_end_pos = self.hidden_text_start_pos + len(t)
        #         suffix = self.message[self.hidden_text_start_pos + len(self.cli_opts.hidden_text_placeholder):]
        #         self.message = self.message[:self.hidden_text_start_pos] + t + suffix

    def initialize(self) -> None:
        self.cmd.set_cursor_visible(False)
        self.draw_screen()

    def finalize(self) -> None:
        self.cmd.set_cursor_visible(True)

    def draw_long_text(self, text: str) -> Iterator[str]:
        if not text:
            yield ""
            return
        width = self.screen_size.cols - 2
        m = self.prefix_style_pat.match(text)
        prefix = m.group() if m else ""
        while text:
            t, text = truncate_at_space(text, width)
            t = t.strip()
            yield " " * extra_for(wcswidth(t), width) + styled(prefix + t, bold=True)

    @Handler.atomic_update
    def draw_screen(self) -> None:
        self.cmd.clear_screen()
        msg_lines: List[str] = []
        if self.message:
            for line in self.message.splitlines():
                msg_lines.extend(self.draw_long_text(line))
        y = self.screen_size.rows - len(msg_lines)
        y = max(0, (y // 2) - 2)
        self.print(end="\r\n" * y)
        for line in msg_lines:
            # if self.replacement_text in line:
            #     idx = line.find(self.replacement_text)
            #     x = wcswidth(line[:idx])
            #     self.replacement_range = Range(x, x + wcswidth(self.replacement_text), y)
            self.print(line)
            y += 1
        if self.screen_size.rows > 2:
            self.print()
            y += 1
        self.draw_choice(y)

    def draw_choice_boxes(self, y: int, *choices: Choice) -> None:
        self.clickable_ranges.clear()
        width = self.screen_size.cols - 2
        current_line_length = 0
        current_line: List[Tuple[str, str]] = []
        lines: List[List[Tuple[str, str]]] = []
        sep = "  "
        sep_sz = len(sep) + 2  # for the borders

        for choice in choices:
            self.clickable_ranges[choice.letter] = []
            text = " " + choice.text[: choice.idx]
            text += styled(choice.text[choice.idx], fg=choice.color or "green")
            text += choice.text[choice.idx + 1 :] + " "
            sz = wcswidth(text)
            if sz + sep_sz + current_line_length > width:
                lines.append(current_line)
                current_line = []
                current_line_length = 0
            current_line.append((choice.letter, text))
            current_line_length += sz + sep_sz
        if current_line:
            lines.append(current_line)

        def top(text: str) -> str:
            return "╭" + "─" * wcswidth(text) + "╮"

        def middle(text: str) -> str:
            return f"│{text}│"

        def bottom(text: str) -> str:
            return "╰" + "─" * wcswidth(text) + "╯"

        def highlight(text: str, only_edges: bool = False) -> str:
            if only_edges:
                return (
                    styled(text[0], fg="yellow")
                    + text[1:-1]
                    + styled(text[-1], fg="yellow")
                )
            return styled(text, fg="yellow")

        def print_line(
            add_borders: Callable[[str], str],
            *items: Tuple[str, str],
            is_last: bool = False,
        ) -> None:
            nonlocal y
            texts = []
            positions = []
            x = 0
            for (letter, text) in items:
                positions.append((letter, x, wcswidth(text) + 2))
                text = add_borders(text)
                if letter == self.response_on_accept:
                    text = highlight(text, only_edges=add_borders is middle)
                text += sep
                x += wcswidth(text)
                texts.append(text)
            line = "".join(texts).rstrip()
            offset = extra_for(wcswidth(line), width)
            for (letter, x, sz) in positions:
                x += offset
                self.clickable_ranges[letter].append(Range(x, x + sz - 1, y))
            self.print(" " * offset, line, sep="", end="" if is_last else "\r\n")
            y += 1

        self.cmd.set_line_wrapping(False)
        for boxed_line in lines:
            print_line(top, *boxed_line)
            print_line(middle, *boxed_line)
            print_line(bottom, *boxed_line, is_last=boxed_line is lines[-1])
        self.cmd.set_line_wrapping(True)

    def draw_choice(self, y: int) -> None:
        if y + 3 <= self.screen_size.rows:
            self.draw_choice_boxes(y, *self.choices.values())
            return
        self.clickable_ranges.clear()
        current_line = ""
        current_ranges: Dict[str, int] = {}
        width = self.screen_size.cols - 2

        def commit_line(end: str = "\r\n") -> None:
            nonlocal current_line, y
            x = extra_for(wcswidth(current_line), width)
            self.print(" " * x + current_line, end=end)
            for letter, sz in current_ranges.items():
                self.clickable_ranges[letter] = [Range(x, x + sz - 3, y)]
                x += sz
            current_ranges.clear()
            y += 1
            current_line = ""

        for letter, choice in self.choices.items():
            text = choice.text[: choice.idx]
            text += styled(
                choice.text[choice.idx],
                fg=choice.color or "green",
                underline="straight" if letter == self.response_on_accept else None,
            )
            text += choice.text[choice.idx + 1 :]
            text += "  "
            sz = wcswidth(text)
            if sz + wcswidth(current_line) >= width:
                commit_line()
            current_line += text
            current_ranges[letter] = sz
        if current_line:
            commit_line(end="")

    def draw_yesno(self, y: int) -> None:
        yes = styled("Y", fg="green") + "es"
        no = styled("N", fg="red") + "o"
        if y + 3 <= self.screen_size.rows:
            self.draw_choice_boxes(
                y, Choice("Yes", 0, "green", "y"), Choice("No", 0, "red", "n")
            )
            return
        sep = " " * 3
        text = yes + sep + no
        w = wcswidth(text)
        x = extra_for(w, self.screen_size.cols - 2)
        nx = x + wcswidth(yes) + len(sep)
        self.clickable_ranges = {
            "y": [Range(x, x + wcswidth(yes) - 1, y)],
            "n": [Range(nx, nx + wcswidth(no) - 1, y)],
        }
        self.print(" " * x + text, end="")

    def on_text(self, text: str, in_bracketed_paste: bool = False) -> None:
        text = text.lower()
        if text in self.allowed:
            # self.response = text
            self.response = self.choices[text].text
            self.quit_loop(0)

    def unhide(self) -> None:
        if self.hidden_text and self.message:
            self.message = (
                self.message[: self.hidden_text_start_pos]
                + self.hidden_text
                + self.message[self.hidden_text_end_pos :]
            )
            self.hidden_text = ""
            self.draw_screen()

    def on_key(self, key_event: KeyEventType) -> None:
        if key_event.matches("esc"):
            self.on_interrupt()
        elif key_event.matches("enter"):
            self.response = self.response_on_accept
            self.quit_loop(0)

    def on_click(self, ev: MouseEvent) -> None:
        for letter, ranges in self.clickable_ranges.items():
            for r in ranges:
                if r.has_point(ev.cell_x, ev.cell_y):
                    # self.response = letter
                    self.response = self.choices[letter].text
                    self.quit_loop(0)
                    return

    def on_resize(self, screen_size: ScreenSize) -> None:
        self.screen_size = screen_size
        self.draw_screen()

    def on_interrupt(self) -> None:
        self.quit_loop(1)

    on_eot = on_interrupt


def load_projects() -> dict:
    if os.path.exists(PROJ_FILE):
        with open(PROJ_FILE, "r") as f:
            projects = json.load(f)
    else:
        projects = {}
    return projects


def save_projects(projects: dict) -> None:
    if os.path.exists(PROJ_FILE):
        exist_proj = load_projects()
        projects = exist_proj | projects
    with open(PROJ_FILE, "w") as f:
        json.dump(projects, f, indent=4)


def create_project_dict(add_path: str, current_file="", conda=None, venv=None) -> dict:
    project_name = os.path.basename(add_path)
    if not conda:
        conda = os.environ.get("CONDA_PREFIX", None)
    if not venv:
        venv = os.environ.get("VIRTUAL_ENV", None)
    shell = os.path.basename(os.environ["SHELL"])
    log(f"in create_project_dict: conda={conda}, venv={venv}") 

    if conda:
        env_command = f"conda activate {conda}"
    elif venv:
        if shell in ["fish", "csh"]:
            activate_file = f"{venv}/bin/activate.{shell}"
        else:
            activate_file = f"{venv}/bin/activate"
        env_command = f"source {activate_file}"
        add_path = os.path.commonpath([
            add_path,
            venv,
        ])
    else:
        env_command = ""
    
    if current_file and not os.path.isabs(current_file):
        if not os.path.exists(os.path.join(add_path, current_file)):
            potential_paths = glob.glob(
                f"{add_path}/**/{current_file}",
                recursive=True
            )
            if len(potential_paths) == 0:
                current_file = ""
            else:
                current_file = potential_paths[0]
    
    project = {
        "name": project_name,
        "path": add_path,
        "current_file": current_file,
        "env_command": env_command,
        "is_git": os.path.exists(f"{add_path}/.git")
    }
    return project


def open_project(project: dict, target_window_id: int, boss: Boss):
    w = boss.window_id_map.get(target_window_id)
    cwd = project["path"]
    boss.call_remote_control(w, ("launch", "--type=tab", f"--cwd={cwd}"))
    boss.call_remote_control(w, ("launch", "--type=window", f"--cwd={cwd}", "--keep-focus"))
    if project["env_command"]:
        boss.call_remote_control(w, ("send-text", "--match=num:0", f"{project['env_command']}\n"))
        boss.call_remote_control(w, ("send-text", "--match=num:1", f"{project['env_command']}\n"))
    if project["current_file"]:
        file = project["current_file"]
        if os.path.split(file)[0] != "":
            file_dir = os.path.dirname(file)
            file = os.path.basename(file)
            command = f"cd {file_dir}\n vim {file}\n"
        else:
            command = f"vim {file}\n"
        boss.call_remote_control(w, ("send-text", "--match=recent:0", command))
    boss.call_remote_control(w, ("set-tab-title", "--match=recent:0", project["name"]))


def get_current_state_as_project(target_window_id: int, boss: Boss):
    w = boss.window_id_map.get(target_window_id)

    state = boss.call_remote_control(w, ("ls",))
    state = json.loads(state)

    with open("/home/lford/.config/kitty/state.json", "w") as f:
        json.dump(state, f, indent=2)

    window = state[0]
    tabs = window["tabs"]
    focused_tab = 0
    # need to loop through the windows in each tab to find the one that is in focus
    # this assumes that the user wants to save the tab with a a window in focus as
    # the project (aka the current tab)
    for i, tab in enumerate(tabs):
        for window in tab["windows"]:
            if window["is_focused"]:
                focused_tab = i

    tab = tabs[focused_tab]
    with open("/home/lford/.config/kitty/tab.json", "w") as f:
        json.dump(tab, f, indent=2)
    current_file = ""
    cwd = "~"
    conda = None
    venv = None
    # for the current tab, find the window where nvim is open
    # from this window, get the current file and the working directory
    # from the environment vairbal
    for window in tab["windows"]:
        if not current_file:
            for proc in window["foreground_processes"]:
                cmd = proc["cmdline"]
                cwd = proc["cwd"]
                if "nvim" in cmd:
                    current_file = cmd[-1]
                    break
        if not conda or not venv:
            conda = window["env"].get("CONDA_PREFIX", None)
            venv = window["env"].get("VIRTUAL_ENV", None)

    log(f"in get_current_state_as_project: conda={conda}, venv={venv}") 
    project = create_project_dict(cwd, current_file, conda=conda, venv=venv) 
    return project


def parse_args(args):
    parser = argparse.ArgumentParser(
        description="Kitten to save, load, and manage projects"
    )
    parser.add_argument(
        "-a",
        "--add",
        type=str,
        help="Add a project by providing the path to the project folder",
    )
    parser.add_argument(
        "-p",
        "--project",
        type=str,
        help="Select which project to open. Can use either the full path or the basename of the project directory"    )
    parser.add_argument("-s", "--save", action="store_true", help="Save current project.")
    return parser.parse_args(args) 


def main(args: List[str]) -> Union[dict, str]:
    # For some reason importing readline in a key handler in the main kitty process
    # causes a crash of the python interpreter, probably because of some global
    # lock
    global readline

    cli_opts = parse_args(args[1:])

    projects = load_projects()
    
    if cli_opts.add:
        add_path = os.path.expanduser(cli_opts.add)
        project = create_project_dict(add_path)
        projects[os.path.basename(add_path)] = project
        save_projects(projects)
        return os.path.basename(add_path)
    if cli_opts.save:
        return "save"
    else:
        if cli_opts.project:
            proj = os.path.basename(os.path.expanduser(cli_opts.project))
        else:
            loop = Loop()
            handler = ChooseProject(projects)
            loop.loop(handler)
            proj = os.path.basename(os.path.expanduser(handler.response))
        project = projects.get(proj)
        if project is None:
            print(f"{proj} is not a project. Projects can be added with kitty +kitten projects -a <project path>")
            return {}
        else:
            return project

    # prompt = cli_opts.prompt
    # if prompt[0] == prompt[-1] and prompt[0] in '\'"':
    #     prompt = prompt[1:-1]

    # import readline as rl
    # readline = rl
    # from kitty.shell import init_readline
    # init_readline()
    # response = None

    # with alternate_screen(), HistoryCompleter(cli_opts.name):
    #     if cli_opts.message:
    #         print(styled(cli_opts.message, bold=True))

    #     with suppress(KeyboardInterrupt, EOFError):
    #         if cli_opts.default:
    #             def prefill_text() -> None:
    #                 readline.insert_text(cli_opts.default or '')
    #                 readline.redisplay()
    #             readline.set_pre_input_hook(prefill_text)
    #             response = input(prompt)
    #             readline.set_pre_input_hook()
    #         else:
    #             response = input(prompt)
    # return {'items': items, 'response': response}


def log(msg, level="INFO", file="~/.config/kitty/projects.log"):
    from datetime import datetime
    file = os.path.expanduser(file)
    now = datetime.now().strftime("%Y-%m-%d %H:%M")
    logmsg = f"[projects - {level} - {now}]: {msg}\n"
    with open(file, "a") as f:
        f.write(logmsg)


@result_handler()
def handle_result(
        args: List[str], project: Union[dict, str], target_window_id: int, boss: BossType
) -> None:
    if isinstance(project, str) and project == "save":
        project = get_current_state_as_project(target_window_id, boss)
        save_projects({project["name"]: project})

    elif len(project) != 0:
        open_project(project, target_window_id, boss)

    # if data["response"] is not None:
    #     func, *args = data["items"]
    #     getattr(boss, func)(data["response"], *args)


if __name__ == "__main__":
    ans = main(sys.argv)
    # if ans:
    #     print(ans)
