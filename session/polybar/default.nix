{ pkgs, ... }:
let
  theme = import ../../theme/lib.nix { pkgs = pkgs; };
  configFile = theme.substitute ./config.template.ini;
in
{
  home-manager.users.satajo = {
    home.packages = with pkgs; [
      polybar
      playerctl
    ];

    systemd.user.services.polybar = {
      Unit = {
        Description = "Polybar status bar";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        Type = "simple";
        ExecStart = "${pkgs.polybar}/bin/polybar --config=${configFile} primary";
        Restart = "always";
        RestartSec = "1s";
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
