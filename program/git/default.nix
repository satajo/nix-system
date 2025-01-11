{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    tig # Git terminal UI
  ];

  home-manager.users.satajo.programs.git = {
    enable = true;
    userEmail = "sami.jokela@satajo.com";
    userName = "Sami Jokela";
    package = pkgs.gitFull;

    diff-so-fancy = {
      enable = true;
      changeHunkIndicators = true;
      markEmptyLines = false;
      stripLeadingSymbols = true;
    };

    extraConfig = {
      mergetool.hideResolved = true;
    };
  };
}
