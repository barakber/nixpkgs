{ config, pkgs, ... }:

{
  home.username = "$USER";
  home.homeDirectory = "/home/$USER";
  home.stateVersion = "21.05";

  fonts.fontconfig.enable = true;

  nixpkgs.overlays = [
    (self: super: {
      ranger = import ./ranger/default.nix { inherit pkgs; };
    })
    (import (builtins.fetchTarball {
    url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
  }))
  ];

  home.packages =
    let
      utils = [
        pkgs.ripgrep
        pkgs.exa
        pkgs.bat
        pkgs.jp
        pkgs.hexd
        pkgs.tokei

        pkgs.atool
        pkgs.file
        pkgs.binutils
        pkgs.strace
        pkgs.poppler_utils
      ];

      tui = [
        pkgs.ranger
        pkgs.lynx
        pkgs.typespeed
      ];

      net = [
        pkgs.nettools
        pkgs.nmap
        pkgs.httpie
      ];

      cloud = [
        pkgs.awscli2
      ];

      nix = [
        pkgs.niv
      ];

      gui = [
        pkgs.xdotool
        pkgs.keynav
        pkgs.dolphin
      ];

      fonts = [
        (pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
      ];
    in
      utils ++ tui ++ net ++ cloud ++ nix ++ gui ++ fonts;

  programs.home-manager = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userName  = "Barak Bercovitz";
    userEmail = "barakber@gmail.com";
    signing = {
      key = "3CDCFC54D98CEA2D";
      signByDefault = true;
    };
    #delta = {
      #enable = true;
    #};
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      cat = "bat";
      ls  = "exa";
      xxd = "hexd";
      lynx = "lynx -vikeys lite.duckduckgo.com/lite";
    };
    shellInit = "
    export TERM=xterm-256color
    set -gx GPG_TTY (tty)
    ";
  };

  programs.autojump = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.htop = {
    enable = true;
    #treeView = true;
  };

  programs.jq = {
    enable = true;
  };

  #programs.exa = {
  #  enable = true;
  #};


  programs.tmux = {
    enable = true;
    keyMode = "vi";
    terminal = "screen-256color";
    #shell = "${pkgs.fish}/bin/fish";
  };

  programs.feh = {
    enable = true;
  };

  programs.chromium = {
    enable = true;
    extensions = [
      "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
      "kbfnbcaeplbcioakkpcpgfkobkghlhen" # grammarly
    ];
  };

  programs.neovim = import ./neovim/default.nix { inherit pkgs; };

  programs.urxvt = import ./urxvt.nix { inherit pkgs; };

  services.keynav = {
    enable = true;
  };

  services.lorri = {
    enable = true;
  };

  xsession.windowManager.xmonad = import ./xmonad.nix { inherit pkgs; };
}
