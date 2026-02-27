{ pkgs, ... }:
let
  theme = import ../theme/lib.nix { pkgs = pkgs; };
in
{
  home-manager.users.satajo = {
    home.packages = [ pkgs.zed-editor ];

    xdg.configFile."zed/settings.json".text = builtins.toJSON {
      theme = {
        mode = "dark";
        dark = "Ayu Dark";
        light = "Ayu Light";
      };
      buffer_font_family = theme.font.monospace;
      buffer_font_size = 14;
      ui_font_size = 16;
    };
  };

  longcut.fragments = [
    {
      core.layers = [
        {
          name = "Open";
          commands = [
            {
              name = "Editor";
              shortcut = "e";
              steps = "${pkgs.zed-editor}/bin/zeditor --new";
              synchronous = false;
            }
          ];
        }
      ];
    }
  ];
}
