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
set tabstop=4

au BufNewFile,BufRead *.py
    \ set tabstop=4
    \ set softtabstop=4
    \ set shiftwidth=4
    \ set expandtab
    \ set autoindent
    \ set fileformat=unix

au BufNewFile,BufRead *.py \
  set foldmethod=indent

au BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2
    \ set softtabstop=2
    \ set shiftwidth=2

au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

let mapleader = ","

filetype plugin indent on


call plug#begin('~/.vim/plugged')
" ================Appearance================
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'xiyaowong/nvim-transparent'
Plug 'neovim/nvim-lspconfig'

" ================Navigation================
Plug 'scrooloose/nerdtree'
Plug 'majutsushi/tagbar'

" ================Python================
Plug 'davidhalter/jedi-vim'

" ================Other================
Plug 'dense-analysis/ale'
Plug 'jiangmiao/auto-pairs'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'numirias/semshi'
Plug 'preservim/nerdcommenter'
Plug 'junegunn/fzf.vim'

call plug#end()

" appearance
colorscheme tokyonight-storm
let g:airline_theme='base16'

" for nerdtree
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" for tagbar
nmap <F8> :TagbarToggle<CR>

" enable folding with the spacebar
" nnoremap <space> za

let python_highlight_all=1
syntax on

let g:ale_linters = {
      \   'python': ['bandit', 'mypy' ,'flake8', 'pylint', 'ruff'],
      \   'javascript': ['eslint'],
      \}

let g:ale_fixers = {
      \    'python': ['ruff'],
      \}
nmap <F10> :ALEFix<CR>
let g:ale_fix_on_save = 1

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
