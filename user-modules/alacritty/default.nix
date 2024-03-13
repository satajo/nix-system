{ config, pkgs, ... }: {

  home.packages = with pkgs; [ alacritty ];

  xdg.configFile."alacritty.yml".source = ./alacritty.yml;
}
