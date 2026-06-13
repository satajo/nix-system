{ config, lib, ... }:
{
  config = lib.mkIf config.custom.profile.nvidia {
    # Defining nvidia as xserver video drivers enables a host of nvidia features.
    services.xserver.videoDrivers = [ "nvidia" ];

    # Tear-free output without a compositor (bare i3); trades away G-SYNC/VRR.
    hardware.nvidia.forceFullCompositionPipeline = true;

    # Disable page-flipping (persistent form of nvidia-settings AllowFlipping=0).
    # The legacy 580 driver hangs on the flip<->blit transition when a window
    # covers/uncovers a fullscreen game; forcing blit keeps one stable present
    # path, so games survive overlays. Free here: FFCP already drops G-SYNC.
    services.xserver.screenSection = ''
      Option "NoFlip" "true"
    '';

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
