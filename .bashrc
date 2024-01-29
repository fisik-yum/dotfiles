#fisik's ~/.bashrc
#
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

##on startup
pfetch

#bind 'TAB:menu-complete'


alias ls='ls -a --color=auto'
alias shellreload='clear && source $HOME/.bashrc'
alias clearpkg='sudo pacman -Rns $(pacman -Qtdq)'
alias rename='mv'
alias wd='pwd'
alias dcss='TERM=xterm-256color ssh -i ~/.ssh/cao_key terminal@crawl.kelbi.org'
PATH="$PATH:/$HOME/bin"


#nafprompt configuration

export PROMPT=" {:text:white;;bold}[\w]{:text:lcyan;;bold} {:go:(go: %s) }{:text:green;;bold}{:git:(branch: %b) }{:text:yellow;;bold}-> {:text:;;}"

naf_prompt() { 
    export PS1=$(nafprompt); 
}
PROMPT_COMMAND=naf_prompt

source $HOME/bin/ps1exp
STANDBY_PROMPT=" {:text:white;;bold}[\w]{:text:lcyan;;bold} {:go:(go: %s) }{:text:green;;bold}{:text:yellow;;bold}-> {:text:;;}"


