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
    accent = {
      light = "#83a598";
      normal = "#458588";
      dark = "#458588";
    };
    negative = {
      light = "#fb4934";
      normal = "#cc241d";
      dark = "#cc241d";
    };
    positive = {
      light = "#98971a";
      normal = "#b8bb26";
      dark = "#b8bb26";
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

        "--replace @COLOR_ACCENT_LIGHT@ ${color.accent.light}"
        "--replace @COLOR_ACCENT_NORMAL@ ${color.accent.normal}"
        "--replace @COLOR_ACCENT_DARK@ ${color.accent.dark}"

        "--replace @COLOR_NEGATIVE_LIGHT@ ${color.negative.light}"
        "--replace @COLOR_NEGATIVE_NORMAL@ ${color.negative.normal}"
        "--replace @COLOR_NEGATIVE_DARK@ ${color.negative.dark}"

        "--replace @COLOR_POSITIVE_LIGHT@ ${color.positive.light}"
        "--replace @COLOR_POSITIVE_NORMAL@ ${color.positive.normal}"
        "--replace @COLOR_POSITIVE_DARK@ ${color.positive.dark}"
      ];
    };
}
