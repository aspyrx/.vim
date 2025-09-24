runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

colorscheme meta5

autocmd ColorScheme * highlight ColorColumn guifg=#ffffff guibg=#303030 ctermbg=238 "custom colorcolumn color

set encoding=utf-8 "UTF-8 character encoding
set tabstop=4  "4 space tabs
set shiftwidth=4  "4 space shift
set softtabstop=4  "Tab spaces in no hard tab mode
set expandtab  " Expand tabs into spaces
set autoindent  "autoindent on new lines
set showmatch  "Highlight matching braces
set ruler  "Show bottom ruler
set equalalways  "Split windows equal size
set formatoptions+=ncroq  "Enable comment line auto formatting
set textwidth=80 "80-column text formatting
set wildignore+=*.o,*.obj,*.class,*.swp,*.pyc,node_modules "Ignore junk files
set title  "Set window title to file
set hlsearch  "Highlight on search
set ignorecase  "Search ignoring case
set smartcase  "Search using smartcase
set incsearch  "Start searching immediately
set scrolloff=5  "Never scroll off
set wildmode=longest,list  "Better unix-like tab completion
set cursorline  "Highlight current line
set lazyredraw  "Don't redraw while running macros (faster)
set autochdir  "Change directory to currently open file
set linebreak  "Only wrap on 'good' characters for wrapping
set backspace=indent,eol,start  "Better backspacing
set linebreak  "Intelligently wrap long files
set nostartofline "Vertical movement preserves horizontal position
set number "Line numbers
set conceallevel=1 "Enable concealing characters
set nowrap "Don't wrap lines
set sidescroll=1 "Smooth scrolling
set listchars=extends:,precedes: "Overflow indicators
set sidescrolloff=1 "Keep cursor from scrolling onto overflow indicator
set mouse=a "Enable mouse support

" C-indenting:
" - open/close () aligned to outer context
" - do not add extra indent for scope declarations
" - indent Java/JS inline funcs/classes correctly
set cinoptions=(0,Ws,m1,g0,j1,J1
let g:javascript_indent_W_pat = '[^[:blank:]{[]'

set showtabline=2 "File tabs always visible

let mapleader = "\<Space>"
let g:mapleader = "\<Space>"

nnoremap <silent> <leader>T :tabprevious<cr>
nnoremap <silent> <leader>t :tabnext<cr>
nnoremap <silent> <C-t> :tabnew<cr>

" Rebind moving around windows to Ctrl+{h,j,k,l}
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" completion options
set completeopt+=menuone,noinsert,popup

if (!has("nvim"))
	" vim-specific configs
    set nocompatible  "Kill vi-compatibility
    set ttyfast  "Speed up vim
    set clipboard=unnamed  "Copy and paste from system clipboard
else
	" neovim-specific configs
	tnoremap <C-h> <C-\><C-n><C-w>h
    tnoremap <C-j> <C-\><C-n><C-w>j
    tnoremap <C-k> <C-\><C-n><C-w>k
    tnoremap <C-l> <C-\><C-n><C-w>l

    if (exists('&inccommand'))
        set inccommand=split
    endif

    function! Osc52Copy(lines)
        let base64 = system('base64', a:lines)
        call chansend(v:stderr, printf("\033]52;c;%s\07", base64))
    endfunction

    let g:clipboard = {
                \   'name': 'osc52',
                \   'copy': {
                \       '*': { lines, regtype -> Osc52Copy(lines) },
                \       '+': { lines, regtype -> Osc52Copy(lines) },
                \   },
                \   'paste': {
                \       '+': { -> [] },
                \       '*': { -> [] },
                \   },
                \ }

    " neomake settings
    let g:neomake_javascript_enabled_makers = ['eslint']
    let g:neomake_jsx_enabled_makers = ['eslint']
    call neomake#configure#automake('nw', 500)
endif

imap jk <Esc>
"Fast saving
nmap <leader>w :w!<cr>

" Strip whitespace from end of lines when writing file
function! <SID>StripTrailingWhitespaces()
    if &filetype == 'diff'
        return
    endif

    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" Syntax highlighting and stuff
filetype plugin indent on
syntax on

" Get rid of warning on save/exit typo
command WQ wq
command Wq wq
command W w
command Q q

" Highlight lines that are over 80 characters long
set colorcolumn=81

" Always show status bar
set laststatus=2

" Don't show the mode
set noshowmode

" Copy on backup
set backupcopy=yes

" lightline.vim
let g:lightline = {
            \ 'active': {
            \   'left': [ [ 'mode', 'paste' ], [ 'filename' ], [ 'ctrlpmark' ] ],
            \   'right': [ [ 'lineinfo' ], [ 'percent' ], [ 'fileformat', 'fileencoding', 'filetype' ] ],
            \ },
            \ 'component_function': {
            \   'mode': 'LightLineMode',
            \   'ctrlpmark': 'LightLineCtrlPMark',
            \   'filename': 'LightLineFilename',
            \   'fileformat': 'LightLineFileformat',
            \   'filetype': 'LightLineFiletype',
            \   'fileencoding': 'LightLineFileencoding',
            \ },
            \ 'separator': { 'left': '', 'right': '' },
            \ 'subseparator': { 'left': '', 'right': '' }
            \ }

function! LightLineMode()
    let fname = expand('%:t')
    return fname == 'ControlP' ? 'CtrlP' :
                \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! LightLineCtrlPMark()
    if expand('%:t') =~ 'ControlP' && has_key(g:lightline, 'ctrlp_item')
        call lightline#link('iR'[g:lightline.ctrlp_regex])
        return lightline#concatenate([g:lightline.ctrlp_prev, g:lightline.ctrlp_item
                    \ , g:lightline.ctrlp_next], 0)
    else
        return ''
    endif
