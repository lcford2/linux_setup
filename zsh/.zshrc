export KITTY_CONFIG_DIRECTORY="~/.config/kitty"

# History
export HISTSIZE=1000000
export SAVEHIST=$HISTSIZE
export HISTFILE=~/.zshhistory
setopt EXTENDED_HISTORY

# source custom completions
fpath=(~/.zsh/completion $fpath)

# Configure ZAP
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"
plug "zsh-users/zsh-syntax-highlighting"
plug "greymd/docker-zsh-completion"

# Load and initialise completion system
# Enable incremental completion
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s

# Use menu select to navigate through options
zstyle ':completion:*' menu select=long-list

# Avoid automatically completing the first match
zstyle ':completion:*' accept-exact false

# Only complete up to the first ambiguity
setopt noautomenu
setopt listambiguous

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
# use eza instead of ls
alias ls="eza -alg --color=always --group-directories-first --icons"      # preferred listing
alias la="eza -a --color=always --group-directories-first --icons"        # all files and dirs
alias ll="eza -lg --color=always --group-directories-first --icons"       # long format
alias lt="eza -aT --color=always --group-directories-first --icons"       # tree listing
alias l.="eza -a | egrep '^\.'"                                           # show only dot files
alias lg="eza -al --color=always --group-directories-first --icons --git" # git status

# use bat instead of cat
alias cat="bat --style='header,rule,changes,numbers'"
alias grep="rg"
alias find="fd"
alias df="duf"
alias du="dust"
alias fzf="fzf \
  --height 40% \
  --preview 'bat --color=always --style=numbers --line-range=:500 {}'"
# nicer git commands
alias pglog="git log --graph --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%an%C(reset)%C(bold yellow)%d%C(reset) %C(dim white)- %s%C(reset)' --all"


if [[ $TERM == "xterm-kitty" ]]; then
    alias ssh="kitty +kitten ssh"
fi

# alias vim
export EDITOR="$(which nvim)"
alias vim="$EDITOR"
alias vi="$EDITOR"


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export FAST_DOWNWARD_PATH="/home/lucas/dev/wall_panels/downward"
export ROS_DOMAIN_ID=44
export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
alias cdw="cd $HOME/dev/wall_panels/bb_ws"


if [ -d "$HOME/balena-cli" ]; then
  export PATH="$PATH:$HOME/balena-cli"
fi

export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_DEFAULT_OPTS="--height 40% --preview 'bat --color=always --style=numbers --line-range=:500 {}'"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/dotfiles/fzf/fzf-git.sh ] && source ~/dotfiles/fzf/fzf-git.sh

function botbuild () {
    # direnv deny $HOME/dev/wall_panels
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
    # cd ..
    # direnv dump > .envrc.cache
    # direnv allow $HOME/dev/wall_panels
    popd
}

# register auto complete for commitizen
eval "$(zoxide init --cmd cd zsh)"

export SAMBA_USERNAME="botbuilt"
export SAMBA_PASSWORD="botbuilt"


fpath+=${ZDOTDIR:-~}/.zsh_functions

# eval "$(zoxide init zsh --cmd cd)"
eval $(thefuck --alias)
