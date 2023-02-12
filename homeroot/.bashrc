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

export PROMPT="{:text:red;;bold}{user}@{host} {:text:white;;bold}\W{:text:lcyan;;bold} {:go:(go: %s) }{:text:green;;bold}{:git:(branch: %b) }{:text:lblue;;bold}/#/ {:text:;;}"

naf_prompt() { 
    export PS1=$(nafprompt); 
}
PROMPT_COMMAND=naf_prompt

source $HOME/bin/ps1exp
STANDBY_PROMPT="{:text:red;;bold}{user}@{host} {:text:white;;bold}\W{:text:lcyan;;bold} {:go:(go: %s) }{:text:lblue;;bold}/#/ {:text:;;}"

