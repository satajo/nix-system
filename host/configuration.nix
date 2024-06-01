# Host-specific configuration.
#
# Use this file to define the profile flags that should be in use, and to make
# any **small** tweaks to the configuration. Only modify this file in the local
# install branch.
{
  imports = [ ./hardware-configuration.nix ];

  # Set this to install-time nixos (+home-manager) version.
  originalSystemStateVersion = "TODO";

  # Profile flags. See configuration.nix.
  profile.personal = false;
}
