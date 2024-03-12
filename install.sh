#!/bin/sh -e

# Ensure hardware-cofiguration.nix exists.
if [ ! -f hardware-configuration.nix ]; then
  echo "NixOS hardware configuration file not found - Regenerating..."
  sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix

  # Git hack to expose the generated hardware-configuration.nix to Git without
  # actually committing it in git. In lieu of granular impurity control mechanisms,
  # this is the best we can do.
  #
  # For details, see: https://discourse.nixos.org/t/can-i-use-flakes-within-a-git-repo-without-committing-flake-nix/18196
  git add --force --intent-to-add hardware-configuration.nix
  git update-index --assume-unchanged hardware-configuration.nix
fi

sudo nixos-rebuild switch --flake .#default
