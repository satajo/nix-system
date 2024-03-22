{ pkgs, ... }:
let theme = import ../../theme/lib.nix { pkgs = pkgs; };
in {
  #environment.systemPackages = with pkgs; [ polybarFull ];

  home-manager.users.satajo = {
    home.packages = with pkgs; [ polybarFull ];

    xdg.configFile."polybar/config.ini".source =
      theme.substitute ./config.template.ini;
  };
}
