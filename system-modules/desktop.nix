{ config, pkgs, callPackage, ... }:
let theme = import ../themes { pkgs = pkgs; };
in {
  environment.pathsToLink =
    [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw

  environment.systemPackages = with pkgs; [ gruvbox-gtk-theme ];

  services.xserver = {
    enable = true;

    desktopManager.xterm.enable = false;

    displayManager = {
      defaultSession = "none+i3";
      lightdm = {
        enable = true;
        background = theme.theme.color.background.normal;
        greeters.gtk = {
          enable = true;
          # For a list of themes, see: /run/current-system/share/themes/
          theme.name = "Gruvbox-Dark-B";
        };
      };
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        rofi
        i3status # gives you the default i3 status bar
        i3lock # default i3 screen locker
        i3blocks # if you are planning on using i3blocks over i3status
      ];
    };
  };
}
