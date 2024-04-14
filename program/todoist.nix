{ config, lib, pkgs, ... }: {
  config = lib.mkIf config.profile.personal {
    home-manager.users.satajo.home.packages = with pkgs; [ todoist-electron ];

    systemd.user.services.todoist-desktop = {
      description = "Todoist desktop client";
      after = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.todoist-electron}/bin/todoist-electron";
        Restart = "always";
        RestartSec = "1s";
      };
    };
  };
}
