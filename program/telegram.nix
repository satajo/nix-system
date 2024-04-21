{ config, lib, pkgs, ... }: {
  config = lib.mkIf config.profile.personal {
    home-manager.users.satajo.home.packages = with pkgs; [ telegram-desktop ];

    systemd.user.services.telegram-desktop = {
      description = "Telegram desktop client";
      after = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.telegram-desktop}/bin/telegram-desktop";
        Restart = "on-failure";
        RestartSec = "1s";
      };
    };
  };
}
