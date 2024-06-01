{ pkgs, ... }:
let
  theme = import ../../theme/lib.nix { pkgs = pkgs; };
in
{
  environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw

  # i3 comes with no compositor so we use picom with it.
  services.picom = {
    enable = true;
  };

  services.xserver = {
    desktopManager.xterm.enable = false;

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [ hsetroot ];
    };
  };

  home-manager.users.satajo = {
    xdg.configFile."i3/config".source = theme.substitute ./config.template;
  };
}
