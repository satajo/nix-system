{ pkgs, pkgs-unstable, ... }:
let
  theme = import ../theme/lib.nix { pkgs = pkgs; };
  zed-editor = pkgs-unstable.zed-editor;
in
{
  home-manager.users.satajo.programs.zed-editor = {
    enable = true;
    package = zed-editor;

    extensions = [
      "colored-zed-icons-theme"
      "nix"
      "toml"
    ];

    # Allow local edits to be made to the options not covered in the userSettings below.
    mutableUserSettings = true;

    userSettings = {
      theme = {
        mode = "system";
        dark = "Ayu Dark";
        light = "Ayu Light";
      };
      icon_theme = {
        mode = "system";
        dark = "Colored Zed Icons Theme Dark";
        light = "Colored Zed Icons Theme Light";
      };
      buffer_font_family = theme.font.monospace;
      buffer_font_size = 14;
      ui_font_size = 16;
      which_key = {
        enabled = true;
        delay_ms = 0;
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
              name = "Editor";
              shortcut = "e";
              steps = [ { bash = "${zed-editor}/bin/zeditor --new"; } ];
              synchronous = false;
            }
          ];
        }
      ];
    }
  ];
}
