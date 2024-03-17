{ config, pkgs, callPackage, ... }:
let theme = import ../theme/lib.nix { pkgs = pkgs; };
in {
  environment.systemPackages = with pkgs; [ gruvbox-gtk-theme ];

  services.xserver = {
    displayManager = {
      lightdm = {
        enable = true;
        background = theme.color.background.normal;
        greeters.gtk = {
          enable = true;
          # For a list of themes, see: /run/current-system/share/themes/
          theme.name = "Gruvbox-Dark-B";
        };
      };
    };
  };
}
