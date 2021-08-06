{ pkgs, lib, vimUtils, ... }:
let
  # installs a vim plugin from git with a given tag / branch
  pluginGit = ref: repo: vimUtils.buildVimPluginFrom2Nix {
    pname = "${lib.strings.sanitizeDerivationName repo}";
    version = ref;
    package = pkgs.neovim-nightly;
    src = builtins.fetchGit {
      url = "https://github.com/${repo}.git";
      ref = ref;
    };
  };

  # always installs latest version
  plugin = pluginGit "HEAD";
in
  plugin
