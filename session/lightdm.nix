{ config, pkgs, callPackage, ... }:
let theme = import ../theme/lib.nix { pkgs = pkgs; };
in {
  environment.systemPackages = with pkgs; [ gruvbox-gtk-theme ];

  services.xserver = {
    displayManager = {
      lightdm = {
        enable = true;
        # TODO: background regex check is invalid. Fix it, and use value from layer 1.
        background = "#202021";
        greeters.gtk = {
          enable = true;
          # For theme names, see: /run/current-system/sw/share/themes/
          theme.name = "Gruvbox-Dark-B";
        };
      };
    };
  };
}
