{ pkgs, ... }:
let theme = import ../../theme/lib.nix { pkgs = pkgs; };
in {
  environment.systemPackages = with pkgs; [ libnotify ];

  home-manager.users.satajo = {
    services.dunst = { enable = true; };

    xdg.configFile."dunst/dunstrc".source = theme.substitute ./dunstrc.template;
  };
}
