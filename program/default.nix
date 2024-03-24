{ config, lib, pkgs, ... }: {
  imports = [ ./alacritty ./file-manager ./longcut ./obsidian.nix ./shell ];

  # System wide single-package programs with no configuration.
  environment.systemPackages = with pkgs; [
    curl
    htop
    git
    nano
    tig # Git terminal gui
    wget
  ];

  # Userspace single-package programs with no configuration.
  home-manager.users.satajo.home.packages = with pkgs;
    [
      firefox # browser
      hyperfine # benchmarking tool
      nil # nix language server
      tldr # console command cheatsheets
      vscode # code editor / ide
    ] ++ lib.optionals config.profile.personal [
      bitwarden # password manager
      discord # chat
      telegram-desktop # chat
      todoist-electron # todo list
    ];
}
