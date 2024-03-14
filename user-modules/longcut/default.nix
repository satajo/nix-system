{ config, pkgs, inputs, ... }:
let
  theme = import ../../themes { pkgs = pkgs; };
  package = inputs.longcut.packages.${pkgs.system}.default;
in {
  home.packages = [ package ];

  xdg.configFile."longcut/longcut.yaml".source =
    theme.substitute ./longcut.yaml.template;

  # Systemd service
  systemd.user.services.longcut = {
    Unit = {
      Description = "Longcut shortcut manager";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${package}/bin/longcut";
      KillMode = "proces";
      Restart = "always";
      RestartSec = "1s";
    };
  };
}
