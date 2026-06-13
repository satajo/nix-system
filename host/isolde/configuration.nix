{
  networking.hostName = "isolde";
  system.stateVersion = "23.11";

  # Profile flags. See root configuration.nix.
  custom.profile.personal = true;

  custom.displayScaling = {
    panelDpi = 143;
    scaleFactor = 0.74;
  };

  boot.kernelParams = [
    # Fix audio. See: https://discourse.nixos.org/t/realtek-audio-sound-card-not-recognized-by-pipewire/36637/2
    "snd-intel-dspcfg.dsp_driver=1"

    # Disable i915 Panel Self Refresh. Without this, small writes (single
    # keystrokes, popup windows) occasionally fail to invalidate the panel's
    # cached frame, causing partial screen freezes until a larger redraw
    # forces a flip. PSR1 on Skylake panels has a long history of such bugs.
    "i915.enable_psr=0"
  ];
}
