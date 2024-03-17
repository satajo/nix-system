{ pkgs, ... }:
let colors = import ./gruvbox-colors.nix;
in rec {
  font = { monospace = "JetBrainsMonoNerdFont"; };
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

  # Utlity for substituting theme variables in configuration files.
  substitute = src:
    pkgs.substitute {
      src = src;
      # TODO: Change this to "substitutions" once it is made stable.
      # TODO: Use --replace-fail instead of --replace once it is made stable.
      replacements = [
        "--replace @FONT_MONOSPACE@ ${font.monospace}"

        "--replace @COLOR_FOREGROUND_LIGHT@ ${color.foreground.light}"
        "--replace @COLOR_FOREGROUND_NORMAL@ ${color.foreground.normal}"
        "--replace @COLOR_FOREGROUND_DARK@ ${color.foreground.dark}"

        "--replace @COLOR_BACKGROUND_LIGHT@ ${color.background.light}"
        "--replace @COLOR_BACKGROUND_NORMAL@ ${color.background.normal}"
        "--replace @COLOR_BACKGROUND_DARK@ ${color.background.dark}"

        "--replace @COLOR_ERROR_LIGHT@ ${color.error.light}"
        "--replace @COLOR_ERROR_NORMAL@ ${color.error.normal}"
        "--replace @COLOR_ERROR_DARK@ ${color.error.dark}"
      ];
    };
}
