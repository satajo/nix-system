# System configuration entry point. Well, after the flake.nix.
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  options = {
    # State version used for (both) system state and home-manager state versions.
    originalSystemStateVersion = lib.mkOption { type = lib.types.str; };

    # "Profile" feature flags for toggling different behaviours and system customisations.
    profile = {
      # Nvidia GPU integration with various services"
      nvidia = lib.mkEnableOption "nvidia gpu";

      # Chat applications, games, etc.
      personal = lib.mkEnableOption "personal profile features";

      # Services and configs for having the system work as a guest OS.
      vm-guest = lib.mkEnableOption "virtual machine guest operating system compatibility features";
    };
  };

  # Imports
  imports = [
    # Library / utility code
    ./theme

    # Configuration layers
    ./system # Configuration affecting the whole system
    ./session # Graphical user session related configuration
    ./program # Individual programs
  ];

  config = {
    system.stateVersion = config.originalSystemStateVersion;

    # Main user account. Don't forget to set a password with ‘passwd’.
    users.users.satajo = {
      isNormalUser = true;
      description = "satajo";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
    };

    home-manager = {
      extraSpecialArgs = {
        inherit inputs;
      };
      users = {
        "satajo" = {
          home.username = "satajo";
          home.homeDirectory = "/home/satajo";
          home.stateVersion = config.originalSystemStateVersion;
        };
      };
    };
  };
}
