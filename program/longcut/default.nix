{ config, pkgs, inputs, ... }:
let
  theme = import ../../theme { pkgs = pkgs; };
  package = inputs.longcut.packages.${pkgs.system}.default;
in {
  home-manager.users.satajo = {

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
        # Service is started through a login shell invocation to iherit paths correctly.
        ExecStart = "${pkgs.runtimeShell} -lc ${package}/bin/longcut";
        KillMode = "process";
        Restart = "always";
        RestartSec = "1s";
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
