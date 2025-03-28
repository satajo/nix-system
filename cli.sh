#!/usr/bin/env bash
set -e -u -o pipefail

cd "$(dirname "$0")"

function run_in_install_branch() {
  local COMMAND="$*";

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

  # 2. Take note of the current HEAD sha, and switch over to the install branch.
  ORIGINAL_BRANCH=$(git rev-parse --abbrev-ref HEAD)

  # 3. Rebase the install branch over the HEAD, autostashing the changes to avoid conflicts.
  #    The rebase operation checkouts the install branch.
  git rebase --autostash --onto "$ORIGINAL_BRANCH" install~1 install

  # 4. Run the command, ignoring the error so that we always switch back to the original branch.
  $COMMAND || true

  # 5. Switch back to the working branch.
  git switch --quiet "$ORIGINAL_BRANCH"
};

### Main

case "$1" in
  ("build")
    nix fmt
    run_in_install_branch nixos-rebuild dry-build --flake .#default --show-trace
    ;;

  ("test")
    nix fmt
    run_in_install_branch sudo nixos-rebuild test --flake .#default
    ;;

  ("install")
    nix fmt
    run_in_install_branch sudo nixos-rebuild switch --flake .#default
    ;;

  ("")
    echo "Error: Missing command!"
    exit 1
    ;;

  (*)
    echo "Error: Invalid command!"
    exit 1
    ;;
esac
