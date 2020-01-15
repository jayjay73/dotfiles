# .bashrc
#
# vim: set foldmethod=marker:
#

_set_ssh_auth_sock() {
    if [[ "x$TERM" == "xscreen" ]] ; then
        if [[ ! -S "$SSH_AUTH_SOCK" ]] ; then
            ssh_pts=$(who -m | awk '{print $NF}' | awk -F':' '{print $2}')
            ssh_pid=$(pgrep -f "sshd: .+@${ssh_pts}")
            SSH_AUTH_SOCK=$(find /tmp/ssh-* -name "agent.${ssh_pid}" 2>/dev/null)
            if [[ $? -eq 0 ]] ; then
                unset ssh_pts ssh_pid
                export SSH_AUTH_SOCK
            fi
        fi
    fi
}

# not an interactive shell? return...
[[ -z $PS1 ]] && return

# UID below 200? return... exception: UID 0
if [ -n "$BASH_VERSION" -o -n "$KSH_VERSION" -o -n "$ZSH_VERSION" ]; then
    [ -x /usr/bin/id ] || return
    ID=`/usr/bin/id -u`
    [ -n "$ID" -a "$ID" -le 200 -a "$ID" -ne 0 ] && return
fi

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoredups:ignorespace
shopt -s histappend
export PROMPT_COMMAND="history -a"
PROMPT_DIRTRIM=2

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# fancy stuff
NORMAL='\[\e[0m\]'
BOLD='\[\e[1m\]'
BLACK='\[\e[0;30m\]'
DARKGRAY='\[\e[1;30m\]'
RED='\[\e[31m\]'
GREEN='\[\e[32m\]'
BROWN='\[\e[0;33m\]'
YELLOW='\[\e[1;33m\]'
BLUE='\[\e[34m\]'
PURPLE='\[\e[35m\]'
CYAN='\[\e[36m\]'
LIGHTGRAY='\[\e[0;37m\]'
WHITE='\[\e[1;37m\]'

color_prompt=
if [[ $(uname) == "FreeBSD" ]] ; then
    [[ -x /usr/bin/tput ]] && ncolors=$(tput color)
    if [[ $ncolors -ge 8 ]] ; then 
        color_prompt=yes
    fi
elif [[ $(uname) == "Linux" ]] ; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        color_prompt=yes
    fi
fi

if [ "$color_prompt" = yes ]; then
    if [[ $UID -eq 0 ]] ; then
        #PS1='\[\033[01;31m\]\u\[\033[01;33m\]@\[\033[01;36m\]\h\[\033[00m\]:\[\033[01;94m\]\w\[\033[00m\]\$ '
        #PS1="${RED}\u${NORMAL}@${CYAN}\h:${BLUE}\w${NORMAL}$ "
        PS1="${RED}${BOLD}\u${NORMAL}@${CYAN}${BOLD}\h${NORMAL}:${BLUE}${BOLD}\w${NORMAL}[${YELLOW}\$?${NORMAL}]\$ "
    else
        #PS1='\[\033[01;32m\]\u\[\033[01;33m\]@\[\033[01;36m\]\h\[\033[00m\]:\[\033[01;94m\]\w\[\033[00m\]\$ '
        #PS1="${GREEN}\u${NORMAL}@${CYAN}\h:${BLUE}\w${NORMAL}$ "
        PS1="${GREEN}${BOLD}\u${NORMAL}@${CYAN}${BOLD}\h${NORMAL}:${BLUE}${BOLD}\w${NORMAL}[${YELLOW}\$?${NORMAL}]\$ "
    fi
    OS_VERSION=$( perl -n -e 'print $1 if /OracleLinux ([\S]+)/' /etc/motd )
    if [ -n "$OS_VERSION" ]; then
        echo $PS1 | grep $OS_VERSION >/dev/null || PS1="${RED}${BOLD}${OS_VERSION}${NORMAL} ${PS1}"
    fi
else
    PS1='\u@\h:\w\$ '
fi
unset NORMAL BOLD BLACK DARKGRAY RED GREEN BROWN YELLOW BLUE PURPLE CYAN LIGHTGRAY WHITE color_prompt ncolors

# If this is an xterm set the title to user@host:dir
case "$TERM" in
    xterm*|rxvt*)
    PS1="\[\e]0;\u@\h: \w\a\]$PS1"
    ;;
    *)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias mc='mc -x'
alias sudo='sudo '
alias vim='TERM=xterm vim -u ${HOME}/.vimrc'

## make ssh agent forwarding work inside screen
#if [[ -S "$SSH_AUTH_SOCK" && ! -h "$SSH_AUTH_SOCK" ]]; then
#    ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock;
#    export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock;
#fi

# If we are inside screen...
# FIXME: use $STY
#case "$TERM" in
#    screen*)
#    # ...set the screen window title to user@host:dir
#    PS1="\[\033k\w +\$numjobs\a\033\\\\\]$PS1"
#    #echo -e '\033k'[$PWD]'\033\\'
#    trap 'export numjobs=$(jobs | wc -l); echo -ne \\033k$BASH_COMMAND\\033\\\\' DEBUG
#    ;;
#    *)
#    ;;
#esac

if [[ "x$TERM" == "xscreen" ]] ; then
    # ...set the screen window title to user@host:dir
    PS1="\[\033k\w +\$numjobs\a\033\\\\\]$PS1"
    #echo -e '\033k'[$PWD]'\033\\'
    trap 'export numjobs=$(jobs | wc -l); echo -ne \\033k$BASH_COMMAND\\033\\\\' DEBUG
    export PROMPT_COMMAND+=" ; _set_ssh_auth_sock"
fi

