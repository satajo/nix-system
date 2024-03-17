{ pkgs, ... }:
let colors = import ./gruvbox-colors.nix;
in rec {
  font = {
    icon = "SymbolsNerdFont";
    monospace = "JetBrainsMonoNerdFont";
  };

  color = {
    foreground = {
      light = "#fbf1c7";
      normal = "#ebdbb2";
      dark = "#d5c4a1";
    };
    background = {
      light = "#3c3836";
      normal = "#282828";
      dark = "#1d2021";
    };
    error = {
      light = "#fb4934";
      normal = "#cc241d";
      dark = "#cc241d";
    };
  };

  # Utlity for substituting theme variables in configuration files.
  substitute = src:
    pkgs.substitute {
      src = src;
      # TODO: Change this to "substitutions" once it is made stable.
      # TODO: Use --replace-fail instead of --replace once it is made stable.
      replacements = [
        "--replace @FONT_ICON@ ${font.icon}"
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
