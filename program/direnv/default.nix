{ config, pkgs, ... }:
{
  # direnv auto-loads each project's `.envrc` on `cd`; nix-direnv is the flake-aware backend.
  # Enabling this also sets nix.settings.keep-outputs / keep-derivations so dev shell deps
  # aren't garbage-collected even when only their derivations are rooted.
  programs.direnv.enable = true;

  # The per-project `.direnv/` cache should never be committed.
  home-manager.users.satajo.programs.git.ignores = [ ".direnv/" ];
}
