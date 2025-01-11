{ config, pkgs, ... }:

{
  # Starship command prompt
  programs.starship = {
    enable = true;
    settings = pkgs.lib.importTOML ./starship.toml;
  };
}
