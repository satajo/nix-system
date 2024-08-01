{ pkgs, ... }:
let
  theme = import ../theme/lib.nix { pkgs = pkgs; };
in
{
  programs.dconf.enable = true;

  home-manager.users.satajo.gtk = {
    enable = true;
    font.name = theme.font.monospace;
    theme = {
      # For theme names, see: /run/current-system/sw/share/themes/
      name = "Gruvbox-Dark";
      package = pkgs.gruvbox-gtk-theme;
    };
  };
}
