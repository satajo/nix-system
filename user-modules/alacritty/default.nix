{ config, pkgs, ... }: {

  home.packages = with pkgs; [ alacritty ];

  #xdg.enable = true;
  xdg.configFile."alacritty.yml".source = ./alacritty.yml;
}
