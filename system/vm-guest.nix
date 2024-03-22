{ config, lib, pkgs, ... }: {
  # Functionality for running as a virtual machine guest.
  #
  # See the matcing user-config under user-modules/vm-guest.nix

  config = lib.mkIf config.profile.vm-guest {

    # System service for spice-vdagentd allows the user-specific agents to communicate with the host
    services.spice-vdagentd.enable = true;

    # User-service for individual agent instance.
    systemd.user.services.spice-vdagent = {
      description = "Spice agent";
      after = [ "graphical-session-pre.target" ];
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.spice-vdagent}/bin/spice-vdagent -x -d";
        Restart = "always";
        RestartSec = "1s";
      };
    };

    # User-service for spice-autorandr
    systemd.user.services.spice-autorandr = {
      description = "Spice autorandr";
      after = [ "spice-vdagent.service" ];
      bindsTo = [ "spice-vdagent.service" ];
      wantedBy = [ "graphical-session.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.spice-autorandr}/bin/spice-autorandr";
        Restart = "on-failure";
      };
    };
  };
}
