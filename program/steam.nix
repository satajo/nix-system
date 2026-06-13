{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.custom.profile.personal {
    # Steam launch option: gamemoderun mangohud %command%
    programs.steam = {
      enable = true;
      extraPackages = with pkgs; [ mangohud ];

      # GE-Proton bundles the Media Foundation codecs and extra patches that
      # stock Valve Proton omits, letting games that rely on them (e.g. in-game
      # video playback) run without hanging. Select per-title under
      # Properties > Compatibility.
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
    };

    # Enable gamemode to optimize in-game performance.
    # Check configuration using `gamemoded -t`.
    programs.gamemode.enable = true;
    users.extraGroups.gamemode.members = [ "satajo" ];
  };
}
