{ config, pkgs, ... }: {
  home.username = "satajo";
  home.homeDirectory = "/home/satajo";
  home.stateVersion = "23.11";

  imports = [ "" ];
}
