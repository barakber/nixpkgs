{ pkgs }:
let
  plugin = import ./plugins.nix { pkgs=pkgs; lib=pkgs.lib; vimUtils=pkgs.vimUtils; };
in
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
    set encoding=UTF-8
    set nu
    highlight VertSplit cterm=NONE
    hi cursorline term=NONE ctermbg=DarkBlue
    hi cursorcolumn term=NONE ctermbg=darkblue
    hi Visual cterm=None ctermbg=DarkBlue ctermfg=None guibg=DarkBlue
    hi Search cterm=None ctermfg=white ctermbg=darkgreen
    set clipboard+=unnamedplus
    nnoremap <C-J> <C-W><C-J>
    nnoremap <C-K> <C-W><C-K>
    nnoremap <C-L> <C-W><C-L>
    nnoremap <C-H> <C-W><C-H>
    command! -nargs=1 Web vnew|call termopen('lynx -vikeys -scrollbar lite.duckduckgo.com/lite?q='.shellescape(substitute(<q-args>,'#','%23','g')))
    command! -nargs=1 Websearch vnew|call termopen('lynx -vikeys -scrollbar lite.duckduckgo.com/lite?q=<q-args>')
    nnoremap <Leader>w :Websearch <C-R>=expand('<cword>')<cr><cr>
  '';
  plugins = with pkgs.vimPlugins; [

    { plugin = (plugin "phaazon/hop.nvim");
      config = ''
        lua require'hop'.setup { keys = 'asdghklqwertyuiopzxcvbnmfj', term_seq_bias = 0.1 }
        map <Leader>; :HopWordBC<CR>
        map ;         :HopWordAC<CR>
      '';
    }

    { plugin = ctrlp-vim;
      config = ''
        nnoremap <Leader>. :CtrlPMRU<CR>
      '';
    }

    nerdtree
    nerdcommenter
    vim-surround
    repeat
    vim-airline
    fugitive

    { plugin = vim-gitgutter;
      config = ''
        highlight clear SignColumn
      '';
    }

    vim-trailing-whitespace
    vim-markdown
    vim-highlightedyank
    vim-multiple-cursors
    vim-expand-region
    vim-nix
    vim-terraform
    vim-toml
    vim-devicons

    { plugin = (plugin "mxw/vim-prolog");
      config = ''
        let g:filetype_pl="prolog"
      '';
    }

    { plugin = (plugin "niklasl/vim-rdf");
    }

    { plugin = (plugin "francoiscabrol/ranger.vim");
    }

    { plugin = (plugin "MattesGroeger/vim-bookmarks");
    }

    { plugin = (plugin "junegunn/vim-easy-align");
      config = ''
        " Start interactive EasyAlign in visual mode (e.g. vipga)
        xmap ga <Plug>(EasyAlign)

        " Start interactive EasyAlign for a motion/text object (e.g. gaip)
        nmap ga <Plug>(EasyAlign)
      '';
    }

  ];
}
