{ config, pkgs, ... }:
let
  git-autofixup = pkgs.callPackage ./git-autofixup.nix { };
in
{
  environment.systemPackages = with pkgs; [
    git
    git-autofixup
    tig # Git terminal UI
  ];

  home-manager.users.satajo.programs = {
    git = {
      enable = true;
      settings = {
        init.defaultBranch = "main";
        mergetool.hideResolved = true;
        user.email = "sami.jokela@satajo.com";
        user.name = "Sami Jokela";
      };

      package = pkgs.gitFull;
    };

    diff-so-fancy = {
      enable = true;
      enableGitIntegration = true;
      settings = {
        changeHunkIndicators = true;
        markEmptyLines = false;
        stripLeadingSymbols = true;
      };
    };
  };
}
