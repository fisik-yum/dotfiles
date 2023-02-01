#fisik's ~/.bashrc
#
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

##on startup
pfetch

alias ls='ls -a --color=auto'
alias shellreload='clear && source $HOME/.bashrc'
alias clearpkg='sudo pacman -Rns $(pacman -Qtdq)'
alias rename='mv'

PATH="$PATH:/$HOME/bin"

export PROMPT="{:text:lred;;bold}{user}@{host} {:text:white;;bold}\W{:text:lcyan;;bold} {:go:(go: %s) }{:text:green;;bold}{:git:(branch: %b)} {:text:lblue;;bold}/#/ {:text:;;}"

naf_prompt() { 
    export PS1=$(nafprompt); 
}
PROMPT_COMMAND=naf_prompt


