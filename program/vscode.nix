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
      extensions = with pkgs.vscode-extensions; [
        # Listing at: https://open-vsx.org/
        # Search Nix by: nix search nixpkgs#vscode-extensions
        asciidoctor.asciidoctor-vscode
        jdinhlife.gruvbox
        jnoortheen.nix-ide
        k--kato.intellij-idea-keybindings
        ms-vscode.makefile-tools
        rust-lang.rust-analyzer
        tamasfe.even-better-toml
      ];

      userSettings = {
        editor.fontFamily = theme.font.monospace;
        workbench.colorTheme = "Gruvbox Dark Medium";
      };
    };
  };
}
