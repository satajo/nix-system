{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.profile.personal {
    home-manager.users.satajo.home.packages = with pkgs; [ obsidian ];

    systemd.user.services.obsidian-desktop = {
      description = "Obsidian desktop client";
      after = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.obsidian}/bin/obsidian";
        Restart = "on-failure";
        RestartSec = "1s";
      };
    };
  };
}
