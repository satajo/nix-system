{ pkgs, ... }:
let
  colors = import ./gruvbox-colors.nix;
  theme = {
    font = { monospace = "JetBrainsMono"; };
    color = {
      foreground = {
        light = colors.gray.light;
        normal = colors.gray.light;
        dark = colors.gray.regular;
      };
      background = {
        light = colors.black.light;
        normal = colors.black.regular;
        dark = colors.black.regular;
      };
      error = {
        light = colors.red.light;
        normal = colors.red.regular;
        dark = colors.red.regular;
      };
    };
  };
in {
  # Theme object which exports the theme as variables.
  theme = theme;

  # Utlity for substituting theme variables in configuration files.
  substitute = src:
    pkgs.substitute {
      src = src;
      # TODO: Change this to "substitutions" once it is made stable.
      # TODO: Use --replace-fail instead of --replace once it is made stable.
      replacements = [
        "--replace @FONT_MONOSPACE@ ${theme.font.monospace}"

        "--replace @COLOR_FOREGROUND_LIGHT@ ${theme.color.foreground.light}"
        "--replace @COLOR_FOREGROUND_NORMAL@ ${theme.color.foreground.normal}"
        "--replace @COLOR_FOREGROUND_DARK@ ${theme.color.foreground.dark}"

        "--replace @COLOR_BACKGROUND_LIGHT@ ${theme.color.background.light}"
        "--replace @COLOR_BACKGROUND_NORMAL@ ${theme.color.background.normal}"
        "--replace @COLOR_BACKGROUND_DARK@ ${theme.color.background.dark}"

        "--replace @COLOR_ERROR_LIGHT@ ${theme.color.error.light}"
        "--replace @COLOR_ERROR_NORMAL@ ${theme.color.error.normal}"
        "--replace @COLOR_ERROR_DARK@ ${theme.color.error.dark}"
      ];
    };
}
