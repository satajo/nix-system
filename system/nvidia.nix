{ config, lib, ... }: {
  # Functionality for running as a virtual machine guest.
  #
  # See the matcing user-config under user-modules/vm-guest.nix

  config = lib.mkIf config.profile.nvidia {
    # Defining nvidia as xserver video drivers enables a host of nvidia features.
    services.xserver.videoDrivers = [ "nvidia" ];

    # Docker integration
    virtualisation.docker.enableNvidia = true;
  };
}
