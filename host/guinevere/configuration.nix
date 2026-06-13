{
  networking.hostName = "guinevere";
  system.stateVersion = "23.11";

  # Profile flags. See root configuration.nix.
  custom.profile.nvidia = true;
  custom.profile.personal = true;

  custom.displayScaling = {
    panelDpi = 110;
    scaleFactor = 1.2;
  };
}
