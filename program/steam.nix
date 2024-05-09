{ config, lib, ... }: {
  config = lib.mkIf config.profile.personal { programs.steam.enable = true; };
}
