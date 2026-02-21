# Nix and NixOs related configuration
{ inputs, ... }:
{
  nix = {
    # Pin nix command's registry to the same package versions that the system uses.
    registry.nixpkgs.flake = inputs.nixpkgs;

    # Experimental features made available by default.
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  # Allow installation of non-free software by default.
  nixpkgs.config.allowUnfree = true;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep 30 --keep-since 7d";
    flake = "/home/satajo/nix-system";
  };
}
