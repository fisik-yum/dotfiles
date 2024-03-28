#fisik's ~/.bashrc
#
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

init ()
{
    PATH="$PATH:/$HOME/bin"
    source qcd.bash
    QCD_MINIMUMLINES=100   
    qcd_init
    load
}


load ()
{
    pfetch 
    bind 'TAB:menu-complete'
    alias ls='ls -a --color=auto'
    alias shellreload='clear && load'
    alias clearpkg='sudo pacman -Rns $(pacman -Qtdq)'
    alias cd="qcd-transparent"

    #nafprompt configuration
    export PROMPT=" {:text:white;;bold}[\w]{:text:lcyan;;bold} {:go:(go: %s) }{:text:green;;bold}{:git:(branch: %b) }{:text:yellow;;bold}-> {:text:;;}"
    PROMPT_COMMAND=naf_prompt
}

naf_prompt() { 
    export PS1=$(nafprompt); 
}

init


