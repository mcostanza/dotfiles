" Appearance
set guifont=Inconsolata\ XL:h20
set termguicolors
colorscheme base16-twilight
highlight Normal ctermfg=grey ctermbg=black

" Disable cursor blink
set gcr=a:blinkon0

" Display tabs and trailing spaces visually
set list listchars=tab:\ \ ,trail:·

" ================ Search ===========================
set incsearch       " Find the next match as we type the search
set hlsearch        " Highlight searches by default
set ignorecase      " Ignore case when searching...
set smartcase       " ...unless we type a capital

" PLUGIN SETTINGS

" ==== NERD tree
" Open NERDTree on gui startup if a directory was given as a startup arg
let g:nerdtree_tabs_open_on_gui_startup = 2

" Never open NERDTree when a new tab is created
let g:nerdtree_tabs_open_on_new_tab = 0

" Cmd-Shift-N to open nerd tree
nmap <D-N> :NERDTreeToggle<CR>

" gui settings
" Disable the scrollbars (NERDTree)
set guioptions-=r
set guioptions-=L

" Disable the macvim toolbar
set guioptions-=T

" Keybindings
" visually select the rest of the line except trailing space
vmap <Space> g_

",gg = Grep! - using Ag the silver searcher
" open up a grep line, with a quote started for the search
nnoremap ,gg :Ag ""<left>

" copied from yadr-keymap
" copy current filename into system clipboard - mnemonic: (c)urrent(f)ilename
" this is helpful to paste someone the path you're looking at
nnoremap <silent> ,cf :let @* = expand("%:~")<CR>
nnoremap <silent> ,cr :let @* = expand("%")<CR>
nnoremap <silent> ,cn :let @* = expand("%:t")<CR>
"Clear current search highlight by double tapping //
nmap <silent> // :nohlsearch<CR>
" Create window splits easier. The default
" way is Ctrl-w,v and Ctrl-w,s. I remap
" this to vv and ss
nnoremap <silent> vv <C-w>v
nnoremap <silent> ss <C-w>s
" Open the project tree and expose current file in the nerdtree with Ctrl-\
" " calls NERDTreeFind iff NERDTree is active, current window contains a modifiable file, and we're not in vimdiff
function! OpenNerdTree()
  if &modifiable && strlen(expand('%')) > 0 && !&diff
    NERDTreeFind
  else
    NERDTreeToggle
  endif
endfunction
nnoremap <silent> <C-\> :call OpenNerdTree()<CR>

" Copied from yadr-whitespace-killer
" via: http://rails-bestpractices.com/posts/60-remove-trailing-whitespace
" Strip trailing whitespace
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
command! StripTrailingWhitespaces call <SID>StripTrailingWhitespaces()
nmap ,w :StripTrailingWhitespaces<CR>

" FZF
let $FZF_DEFAULT_COMMAND='ag -l -g ""'

" map ,t to FZF
nnoremap <Leader>t :FZF<CR>

" copied from fzf.vim
" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" shortcut commands for fzf within a rails app directory
command! -bang JumpToModel
  \ call fzf#run(fzf#wrap('', {'source': $FZF_DEFAULT_COMMAND . ' app/models'}, <bang>0))

command! -bang JumpToController
  \ call fzf#run(fzf#wrap('', {'source': $FZF_DEFAULT_COMMAND . ' app/controllers'}, <bang>0))

command! -bang JumpToView
  \ call fzf#run(fzf#wrap('', {'source': $FZF_DEFAULT_COMMAND . ' app/views'}, <bang>0))

command! -bang JumpToHelper
  \ call fzf#run(fzf#wrap('', {'source': $FZF_DEFAULT_COMMAND . ' app/helpers'}, <bang>0))

command! -bang JumpToLib
  \ call fzf#run(fzf#wrap('', {'source': $FZF_DEFAULT_COMMAND . ' lib'}, <bang>0))

command! -bang JumpToSpec
  \ call fzf#run(fzf#wrap('', {'source': $FZF_DEFAULT_COMMAND . ' spec'}, <bang>0))

command! -bang JumpToReverb
  \ call fzf#run(fzf#wrap('', {'source': $FZF_DEFAULT_COMMAND . ' app/reverb'}, <bang>0))

" Equivalents of ctrlp mappings from yadr for the commands defined above
map ,jm :JumpToModel<CR>
map ,jc :JumpToController<CR>
map ,jv :JumpToView<CR>
map ,jh :JumpToHelper<CR>
map ,jl :JumpToLib<CR>
map ,js :JumpToSpec<CR>
map ,jr :JumpToReverb<CR>
