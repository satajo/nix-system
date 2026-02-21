{
  config,
  lib,
  pkgs,
  ...
}:
{
  home-manager.users.satajo = {
    home.packages = with pkgs; [ firefox ];

    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "text/html" = "firefox.desktop";
      "application/xhtml+xml" = "firefox.desktop";
    };
  };

  longcut.fragments = [
    {
      core.layers = [
        {
          name = "Open";
          commands = [
            {
              name = "Browser";
              shortcut = "b";
              steps = "${pkgs.firefox}/bin/firefox";
              synchronous = false;
            }
          ];
        }
      ];
    }
  ];
}
