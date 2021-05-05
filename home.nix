{ config, pkgs, ... }:

{
  home.username = "$USER";
  home.homeDirectory = "/home/$USER";
  home.stateVersion = "20.09";

  nixpkgs.overlays = [
    (self: super: {
      ranger = import ./ranger/default.nix { inherit pkgs; };
    })
  ];

  home.packages =
    let
      utils = [
        pkgs.ripgrep
        pkgs.exa
        pkgs.bat
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
        pkgs.dolphin
      ];
    in
      utils ++ tui ++ net ++ cloud ++ nix ++ gui;

  programs.home-manager = {
    enable = true;
  };

  programs.git = {
    enable = true;
    delta = {
      enable = true;
    };
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      cat = "bat";
      ls  = "exa";
      xxd = "hexd";
      lynx = "lynx -vikeys lite.duckduckgo.com/lite";
    };
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
    vimMode = true;
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
    ];
  };

  programs.neovim = import ./neovim.nix { inherit pkgs; };

  programs.urxvt = import ./urxvt.nix { inherit pkgs; };

  services.keynav = {
    enable = true;
  };

  services.lorri = {
    enable = true;
  };

  xsession.windowManager.xmonad = import ./xmonad.nix { inherit pkgs; };
}
