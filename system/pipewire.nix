{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wireplumber
  ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
