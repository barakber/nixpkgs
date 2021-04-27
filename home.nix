{ config, pkgs, ... }:

{
  home.username = "berko";
  home.homeDirectory = "/home/berko";
  home.stateVersion = "21.05";

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

    pkgs.xdotool
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
    #treeView = true;
  };

  programs.jq = {
    enable = true;
  };

  programs.exa = {
    enable = true;
  };


  programs.tmux = {
    enable = true;
    keyMode = "vi";
    shell = "${pkgs.fish}/bin/fish";
  };


  programs.feh = {
    enable = true;
  };

  programs.chromium = {
    enable = true;
    extensions = [
      # vimium
      { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; }
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
