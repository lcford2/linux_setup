
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

if [ -d ~/.local/bin ]; then
    if [[ ! :$PATH: == *:"$~/.local/bin":* ]] ; then
        export PATH=~/.local/bin:$PATH
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
alias cat="bat --style header --style rules --style snip --style changes"


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

eval "$(direnv hook zsh)"

export EDITOR=/usr/local/bin/nvim

source $HOME/cloned_repos/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
