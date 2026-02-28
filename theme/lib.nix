# Color palette based on the Ayu Dark theme (https://github.com/ayu-theme).
{ pkgs, ... }:
let
  palette = {
    # Terminal ANSI colors: regular = normal, light = bright.
    black = {
      regular = "#0a0000";
      light = "#0a0000";
    };
    red = {
      regular = "#e6495a";
      light = "#f07178";
    };
    green = {
      regular = "#97c142";
      light = "#aad94c";
    };
    yellow = {
      regular = "#e89d37";
      light = "#ffb454";
    };
    blue = {
      regular = "#17acf2";
      light = "#59c2ff";
    };
    purple = {
      regular = "#c385fe";
      light = "#d2a6ff";
    };
    aqua = {
      regular = "#84ceb5";
      light = "#95e6cb";
    };
    gray = {
      regular = "#ffffff";
      light = "#ffffff";
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
    foreground = "#bfbdb6"; # editor foreground
    foregroundLower = "#5a6378"; # ui.fg (muted/secondary text)
    foregroundUpper = "#ffffff";

    background = "#10141c"; # surface.lift (editor bg)
    backgroundLower = "#0d1017"; # surface.base (below)
    backgroundUpper = "#1b1f29"; # ui.line (above)

    border = "#404953"; # gray shade 2

    # Semantic colors
    accent = "#e6b450"; # common.accentTint
    negative = "#d95757"; # common.error
    positive = palette.green.light;
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
