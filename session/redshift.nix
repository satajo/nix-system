{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    redshift
  ];

  services.redshift = {
    enable = true;
  };
}
