#!/bin/bash
#
# vim: set foldmethod=marker:
#

status_text="vim: ${vim_buffer_file}"


# {{{ get vars from command line
word_under_cursor=$1
filetype=$2
vim_buffer_file=$3
arg4=$4
arg5=$5
# }}}

# {{{ Debug
#echo "word_under_cursor: $word_under_cursor" >/tmp/vim-url-router.log
#echo "filetype: $filetype" >>/tmp/vim-url-router.log
#echo "vim_buffer_file: $vim_buffer_file" >>/tmp/vim-url-router.log
#echo "arg4: $arg4" >>/tmp/vim-url-router.log
#echo "arg5: $arg5" >>/tmp/vim-url-router.log
# }}}

# start a subshell
(

# {{{ Branching code
# Default destination: Google
url="https://www.google.com/#q=${filetype}%20${word_under_cursor}"

# Vim
if [[ "x${filetype}" == "xvim" ]] ; then
    case ${word_under_cursor} in
        # Template:
        #keyword)   url="" ;;
        *)  url="https://www.google.com/#q=${filetype}%20${word_under_cursor}" ;;
    esac
fi

# Shell / Bash
if [[ "x${filetype}" == "xsh" ]] ; then
    case ${word_under_cursor} in
        #read)   url="https://www.gnu.org/software/bash/manual/bash.html#index-read" ;;
        'read')   url="http://wiki.bash-hackers.org/commands/builtin/read" ;;
        'echo')   url="http://wiki.bash-hackers.org/commands/builtin/echo" ;;
        'case')   url="http://wiki.bash-hackers.org/syntax/ccmd/case" ;;
        # Template:
        #keyword)   url="" ;;
        *)  url="https://www.google.com/#q=bash%20${word_under_cursor}" ;;
    esac
fi

if [[ "x${filetype}" == "xperl" ]] ; then
    case ${word_under_cursor} in
        #'chomp')   url="http://perldoc.perl.org/functions/chomp.html" ;;
        # Template:
        #keyword)   url="" ;;
        #)   url="https://perldoc.perl.org/functions/${word_under_cursor}" ;;
        #*)  url="https://www.google.com/#q=perl%20${word_under_cursor}" ;;
        *)  url="http://perldoc.perl.org/search.html?q=${word_under_cursor}" ;;
    esac
fi
# }}}

# {{{ write out search_str into Putty title
search_str="vimhelp: ${url} "

if [[ ! -z $STY ]] ; then
    #we are in screen
    echo -en "\033k${search_str}\033\\"
    sleep 1
    echo -en "\033k${status_text}\033\\"
else
    echo -en "\033]2;${search_str}\007"
    sleep 1
    echo -en "\033]2;${status_text}\007"
fi
# }}}

) &

exit 0
