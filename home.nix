{ config, pkgs, ... }:

{
  home.username = "berko";
  home.homeDirectory = "/home/berko";
  home.stateVersion = "20.09";

  nixpkgs.overlays = [
    (self: super: {
      ranger = import ./ranger/default.nix { inherit pkgs; };
    })
  ];

  home.packages = [
    pkgs.file
    pkgs.atool
    pkgs.binutils
    pkgs.ranger
    pkgs.strace
    pkgs.ripgrep
    pkgs.bat
    pkgs.hexd
    pkgs.poppler_utils
    pkgs.typespeed
    pkgs.lynx
    pkgs.niv
    pkgs.exa
    pkgs.nettools
    pkgs.awscli2
    pkgs.nmap
    pkgs.httpie

    pkgs.xdotool
    pkgs.dolphin
  ];

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
