{ config, lib, ... }:
{
  config = lib.mkIf config.profile.nvidia {
    # Defining nvidia as xserver video drivers enables a host of nvidia features.
    services.xserver.videoDrivers = [ "nvidia" ];

    # Force full composition pipeline to prevent crashes because of POS drivers.
    hardware.nvidia.forceFullCompositionPipeline = true;

    # Use the closed-source driver.
    hardware.nvidia.open = false;

    # Pascal-era GPUs (GTX 10-series) are no longer supported by the current
    # mainline driver and need the 580.xx legacy branch.
    hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_580;

    # Expose the GPU to container runtimes.
    hardware.nvidia-container-toolkit.enable = true;

    # Save/restore VRAM across suspend so the display survives S3 resume.
    hardware.nvidia.powerManagement.enable = true;
  };
}
