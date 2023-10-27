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
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes
fpath+=~/.zfunc

autoload -U +X compinit
compinit

autoload -U +X bashcompinit && bashcompinit
eval "$(register-python-argcomplete3 ros2)"
eval "$(register-python-argcomplete3 colcon)"

source ~/source/zsh-autosuggestions/zsh-autosuggestions.zsh

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
export EDITOR="/usr/bin/nvim"
alias vim="$EDITOR"
alias vi="$EDITOR"

# pyenv
export PYENV_ROOT=$HOME/.pyenv
export PATH=$PYENV_ROOT/bin:$PATH

if [ -f $HOME/.autojump/share/autojump/autojump.zsh ]; then
    source $HOME/.autojump/share/autojump/autojump.zsh
fi

export DIRENV_LOG_FORMAT=""
eval "$(direnv hook zsh)"

export EDITOR="$(which nvim)"

# export PYENV_ROOT="$HOME/.pyenv"
# command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init -)"

export MCFLY_KEY_SCHEME=vim
export MCFLY_FUZZY=2
export MCFLY_RESULTS=50
export MCFLY_RESULTS_SORT=LAST_RUN
export MCFLY_HISTORY_LIMIT=10000
eval "$(mcfly init zsh)"


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

export FAST_DOWNWARD_PATH="/home/lucas/dev/wall_panels/downward"
export ROS_DOMAIN_ID=44
export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
alias cdw="cd $HOME/volume_dev/wall_panels/bb_ws"
alias bbstart="sudo docker exec botbuilt-amd64-desktop-devel /home/developer/.local/bin/kitty"

function config-bb-direnv () {
    pushd $HOME/dev/wall_panels
    direnv deny .
    source bb_ws/install/setup.zsh
    direnv dump > .envrc.cache
    direnv allow .
    popd
}

function botbuild () {
    colcon build --cmake-args -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -DCMAKE_CXX_FLAGS=-w --symlink-install && \
      config-bb-direnv
}



# Isaac Sim Python
alias omni-python="$HOME/.local/share/ov/pkg/isaac_sim-2022.1.1/python.sh"

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
# <<< conda initialize <<<

# cuda setup
if [ -d /usr/local/cuda ]; then
  export PATH=/usr/loca/cuda/bin:$PATH
fi

# gurobi setup
export GUROBI_HOME="/opt/gurobi1000/linux64"
export PATH="${PATH}:${GUROBI_HOME}/bin"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${GUROBI_HOME}/lib"

# tesseract setup
export TESSDATA_PREFIX="${HOME}/.tesseract-data"

# math function
math() {
  python -c "from math import *; print($1)"
}

f2i() {
  ~/.local/bin/float_2_inch.py $1
}

# flutter setup
export PATH="$PATH:$HOME/source/flutter/bin"

if [ -d "$HOME/balena-cli" ]; then
  export PATH="$PATH:$HOME/balena-cli"
fi

source $HOME/source/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source /home/lucas/.config/broot/launcher/bash/br
