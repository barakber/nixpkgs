{ pkgs }:
{
  enable = true;
  package = pkgs.rxvt_unicode-with-plugins;
  transparent = true;
  #shading = 50;
  keybindings = {
    "Shift-Control-C" = "eval:selection_to_clipboard";
    "Shift-Control-V" = "eval:paste_clipboard";
    "Control-Up"      = "font-size:increase";
    "Control-Down"    = "font-size:decrease";
    "Control-equal"   = "font-size:reset";
    "Control-slash"   = "font-size:show";
  };
  extraConfig = {
      font           = "xft:Monospace:pixelsize=11";
      #depth          = 32;
      background     = "rgba:0000/0000/0200/c800";
      letterSpace    = 0;
      foreground     = "#FFFFFF";
      color8         = "#555753";
      color1         = "#CC0000";
      color9         = "#EF2929";
      color2         = "#4E9A06";
      color10        = "#8AE234";
      color3         = "#C4A000";
      color11        = "#FCE94F";
      color4         = "#3465A4";
      color12        = "#729FCF";
      color5         = "#75507B";
      color13        = "#AD7FA8";
      color6         = "#06989A";
      color14        = "#34E2E2";
      color7         = "#D3D7CF";
      color15        = "#EEEEEC";
      colorUL        = "#AED210";
      perl-ext       = "default,url-select,bidi,selection-to-clipboard,keyboard-select,font-size";
      "bidi.enabled" = 1;
  };
}
