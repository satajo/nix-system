{ inputs, pkgs, ... }:
let
  theme = import ../theme/lib.nix { pkgs = pkgs; };
  zed-editor = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.zed-editor;
in
{
  home-manager.users.satajo = {
    home.packages = [ zed-editor ];

    xdg.configFile."zed/settings.json".text = builtins.toJSON {
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

      auto_install_extensions = {
        nix = true;
        toml = true;
        colored-zed-icons-theme = true;
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
