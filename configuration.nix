# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  # Imports
  imports = [
    ./profile.nix

    # Library / utility code
    ./theme

    # Configuration layers
    ./system # Configuration affecting the whole system
    ./session # Graphical user session related configuration
    ./program # Individual programs
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  # Main user account. Don't forget to set a password with ‘passwd’.
  users.users.satajo = {
    isNormalUser = true;
    description = "satajo";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "satajo" = {
        home.username = "satajo";
        home.homeDirectory = "/home/satajo";
        home.stateVersion = "23.11";
      };
    };
  };
}
