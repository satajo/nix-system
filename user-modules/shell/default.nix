{ config, pkgs, ... }: {
  home.packages = with pkgs; [ bash fzf starship ];

  # Bash
  home.file.".bashrc".source = ./bashrc;

  # Starship shell
  xdg.configFile."starship.toml".source = ./starship.toml;
}
