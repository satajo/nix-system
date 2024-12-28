{ config, lib, ... }:
{
  config = lib.mkIf config.profile.nvidia {
    # Defining nvidia as xserver video drivers enables a host of nvidia features.
    services.xserver.videoDrivers = [ "nvidia" ];

    # Use a specific driver version.
    hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.production;

    # Expose the GPU to container runtimes.
    hardware.nvidia-container-toolkit.enable = true;
  };
}
