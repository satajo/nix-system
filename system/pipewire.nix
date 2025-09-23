{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wireplumber
  ];

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
}
