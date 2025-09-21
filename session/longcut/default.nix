{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  package = inputs.longcut.packages.${pkgs.system}.default;
  theme = import ../../theme/lib.nix { pkgs = pkgs; };

  configFile = theme.substitute ./longcut.template.yaml;

  configCheckOk =
    pkgs.runCommand "longcut-config-check"
      {
        nativeBuildInputs = [ package ];
      }
      ''
        # Run the check
        ${package}/bin/longcut --config-file ${configFile} --check-config-only

        # If we get here, the check passed
        touch $out
      '';
in
{
  assertions = [
    {
      assertion = builtins.pathExists configCheckOk;
      message = "Longcut configuration validation failed";
    }
  ];

  home-manager.users.satajo = {
    home.packages = [
      package
    ]
    ++ (with pkgs; [
      brightnessctl
      gpick
      jq
      scrot
      translate-shell
      xclip
    ]);

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
        ExecStart = "${pkgs.runtimeShell} -lc '${package}/bin/longcut --config-file ${configFile}'";
        KillMode = "process";
        Restart = "always";
        RestartSec = "1s";
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
