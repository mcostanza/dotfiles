" General
syntax on " Turn on syntax highlighting
set number                                 " Show line numbers
set noswapfile                             " Disable creation of *.swp files
set shiftwidth=2                           " Number of spaces to use in each autoindent step
set tabstop=2                              " Two tab spaces
set softtabstop=2                          " Number of spaces to skip or insert when <BS>ing or <Tab>ing
set expandtab                              " Spaces instead of tabs for better cross-editor compatibility
set autoindent                             " Keep the indent when creating a new line
set smarttab                               " Use shiftwidth and softtabstop to insert or delete (on <BS>) blanks
set cindent                                " Recommended seting for automatic C-style indentation
set autoindent                             " Automatic indentation in non-C files
set smartindent
set nowrap                                 " Dont wrap lines
set wildmenu                               " Make tab completion act more like bash
set wildmode=longest,list,full             " Tab complete to longest common string, like bash
set completeopt+=longest                   " Tab complete type to search
set switchbuf=useopen                      " Don't re-open already opened buffers

" Backups
set backupdir=$HOME/.vim-config/backups

" Undo
set undodir=$HOME/.vim-config/undodir
set undofile
set undolevels=10000
set undoreload=10000

" Use system clipboard
set clipboard+=unnamed                     " Set system clipboard
set mouse=a

" Folding based on indent, 5 levels max
set foldmethod=indent
set foldnestmax=5
set nofoldenable