endfunction

let g:ctrlp_status_func = {
  \ 'main': 'CtrlPStatusFunc_1',
  \ 'prog': 'CtrlPStatusFunc_2',
  \ }

function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
  let g:lightline.ctrlp_regex = a:regex
  let g:lightline.ctrlp_prev = a:prev
  let g:lightline.ctrlp_item = a:item
  let g:lightline.ctrlp_next = a:next
  return lightline#statusline(0)
endfunction

function! CtrlPStatusFunc_2(str)
  return lightline#statusline(0)
endfunction

function! LightLineModified()
    return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightLineReadonly()
    return &ft !~? 'help' && &readonly ? '' : ''
endfunction

function! LightLineFilename()
    let fname = expand('%:t')
    return ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
                \ ('' != fname ? fname : '[No Name]') .
                \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
endfunction

function! LightLineFileformat()
    return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightLineFiletype()
    return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! LightLineFileencoding()
    return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

" rainbow_parentheses.vim
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

" vim-javascript
let g:javascript_enable_domhtmlcss = 1
let g:javascript_conceal_function   = "ƒ"
let g:javascript_conceal_null       = "ø"
let g:javascript_conceal_this       = "@"
let g:javascript_conceal_return     = "←"
let g:javascript_conceal_undefined  = "¿"
let g:javascript_conceal_prototype  = "¶"

let g:jsx_ext_required = 0 " Allow JSX in normal JS files

" vim-localvimrc
" Disable confirmation of extra vimrc file. WARNING: THIS IS POTENTIALLY DANGEROUS
let g:localvimrc_ask = 0

" Disable sandboxing of extra vimrc file. WARNING: THIS IS POTENTIALLY DANGEROUS
let g:localvimrc_sandbox = 0

" ListToggle
let g:lt_location_list_toggle_map = '<leader>ll'

" loclist next/prev wraparound
nnoremap <silent> <leader>ln :silent! try<bar>lnext<bar>catch /^Vim\%((\a\+)\)\=:E\(553\<bar>42\):/<bar>lfirst<bar>catch<bar>endtry<cr>
nnoremap <silent> <leader>lN :silent! try<bar>lprev<bar>catch /^Vim\%((\a\+)\)\=:E\(553\<bar>42\):/<bar>llast<bar>catch<bar>endtry<cr>

" vim-markdown
let g:markdown_fenced_languages = [
            \ 'html', 'js=javascript', 'jsx=javascript', 'c', 'asm', 'arm',
            \ 'sh', 'python', 'diff'
            \ ]

