{ pkgs, ... }:
let
  palette = {
    black = {
      regular = "#282828";
      light = "#928374";
    };
    red = {
      regular = "#cc241d";
      light = "#fd4934";
    };
    green = {
      regular = "#98971a";
      light = "#b8bb26";
    };
    yellow = {
      regular = "#d79921";
      light = "#fabd2f";
    };
    blue = {
      regular = "#458588";
      light = "#83a598";
    };
    purple = {
      regular = "#b16286";
      light = "#d3869b";
    };
    aqua = {
      regular = "#689d6a";
      light = "#8ec07c";
    };
    gray = {
      regular = "#a89984";
      light = "#ebdbb2";
    };
  };
in
rec {
  font = {
    icon = "SymbolsNerdFont";
    monospace = "JetBrainsMono Nerd Font";
  };

  color = {
    # Directly export the color palette for use with applications that wish to
    # render a specific color, irrelevant of its semantics.
    raw = palette;

    # Foreground, background, borders.
    foreground = "#ebdbb2";
    foregroundLower = "#bdae93";
    foregroundUpper = "#fbf1c7";

    background = "#282828";
    backgroundLower = "#1d2021";
    backgroundUpper = "#3c3836";

    border = "#3c3836";

    # Semantic colors
    accent = "#fe8019";
    negative = palette.red.regular;
    positive = palette.green.regular;
  };

  # Utlity for substituting theme variables in configuration files.
  substitute =
    src:
    pkgs.substitute {
      src = src;
      substitutions = [
        # Fonts

        "--replace-quiet"
        "@FONT_ICON@"
        "${font.icon}"

        "--replace-quiet"
        "@FONT_MONOSPACE@"
        "${font.monospace}"

        # Colors

        "--replace-quiet"
        "@COLOR_ACCENT@"
        "${color.accent}"

        "--replace-quiet"
        "@COLOR_BACKGROUND@"
        "${color.background}"

        "--replace-quiet"
        "@COLOR_BACKGROUND_LOWER@"
        "${color.backgroundLower}"

        "--replace-quiet"
        "@COLOR_BACKGROUND_UPPER@"
        "${color.backgroundUpper}"

        "--replace-quiet"
        "@COLOR_BORDER@"
        "${color.border}"

        "--replace-quiet"
        "@COLOR_FOREGROUND@"
        "${color.foreground}"

        "--replace-quiet"
        "@COLOR_FOREGROUND_LOWER@"
        "${color.foregroundLower}"

        "--replace-quiet"
        "@COLOR_FOREGROUND_UPPER@"
        "${color.foregroundUpper}"

        "--replace-quiet"
        "@COLOR_NEGATIVE@"
        "${color.negative}"

        "--replace-quiet"
        "@COLOR_POSITIVE@"
        "${color.positive}"
      ];
    };
}
