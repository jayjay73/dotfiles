# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin

export PATH

export ANSIBLE_NOCOWS=1

export GIT_AUTHOR_EMAIL="${USER: -1}.${USER: 0: ${#USER}-1}@eos-ts.com"
export GIT_AUTHOR_NAME="$(awk -F':' "/${USER}/ {print \$5}" /etc/passwd | awk -F',' '{print $1}')"
export GIT_COMMITTER_EMAIL=${GIT_AUTHOR_EMAIL}
export GIT_COMMITTER_NAME=${GIT_AUTHOR_NAME}

