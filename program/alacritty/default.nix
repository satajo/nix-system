{ config, pkgs, ... }:
let theme = import ../../theme/lib.nix { pkgs = pkgs; };
in {
  home-manager.users.satajo = {
    home.packages = with pkgs; [ alacritty ];
    xdg.configFile."alacritty.yml".source =
      theme.substitute ./alacritty.template.yml;
  };
}
