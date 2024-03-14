{ config, pkgs, inputs, ... }:
let theme = import ../../themes { pkgs = pkgs; };
in {
  home.packages = with pkgs; [ inputs.longcut.packages.${pkgs.system}.default ];

  xdg.configFile."longcut/longcut.yaml".source =
    theme.substitute ./longcut.yaml.template;
}
