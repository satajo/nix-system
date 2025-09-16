{ pkgs, ... }:
let
  theme = import ../../theme/lib.nix { pkgs = pkgs; };
in
{
  home-manager.users.satajo = {
    home.packages = with pkgs; [
      playerctl
    ];

    services.polybar = {
      enable = true;
      script = "polybar primary &";
      config = theme.substitute ./config.template.ini;
    };
  };
}
