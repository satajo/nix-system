{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:
let
  rmpc = pkgs-unstable.rmpc;
in
{
  config = lib.mkIf config.profile.personal {
    home-manager.users.satajo = {
      home.packages = [ rmpc ];

      # WM_CLASS is set to "music-player" so i3 can assign this window to
      # the dedicated music workspace; see session/i3/config.template.
      systemd.user.services.music-player = {
        Unit = {
          Description = "rmpc music player in a dedicated alacritty window";
          After = [
            "graphical-session.target"
            "mpd.service"
          ];
          PartOf = [ "graphical-session.target" ];
        };

        Service = {
          Type = "simple";
          ExecStart = "${pkgs.alacritty}/bin/alacritty --class music-player -e ${rmpc}/bin/rmpc";
          Restart = "always";
          RestartSec = "1s";
        };

        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
