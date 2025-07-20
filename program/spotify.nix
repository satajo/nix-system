{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.profile.personal {
    home-manager.users.satajo.home.packages = with pkgs; [ spotify ];

    systemd.user.services.spotify-desktop = {
      description = "Spotify desktop client";
      after = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.spotify}/bin/spotify";
        Restart = "on-failure";
        RestartSec = "1s";
      };
    };

    networking.firewall = {
      # Local discovery of other Spotify clients.
      allowedTCPPorts = [ 57621 ];
      # Google Cast devices.
      allowedUDPPorts = [ 5353 ];
    };
  };
}
