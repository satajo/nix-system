{ config, pkgs, ... }:
let
  theme = import ../theme/lib.nix { pkgs = pkgs; };
in
{
  home-manager.users.satajo = {
    programs.alacritty = {
      enable = true;
      settings = {
        general = {
          live_config_reload = true;
        };

        colors = {
          primary = {
            background = theme.color.background;
            foreground = theme.color.foreground;
          };

          cursor = {
            cursor = theme.color.foreground;
            text = theme.color.background;
          };

          normal = {
            black = theme.color.raw.black.regular;
            blue = theme.color.raw.blue.regular;
            cyan = theme.color.raw.aqua.regular;
            green = theme.color.raw.green.regular;
            magenta = theme.color.raw.purple.regular;
            red = theme.color.raw.red.regular;
            white = theme.color.raw.gray.regular;
            yellow = theme.color.raw.yellow.regular;
          };

          bright = {
            black = theme.color.raw.black.light;
            blue = theme.color.raw.blue.light;
            cyan = theme.color.raw.aqua.light;
            green = theme.color.raw.green.light;
            magenta = theme.color.raw.purple.light;
            red = theme.color.raw.red.light;
            white = theme.color.raw.gray.light;
            yellow = theme.color.raw.yellow.light;
          };
        };

        font = {
          size = 11.0;

          bold = {
            family = theme.font.monospace;
            style = "Bold";
          };

          bold_italic = {
            family = theme.font.monospace;
            style = "Bold Italic";
          };

          italic = {
            family = theme.font.monospace;
            style = "Italic";
          };

          normal = {
            family = theme.font.monospace;
            style = "Regular";
          };
        };

        scrolling = {
          history = 10000;
          multiplier = 1;
        };

        window = {
          decorations = "full";
          padding = {
            x = 24;
            y = 24;
          };
        };

        keyboard = {
          bindings = [
            {
              key = "Return";
              mods = "Shift";
              chars = "\n";
            }
          ];
        };
      };
    };
  };

  longcut.fragments = [
    {
      core.layers = [
        {
          name = "Open";
          commands = [
            {
              name = "Terminal";
              shortcut = "t";
              steps = "${pkgs.alacritty}/bin/alacritty";
              synchronous = false;
            }
          ];
        }
      ];
    }
  ];
}
