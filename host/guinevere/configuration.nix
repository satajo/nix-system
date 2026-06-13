{
  networking.hostName = "guinevere";
  system.stateVersion = "23.11";

  # Profile flags. See root configuration.nix.
  profile.nvidia = true;
  profile.personal = true;

  profile.displayScaling = {
    panelDpi = 110;
    scaleFactor = 1.2;
  };
}
