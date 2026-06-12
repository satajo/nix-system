{ pkgs, ... }:
{
  networking.hostName = "arwen";
  system.stateVersion = "26.05";

  # Profile flags. See root configuration.nix.
  profile.personal = true;

  # Laptop power and thermal management.
  services.tlp.enable = true;
  services.thermald.enable = true;

  # Hardware video decode on the Iris Xe iGPU.
  hardware.graphics.extraPackages = [ pkgs.intel-media-driver ];
}
