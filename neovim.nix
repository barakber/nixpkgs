{ pkgs }:
{
  enable = true;
  viAlias = true;
  vimAlias = true;
  extraConfig = ''
    let mapleader = ","
    let maplocalleader=","
    set noswapfile
    set expandtab
    set tabstop=4
    set shiftwidth=4
    set autoindent
    set nu
    hi cursorline term=NONE ctermbg=DarkBlue
    hi cursorcolumn term=NONE ctermbg=darkblue
    hi Visual cterm=None ctermbg=DarkBlue ctermfg=None guibg=DarkBlue
    hi Search cterm=None ctermfg=white ctermbg=darkgreen
    set clipboard+=unnamedplus
    nnoremap <C-J> <C-W><C-J>
    nnoremap <C-K> <C-W><C-K>
    nnoremap <C-L> <C-W><C-L>
    nnoremap <C-H> <C-W><C-H>
    let g:EasyMotion_keys = get(g:, 'EasyMotion_keys', 'asdghklqwertyuiopzxcvbnmfj')
    let g:EasyMotion_smartcase = 0
    let g:EasyMotion_do_shade = 1
    let g:EasyMotion_inc_highlight = 0
    map <Leader>; <Leader><Leader>b
    map ; <Leader><Leader>w
    nnoremap <Leader>. :CtrlPMRU<CR>
    command! -nargs=1 Web vnew|call termopen('lynx -vikeys -scrollbar lite.duckduckgo.com/lite?q='.shellescape(substitute(<q-args>,'#','%23','g')))
    command! -nargs=1 Websearch vnew|call termopen('lynx -vikeys -scrollbar lite.duckduckgo.com/lite?q=<q-args>')
    nnoremap <Leader>w :Websearch <C-R>=expand('<cword>')<cr><cr>
  '';
  plugins = with pkgs.vimPlugins; [
    easymotion
    ctrlp-vim
    nerdtree
    nerdcommenter
    vim-airline
    fugitive
    vim-gitgutter
    vim-trailing-whitespace
    vim-markdown
    vim-highlightedyank
    vim-multiple-cursors
    vim-expand-region
    vim-nix
    vim-terraform
    vim-toml
  ];
}
