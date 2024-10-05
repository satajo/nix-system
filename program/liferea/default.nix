{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.profile.personal {
    home-manager.users.satajo = {
      home.packages = with pkgs; [ liferea ];

      xdg.configFile."liferea/feedlist.opml" = {
        force = true;
        source = ./feedlist.opml;
      };
    };

    systemd.user.services.liferea-desktop = {
      description = "Liferea desktop client";
      after = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.liferea}/bin/liferea";
        Restart = "on-failure";
        RestartSec = "1s";
      };
    };
  };
}
