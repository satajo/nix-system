{ pkgs, ... }:
let
  colors = import ./gruvbox-colors.nix;
in
rec {
  font = {
    icon = "SymbolsNerdFont";
    monospace = "JetBrainsMonoNerdFont";
  };

  color = {
    # 1. layer is the deepest layer of the UI, used as the base background color
    # of windows and applications.
    #
    # Examples: Desktop background, full-screen application background colors
    layer1 = {
      accent = "#458588";
      background = "#1d2021";
      border = "#282828";
      foreground = "#d5c4a1";
      negative = "#cc241d";
      positive = "#b8bb26";
    };

    # 2. layer is for large windows and UI containers that get drawn on top of
    # the 1. layer, standing above it.
    #
    # Examples: Modal application window background colors, content boxes inside
    # full-screen applications.
    layer2 = {
      accent = "#fe8019";
      background = "#282828";
      border = "#3c3836";
      foreground = "#ebdbb2";
      negative = "#cc241d";
      positive = "#b8bb26";
    };

    # 3. layer consists of content boxes and element-backgrounds inside modal
    # windows. Small pop-up windows and dialogues should be this color.
    #
    # Examples: Text input inside a dialog box inside a window, notification pop-up.
    layer3 = {
      accent = "#fe8019";
      background = "#3c3836";
      border = "#504945";
      foreground = "#ebdbb2";
      negative = "#cc241d";
      positive = "#b8bb26";
    };

    # 4. layer covers individual elements that must be highlighted from layer 3.
    #
    # Examples: Selected item inside a layer 3 menu. Call to action style buttons.
    layer4 = {
      accent = "#fe8019";
      background = "#504945";
      border = "#665c54";
      foreground = "#fbf1c7";
      negative = "#cc241d";
      positive = "#b8bb26";
    };
  };

  # Utlity for substituting theme variables in configuration files.
  substitute =
    src:
    pkgs.substitute {
      src = src;
      # TODO: Change this to "substitutions" once it is made stable.
      # TODO: Use --replace-fail instead of --replace once it is made stable.
      replacements = [
        "--replace @FONT_ICON@ ${font.icon}"
        "--replace @FONT_MONOSPACE@ ${font.monospace}"

        "--replace @COLOR_LAYER1_ACCENT@ ${color.layer1.accent}"
        "--replace @COLOR_LAYER2_ACCENT@ ${color.layer2.accent}"
        "--replace @COLOR_LAYER3_ACCENT@ ${color.layer3.accent}"
        "--replace @COLOR_LAYER4_ACCENT@ ${color.layer4.accent}"

        "--replace @COLOR_LAYER1_BACKGROUND@ ${color.layer1.background}"
        "--replace @COLOR_LAYER2_BACKGROUND@ ${color.layer2.background}"
        "--replace @COLOR_LAYER3_BACKGROUND@ ${color.layer3.background}"
        "--replace @COLOR_LAYER4_BACKGROUND@ ${color.layer4.background}"

        "--replace @COLOR_LAYER1_BORDER@ ${color.layer1.border}"
        "--replace @COLOR_LAYER2_BORDER@ ${color.layer2.border}"
        "--replace @COLOR_LAYER3_BORDER@ ${color.layer3.border}"
        "--replace @COLOR_LAYER4_BORDER@ ${color.layer4.border}"

        "--replace @COLOR_LAYER1_FOREGROUND@ ${color.layer1.foreground}"
        "--replace @COLOR_LAYER2_FOREGROUND@ ${color.layer2.foreground}"
        "--replace @COLOR_LAYER3_FOREGROUND@ ${color.layer3.foreground}"
        "--replace @COLOR_LAYER4_FOREGROUND@ ${color.layer4.foreground}"

        "--replace @COLOR_LAYER1_NEGATIVE@ ${color.layer1.negative}"
        "--replace @COLOR_LAYER2_NEGATIVE@ ${color.layer2.negative}"
        "--replace @COLOR_LAYER3_NEGATIVE@ ${color.layer3.negative}"
        "--replace @COLOR_LAYER4_NEGATIVE@ ${color.layer4.negative}"

        "--replace @COLOR_LAYER1_POSITIVE@ ${color.layer1.positive}"
        "--replace @COLOR_LAYER2_POSITIVE@ ${color.layer2.positive}"
        "--replace @COLOR_LAYER3_POSITIVE@ ${color.layer3.positive}"
        "--replace @COLOR_LAYER4_POSITIVE@ ${color.layer4.positive}"
      ];
    };
}
