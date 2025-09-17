{
  networking.hostName = "isolde";
  originalSystemStateVersion = "23.11";

  # Profile flags. See root configuration.nix.
  profile.personal = true;

  # Fix audio. See: https://discourse.nixos.org/t/realtek-audio-sound-card-not-recognized-by-pipewire/36637/2
  boot.kernelParams = [ "snd-intel-dspcfg.dsp_driver=1" ];
}
