{ pkgs, ... }:
let
  theme = import ../../theme/lib.nix { pkgs = pkgs; };
in
{
  home-manager.users.satajo = {
    programs.rofi = {
      enable = true;
      theme = "theme.rasi";
      extraConfig = {
        cycle = false;
        matching = "fuzzy";
        scroll-method = 1; # Continuous scrolling
        sort = true;
        sorting-method = "fzf";
        threads = 0; # Autodetect thread count
      };
    };

    xdg.configFile."rofi/theme.rasi".source = theme.substitute ./theme.template.rasi;
  };
}
