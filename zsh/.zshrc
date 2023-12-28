# handle XDG_CONFIG_DIR not being set
if [ -z "${XDG_CONFIG_HOME}" ]; then
  export XDG_CONFIG_HOME="${HOME}/.config"
fi

export KITTY_CONFIG_DIRECTORY="~/.config/kitty"

# History
export HISTSIZE=1000000
export SAVEHIST=$HISTSIZE
export HISTFILE=~/.zshhistory
setopt EXTENDED_HISTORY

# Configure ZAP
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
# plug "zap-zsh/zap-prompt"
plug "zsh-users/zsh-syntax-highlighting"
plug "greymd/docker-zsh-completion"

# Load and initialise completion system
autoload -Uz compinit
compinit

# completion
# zstyle ':completion:*' completer _complete _ignored
# autoload -U compinit
# compinit
# zstyle ':completion:*' use-cache on
# zstyle ':completion:*' cache-path "$XGD_CACHE_HOME/zsh/.zcompcache"
# zstyle ':completion:*' menu select
# zstyle ':completion:*:*:docker:*' option-stacking yes
# zstyle ':completion:*:*:docker-*:*' option-stacking yes
# fpath+=~/.zfunc

# autoload -U +X compinit
# compinit

# autoload -U +X bashcompinit && bashcompinit

# source ~/source/zsh-autosuggestions/zsh-autosuggestions.zsh

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
export EDITOR="$(which nvim)"
alias vim="$EDITOR"
alias vi="$EDITOR"


if [ -f $HOME/.autojump/share/autojump/autojump.zsh ]; then
    source $HOME/.autojump/share/autojump/autojump.zsh
fi

# export MCFLY_KEY_SCHEME=vim
# export MCFLY_FUZZY=2
# export MCFLY_RESULTS=50
# export MCFLY_RESULTS_SORT=LAST_RUN
# export MCFLY_HISTORY_LIMIT=10000
# eval "$(mcfly init zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export FAST_DOWNWARD_PATH="/home/lucas/dev/wall_panels/downward"
export ROS_DOMAIN_ID=44
export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
alias cdw="cd $HOME/dev/wall_panels/bb_ws"
alias bbstart="sudo docker exec botbuilt-amd64-desktop-devel /home/developer/.local/bin/kitty"


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

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PIPENV_PYTHON="$PYENV_ROOT/shims/python"

eval "$(pyenv init -)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
