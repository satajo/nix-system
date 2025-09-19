{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.profile.personal {
    home-manager.users.satajo.home.packages = with pkgs; [ rhythmbox ];

    systemd.user.services.rhythmbox = {
      description = "Rhythmbox music player";
      after = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.rhythmbox}/bin/rhythmbox";
        Restart = "on-failure";
        RestartSec = "1s";
      };
    };
  };
}
