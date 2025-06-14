#!/usr/bin/env bash
set -e -u -o pipefail

cd "$(dirname "$0")"

function print_error() {
  if [[ -t 2 ]]; then
    echo -e "\033[31m$*\033[0m" >&2
  else
    echo "$*" >&2
  fi
}

function run_in_install_branch() {
  local COMMAND="$*";

  # 1. Assert that an "install" branch already exists. If it doesn't, we are dealing
  # with a fresh install and need to generate and possibly modify the hardware-configuration.nix
  # file. That can and should be made manually so let's just abort here if that is the case.
  if ! git show-ref --verify --quiet refs/heads/install ; then
    print_error "Error: Local installation branch \"install\" not found!

If you are installing a fresh system, you need to create this branch
by yourself. Create the branch and then use the command

    nixos-generate-config --show-hardware-config > hardware-configuration.nix

to generate an initial hardware-configuration file. Commit this file in
the \"install\" branch."

    exit 1
  fi

  # 2. Take note of the current HEAD sha, and switch over to the install branch.
  local ORIGINAL_BRANCH
  ORIGINAL_BRANCH=$(git rev-parse --abbrev-ref HEAD)

  # 3. Rebase the install branch over the HEAD, autostashing the changes to avoid conflicts.
  #    The rebase operation checkouts the install branch.
  if ! git rebase --autostash --onto "$ORIGINAL_BRANCH" install~1 install; then
    print_error "Error: Failed to rebase the install branch. Resolve conflicts manually." >&2
    git rebase --abort 2>/dev/null || true
    return 1
  fi

  # 4. Run the command, ignoring the error so that we always switch back to the original branch.
  local EXIT_CODE=0
  $COMMAND || EXIT_CODE=$?

  # 5. Switch back to the working branch.
  git switch --quiet "$ORIGINAL_BRANCH"

  return $EXIT_CODE
};

function print_usage() {
  cat << EOF
Usage: $(basename "$0") <command>

Commands:
  dry-build    Perform a dry build of the NixOS configuration
  format       Format contents
  help         Show this help message
  test         Test the NixOS configuration, applying it without saving
  switch       Switch to the NixOS configuration, making it the default boot option

Description:
  This script manages the NixOS configuration related application operations.
EOF
}

function format_code() {
  nix fmt .
}

### Main

case "${1:-}" in
  "dry-build")
    format_code
    run_in_install_branch nixos-rebuild dry-build --flake .#default --show-trace
    ;;

  "format")
    format_code
    ;;

  "help")
    print_usage
    ;;

  "test")
    format_code
    run_in_install_branch sudo nixos-rebuild test --flake .#default
    ;;

  "switch")
    format_code
    run_in_install_branch sudo nixos-rebuild switch --flake .#default
    ;;

  "")
    print_error "Error: Missing command!" >&2
    echo ""
    print_usage
    exit 1
    ;;

  *)
    print_error "Error: Unknown command!" >&2
    echo ""
    print_usage
    exit 1
    ;;
esac
