# History

export HISTSIZE=1000000
export SAVEHIST=$HISTSIZE
export HISTFILE=~/.zshhistory
setopt EXTENDED_HISTORY

# completion
zstyle ':completion:*' completer _complete _ignored
autoload -U compinit
compinit
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XGD_CACHE_HOME/zsh/.zcompcache"
zstyle ':completion:*' menu select

autoload -U +X compinit
compinit

autoload -U +X bashcompinit && bashcompinit
eval "$(register-python-argcomplete3 ros2)"
eval "$(register-python-argcomplete3 colcon)"

source $HOME/source/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/source/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/source/ohmyzsh/plugins/sudo/sudo.plugin.zsh

# key style
# bindkey -e
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[1;5C' emacs-forward-word
bindkey '^[[1;5D' emacs-backward-word
bindkey "^[[3~" delete-char

if [ -d $HOME/.local/bin ]; then
    if [[ ! :$PATH: == *:"$HOME/.local/bin":* ]] ; then
        export PATH=$HOME/.local/bin:$PATH
    fi
fi

. "$HOME/.cargo/env"

eval "$(starship init zsh)"

## Useful aliases
# use exa instead of ls
alias ls="exa -alg --color=always --group-directories-first --icons"      # preferred listing
alias la="exa -a --color=always --group-directories-first --icons"        # all files and dirs
alias ll="exa -lg --color=always --group-directories-first --icons"       # long format
alias lt="exa -aT --color=always --group-directories-first --icons"       # tree listing
alias l.="exa -a | egrep '^\.'"                                           # show only dot files
alias lg="exa -al --color=always --group-directories-first --icons --git" # git status

# use bat instead of cat
alias cat="bat --style='header,rule,changes,numbers'"
alias grep="rg"
alias find="fd"
alias df="duf"
alias du="dust"
alias fzfp="fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'"


if [[ $TERM == "xterm-kitty" ]]; then
    alias ssh="kitty +kitten ssh"
fi

# alias vim
alias vim="nvim"
export EDITOR="$(which nvim)"

# pyenv
export PYENV_ROOT=$HOME/.pyenv
export PATH=$PYENV_ROOT/bin:$PATH

if [ -f /usr/share/autojump/autojump.sh ]; then
    source /usr/share/autojump/autojump.sh
fi

export DIRENV_LOG_FORMAT=""
eval "$(direnv hook zsh)"


# export PYENV_ROOT="$HOME/.pyenv"
# command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init -)"


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

export FAST_DOWNWARD_PATH="/home/lucas/dev/wall_panels/downward"

function config-bb-direnv () {
    direnv deny $HOME/dev/wall_panels
    pushd $HOME/dev/wall_panels
    source bb_ws/install/setup.zsh
    export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
    direnv dump > .envrc.cache
    direnv allow .
    popd
}

function botbuild () {
    direnv deny $HOME/dev/wall_panels
    pushd $HOME/dev/base_ws
    source $HOME/dev/base_ws/install/setup.zsh
    cd ../wall_panels/bb_ws
    colcon build --cmake-args \
        -DCMAKE_BUILD_TYPE=RelWithDebInfo \
        -DCMAKE_EXPORT_COMPILE_COMMANDS=1 \
        -DCMAKE_CXX_FLAGS=-w \
        --symlink-install \
        "$@"
    source install/setup.zsh
    export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
    cd ..
    direnv dump > .envrc.cache
    direnv allow $HOME/dev/wall_panels
    popd
}

function isaac_env_setup () {
  export LD_LIBRARY_PATH=
  export RMW_IMPLEMENTATION=
  export FASTRTPS_DEFAULT_PROFILES_FILE="/home/lucas/.local/share/ov/pkg/isaac_sim-2022.2.1/ros2_workspace/fastdds.xml"
}

alias cdw="cd $HOME/dev/wall_panels/bb_ws"
export ROS_DOMAIN_ID=44

# Isaac Sim Python
alias omni-python="$HOME/.local/share/ov/pkg/isaac_sim-2022.2.0/python.sh"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/lucas/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/lucas/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/lucas/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/lucas/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
#r <<< conda initialize <<<
# nicer git commands
alias pglog="git log --graph --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%an%C(reset)%C(bold yellow)%d%C(reset) %C(dim white)- %s%C(reset)' --all"

# docker stuff
export PATH=/usr/bin:$PATH
# Some applications may require the following environment variable too:
# export DOCKER_HOST=unix:///run/user/1000/docker.sock


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH=$PATH:/home/lucas/source/remora-2.0/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/lucas/source/remora-2.0/lib
export REMORA_BIN=/home/lucas/source/remora-2.0/bin

source /home/lucas/.config/broot/launcher/bash/br
alias brw="br $HOME/dev/wall_panels/bb_ws/src"
