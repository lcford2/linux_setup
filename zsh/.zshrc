# History

export HISTSIZE=1000000
export SAVEHIST=$HISTSIZE
export HISTFILE=~/.zshhistory
setopt EXTENDED_HISTORY

# completion
autoload -U compinit
compinit
zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XGD_CACHE_HOME/zsh/.zcompcache"
zstyle ':completion:*' menu select

# key style
bindkey -e
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

if [ -d $HOME/.local/bin ]; then
    if [[ ! :$PATH: == *:"$HOME/.local/bin":* ]] ; then
        export PATH=$HOME/.local/bin:$PATH
    fi
fi

if [ -d $HOME/.cargo/bin ]; then
    if [[ ! :$PATH: == *:"$HOME/.cargo/bin":* ]]; then
        export PATH=$HOME/.cargo/bin:$PATH
    fi
fi

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

# nvim
alias vim="nvim"

# pyenv
export PYENV_ROOT=$HOME/.pyenv
export PATH=$PYENV_ROOT/bin:$PATH

if [ -f $HOME/.autojump/share/autojump/autojump.zsh ]; then
    source $HOME/.autojump/share/autojump/autojump.zsh
fi

export DIRENV_LOG_FORMAT=""
eval "$(direnv hook zsh)"

export EDITOR=/usr/local/bin/nvim

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

eval "$(mcfly init zsh)"

source $HOME/source/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
