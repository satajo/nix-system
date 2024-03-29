{ config, lib, pkgs, ... }: {
  imports =
    [ ./alacritty ./file-manager ./git.nix ./longcut ./obsidian.nix ./shell ];

  # System wide single-package programs with no configuration.
  environment.systemPackages = with pkgs; [
    coreutils # GNU coreutils
    curl
    htop
    git
    nano
    pkg-config
    tig # Git terminal gui
    wget
    unzip # .zip extraction
  ];

  # Userspace single-package programs with no configuration.
  home-manager.users.satajo.home.packages = with pkgs;
    [
      evince # document viewer
      feh # image viewer
      firefox # browser
      hyperfine # benchmarking tool
      neofetch # it's basically required, right?
      nil # nix language server
      spotify
      tldr # console command cheatsheets
      vscode # code editor / ide
      vlc # media player
    ] ++ lib.optionals config.profile.personal [
      bitwarden # password manager
      discord # chat
      telegram-desktop # chat
      todoist-electron # todo list
    ];
}
