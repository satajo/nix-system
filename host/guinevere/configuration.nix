{
  networking.hostName = "guinevere";
  originalSystemStateVersion = "23.11";

  # Profile flags. See root configuration.nix.
  profile.nvidia = true;
  profile.personal = true;
}
