" Jan's vimrc

" source system wide vimrc
if filereadable("/etc/vimrc")
    source /etc/vimrc
endif

set nocompatible
if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
endif
"set background=dark

if has("autocmd")
    " jump to the last position when reopening a file
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    " expand all folds
    autocmd BufWinEnter * normal zR
    " load indentation rules and plugins according to the detected filetype.
    filetype plugin indent on
endif

" soft tab indentation
set expandtab
set shiftwidth=4
set softtabstop=4

" hard tabs
"set shiftwidth=4
"set tabstop=4

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set incsearch		" Incremental search
"set autowrite		" Automatically save before commands like :next and :make
set hidden             " Hide buffers when they are abandoned
if has('mouse')
    set mouse=a		" Enable mouse usage (all modes)
endif

set modeline
set modelines=5

" non-sucky colors?
colorscheme ron
highlight Folded term=standout ctermbg=black ctermfg=white
highlight Comment term=bold ctermfg=darkblue
highlight PreProc term=underline cterm=bold ctermfg=lightcyan
highlight Identifier term=underline cterm=bold ctermfg=lightgreen

" help by keyword under cursor
function PassWordUnderCursor()
    "if !empty($STY)
    "    " we are in screen
    "    execute "!echo -en '\033k'".shellescape("vimhelp: " . expand("<cword>"), 1)"'\033\\'"
    "    redraw!
    "    sleep 500m
    "    execute "!echo -en '\033k'".shellescape("vim: %")"'\033\\'"
    "    redraw!
    "else
    "    "execute "!echo -en '\033]2;'".shellescape("vimhelp: " . expand("<cword>"), 1)"'\007'"
    "    execute "!echo -en '\033]2;'".shellescape("vimhelp: https://www.gnu.org/software/bash/manual/bash.html#index-" . expand("<cword>"), 1)"'\007'"
    "    redraw!
    "    sleep 500m
    "    execute "!echo -en '\033]2;'".shellescape("vim: %")"'\007'"
    "    redraw!
    "endif
    execute "!$HOME/bin/vim-url-router.sh " . shellescape(expand("<cword>"), 1) . " " . shellescape(expand(&filetype)) . " " .shellescape("%")
    redraw!
endfunction

nnoremap <F1> :silent! :call PassWordUnderCursor()<CR><C-L>

let g:myfiletocommit = ''
let g:mycommitmessagebuf = ''
function GitCommitCurrentFileTmpFile()
    "TODO: check if buffer changed and save or display hint.
    if &mod
        write
    endif
    if g:myfiletocommit == ''
        let g:myfiletocommit = expand('%:p')
        let filechanged = system("git diff --name-only " . g:myfiletocommit)
        if filechanged != ''
            let g:mycommitmessagefile = tempname()
            exec "split " . g:mycommitmessagefile
            let g:mycommitmessagebuf = bufnr("%")
        else
            echo "no changes to commit."
            let g:myfiletocommit = ''
        endif
    else
        echo "buffer to edit git commit message already open. bufnr: " . g:mycommitmessagebuf
    endif
endfunction
map <F5> :call GitCommitCurrentFileTmpFile() <CR>

function GitCommitCurrentFile()
    if g:mycommitmessagebuf == bufnr("%")
        if filereadable(g:mycommitmessagefile)
            exec "!git add " . g:myfiletocommit
            exec "!git commit --file " . g:mycommitmessagefile
            exec "!git pull origin master"
            exec "!git push origin master"
        endif
        let g:myfiletocommit = ''
        let g:mycommitmessagebuf = ''
        let g:mycommitmessagefile = ''
    endif
endfunction

au BufWinLeave * call GitCommitCurrentFile()
