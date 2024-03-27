{ pkgs, ... }:
let theme = import ../../theme/lib.nix { pkgs = pkgs; };
in {
  home-manager.users.satajo = {
    home.packages = with pkgs; [ playerctl polybarFull ];

    xdg.configFile."polybar/config.ini".source =
      theme.substitute ./config.template.ini;
  };
}
