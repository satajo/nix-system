#!/bin/sh -e

# 1. Assert that an "install" branch already exists. If it doesn't, we are dealing
# with a fresh install and need to generate and possibly modify the hardware-configuration.nix
# file. That can and should be made manually so let's just abort here if that is the case.
if ! git show-ref --verify --quiet refs/heads/install ; then
  echo "Error: Local installation branch \"install\" not found!"
  echo ""
  echo "If you are installing a fresh system, you need to create this branch"
  echo "by yourself. Create the branch and then use the command"
  echo ""
  echo "    nixos-generate-config --show-hardware-config > hardware-configuration.nix"
  echo ""
  echo "to generate an initial hardware-configuration file. Commit this file in"
  echo "the \"install\" branch."
  exit 1
fi

# 2. Format the files which also checks for basic syntax.
nix fmt

# 3. Take note of the current HEAD sha, and switch over to the install branch.
ORIGINAL_BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Switch to the install branch.
git switch --quiet install
# Rebase the branch over the HEAD, autostashing the changes to avoid conflicts.
git rebase --autostash --onto $ORIGINAL_BRANCH install~1 install

# 4. Build and apply the configuration.
echo "Installing configuration now!"

# Ignore the error so that we always switch back to the original branch.
sudo nixos-rebuild switch --flake .#default || true

# 5. Switch back to the working branch.
git switch --quiet $ORIGINAL_BRANCH
