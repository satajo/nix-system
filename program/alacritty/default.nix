{ config, pkgs, ... }: {

  home-manager.users.satajo = {

    home.packages = with pkgs; [ alacritty ];

    xdg.configFile."alacritty.yml".source = ./alacritty.yml;

  };
}
