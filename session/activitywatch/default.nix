{ lib, pkgs, ... }:
{
  home-manager.users.satajo = {
    services.activitywatch = {
      enable = true;

      # aw-server-rust is set to replace aw-server-python soon, so let's switch
      # over already.
      package = pkgs.aw-server-rust;

      watchers = {
        aw-watcher-afk = {
          package = pkgs.aw-watcher-afk;
          settings = {
            timeout = 180; # 3 minutes
            poll_time = 5;
          };
        };

        aw-watcher-window = {
          package = pkgs.aw-watcher-window;
          settings = {
            poll_time = 1;
          };
        };
      };
    };

    # Override the systemd target configuration to start after graphical-session target.
    # This keeps the watchers that depend on a graphical session from crashing.
    systemd.user.targets.activitywatch = {
      Unit = {
        Requires = lib.mkForce [ "graphical-session.target" ];
        After = lib.mkForce [ "graphical-session.target" ];
      };

      Install.WantedBy = lib.mkForce [ "graphical-session.target" ];
    };
  };
}
