{ config, lib, pkgs, inputs, ... }:
let
  package = inputs.longcut.packages.${pkgs.system}.default;
  theme = import ../../theme/lib.nix { pkgs = pkgs; };
in {
  home-manager.users.satajo = {
    home.packages = [ package ] ++ (with pkgs; [ gpick light scrot xclip ]);

    xdg.configFile."longcut/longcut.yaml".source =
      theme.substitute ./longcut.template.yaml;

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
