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


if [[ $TERM == "xterm-kitty" ]]; then
    alias ssh="kitty +kitten ssh"
fi

if [ -d /home/linuxbrew/.linuxbrew ]; then
    export PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"
fi

# alias vim
export EDITOR="$(which nvim)"
alias vim="$EDITOR"
alias vi="$EDITOR"


if [ -f $HOME/.autojump/share/autojump/autojump.zsh ]; then
    source $HOME/.autojump/share/autojump/autojump.zsh
fi

# math function
math() {
  python -c "from math import *; print($1)"
}

f2i() {
  ~/.local/bin/float_2_inch.py $1
}

# flutter setup
if [ -d "${HOME}/source/flutter" ]; then
  export PATH="$PATH:$HOME/source/flutter/bin"
fi

if [ -d "$HOME/balena-cli" ]; then
  export PATH="$HOME/balena-cli:$PATH"
fi

export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_DEFAULT_OPTS="--height 40% --preview 'bat --color=always --style=numbers --line-range=:500 {}'"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/dotfiles/fzf/fzf-git.sh ] && source ~/dotfiles/fzf/fzf-git.sh

# register auto complete for commitizen
eval "$(zoxide init --cmd cd zsh)"

if [[ "$(uname)" == "Darwin" ]]; then
  test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
  alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
  export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"

  # docker path
  export PATH="/Applications/Docker.app/Contents/Resources/bin:$PATH"
  export OPENSSL_ROOT_DIR=/opt/homebrew/opt/openssl@3

  # add brew bin to path
  export PATH="/opt/homebrew/bin:${PATH}"
  export PATH=${PATH}:/Users/lucas/Library/Python/3.13/bin

  export STM32_PRG_PATH=/Applications/STMicroelectronics/STM32Cube/STM32CubeProgrammer/STM32CubeProgrammer.app/Contents/MacOs/bin
fi

export SAMBA_USERNAME="botbuilt"
export SAMBA_PASSWORD="botbuilt"

export ZEPHYR_BASE=~/zephyrproject/zephyr

if [ -f "$HOME/.secrets/keys.sh" ]; then
    source "$HOME/.secrets/keys.sh"
fi

if [ -d $HOME/balena-cli ]; then
    if [[ ! :$PATH: == *:"$HOME/balena-cli":* ]] ; then
        export PATH=$HOME/balena-cli:$PATH
    fi
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export ZEPHYR_BASE=~/zephyrproject/zephyr

if [[ "$TERM" == "xterm-ghostty" ]]; then
  echo "Ghostty terminal detected, changing term to xterm-256color"
  export TERM="xterm-256color"
fi

export BARTIB_FILE="$HOME/Nextcloud/time-tracker/tracker_file"
