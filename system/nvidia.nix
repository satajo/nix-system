{ config, lib, ... }:
{
  config = lib.mkIf config.profile.nvidia {
    # Defining nvidia as xserver video drivers enables a host of nvidia features.
    services.xserver.videoDrivers = [ "nvidia" ];

    # Use the closed-source driver.
    hardware.nvidia.open = false;

    # Expose the GPU to container runtimes.
    hardware.nvidia-container-toolkit.enable = true;
  };
}
