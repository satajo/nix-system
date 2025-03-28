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
          hashicorp.terraform
          jdinhlife.gruvbox
          jnoortheen.nix-ide
          k--kato.intellij-idea-keybindings
          ms-vscode.makefile-tools
          rust-lang.rust-analyzer
          tamasfe.even-better-toml
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
        numberedBookmarks = {
          keepBookmarksOnLineDelete = true;
          navigateThroughAllFiles = "replace";
          gutterIconNumberColor = theme.color.layer3.background;
          gutterIconFillColor = theme.color.layer3.accent;
        };
        workbench.colorTheme = "Gruvbox Dark Medium";
      };
    };
  };
}
