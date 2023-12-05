# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin

export PATH
export EDITOR=/usr/bin/vim
export ANSIBLE_NOCOWS=1

export GIT_AUTHOR_EMAIL="$(awk -F':' "/${USER}/ {print \$5}" /etc/passwd | awk -F',' '{print $5}')"
export GIT_AUTHOR_NAME="$(awk -F':' "/${USER}/ {print \$5}" /etc/passwd | awk -F',' '{print $1}')"
export GIT_COMMITTER_EMAIL=${GIT_AUTHOR_EMAIL}
export GIT_COMMITTER_NAME=${GIT_AUTHOR_NAME}

