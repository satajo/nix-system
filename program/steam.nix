{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.profile.personal {
    # Steam launch option: gamemoderun mangohud %command%
    programs.steam = {
      enable = true;
      extraPackages = with pkgs; [ mangohud ];
    };

    # Enable gamemode to optimize in-game performance.
    # Check configuration using `gamemoded -t`.
    programs.gamemode.enable = true;
    users.extraGroups.gamemode.members = [ "satajo" ];
  };
}
