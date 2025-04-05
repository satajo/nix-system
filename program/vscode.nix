{ pkgs, ... }:
let
  theme = import ../theme/lib.nix { pkgs = pkgs; };
in
{
  home-manager.users.satajo = {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;

      # Fully manage versions through Nix.
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;

      # Require extensions to be installed through Nix configuration.
      mutableExtensionsDir = false; # Pr
      extensions =
        with pkgs.vscode-extensions;
        [
          # Listing at: https://open-vsx.org/
          # Search Nix by: nix search nixpkgs#vscode-extensions
          asciidoctor.asciidoctor-vscode
          esbenp.prettier-vscode
          hashicorp.terraform
          jdinhlife.gruvbox
          jnoortheen.nix-ide
          k--kato.intellij-idea-keybindings
          ms-vscode.makefile-tools
          redhat.vscode-yaml
          rust-lang.rust-analyzer
          tamasfe.even-better-toml
          timonwong.shellcheck
          vadimcn.vscode-lldb
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "numbered-bookmarks";
            publisher = "alefragnani";
            version = "8.5.0";
            hash = "sha256-7b75+mMlJVfe8VXZrIe1/z0ifTcz+sNQpscvbnaxdL4=";
          }
        ];

      userSettings = {
        editor.fontFamily = theme.font.monospace;
        explorer = {
          confirmDelete = false;
          confirmDragAndDrop = false;
        };
        nix.formatterPath = "nixfmt";
        numberedBookmarks = {
          keepBookmarksOnLineDelete = true;
          navigateThroughAllFiles = "replace";
          gutterIconNumberColor = theme.color.layer3.background;
          gutterIconFillColor = theme.color.layer3.accent;
        };
        redhat.telemetry.enabled = false;
        workbench = {
          colorTheme = "Gruvbox Dark Medium";
          tree = {
            indent = 24;
            renderIndentGuides = "always";
          };
        };

        # File-type specific configuration

        "[css]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };

        "[html]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };

        "[javascript]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };

        "[javascriptreact]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };

        "[typescript]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };

        "[typescriptreact]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
      };
    };
  };
}
