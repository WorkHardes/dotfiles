set autoindent
set clipboard+=unnamedplus
set cursorline
set encoding=utf-8
set expandtab
set fileencoding=utf-8
set fileformat=unix
set foldlevel=99
set foldmethod=indent
set mouse=a
set number
set pyxversion=3
set shiftwidth=4
set smartindent
set softtabstop=4
set noswapfile
set tabstop=8

" for python files
au BufNewFile, BufRead *.py
    \ set tabstop=8
    \ set softtabstop=4
    \ set shiftwidth=4
    \ set expandtab
    \ set autoindent
    \ set fileformat=unix

let mapleader = ","

filetype plugin indent on


call plug#begin('~/.vim/plugged')
" ================Appearance================
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'xiyaowong/nvim-transparent'

" ================Navigation================
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'majutsushi/tagbar'
Plug 'romgrk/barbar.nvim'
Plug 'nvim-tree/nvim-web-devicons'

" ================Python================
Plug 'neovim/nvim-lspconfig'
Plug 'davidhalter/jedi-vim'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'pappasam/coc-jedi', { 'do': 'yarn install --frozen-lockfile && yarn build', 'branch': 'main' }

" ================Other================
Plug 'dense-analysis/ale'
Plug 'jiangmiao/auto-pairs'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-commentary'
Plug 'junegunn/fzf.vim'
Plug 'editorconfig/editorconfig-vim'

call plug#end()

" appearance
colorscheme tokyonight-storm
let g:airline_theme = 'tokyonight'

" nerdtree
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" tagbar
nmap <F8> :TagbarToggle<CR>

" for ale
let g:ale_linters = {'python': 'all'}
let g:ale_fixers = {'python': ['autoflake', 'black', 'isort', 'ruff', 'remove_trailing_lines', 'trim_whitespace']}
let g:ale_lsp_suggestions = 1
let g:ale_fix_on_save = 1
let g:ale_completion_enabled = 0

" shows the total number of warnings and errors in the status line
function! LinterStatus() abort
  let l:counts = ale#statusline#Count(bufnr(''))

  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors

  return l:counts.total == 0 ? '✨ all good ✨' : printf(
        \   '😞 %dW %dE',
        \   all_non_errors,
        \   all_errors
        \)
endfunction

set statusline=
set statusline+=%m
set statusline+=\ %f
set statusline+=%=
set statusline+=\ %{LinterStatus()}
