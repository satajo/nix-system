{ config, lib, pkgs, ... }: {
  imports = [
    ./alacritty
    ./docker.nix
    ./git.nix
    ./longcut
    ./obsidian.nix
    ./shell
    ./spotify.nix
    ./telegram.nix
    ./thunar.nix
    ./todoist.nix
  ];

  # System wide single-package programs with no configuration.
  environment.systemPackages = with pkgs; [
    bc # calculator
    coreutils # GNU coreutils
    curl
    htop
    git
    nano
    pkg-config
    ripgrep
    tig # Git terminal gui
    wget
    units # conversion between different units
    unzip # .zip extraction
  ];

  # Userspace single-package programs with no configuration.
  home-manager.users.satajo.home.packages = with pkgs;
    [
      evince # document viewer
      feh # image viewer
      firefox # browser
      gimp # slow but capable image editor
      hyperfine # benchmarking tool
      neofetch # it's basically required, right?
      nil # nix language server
      pinta # quick but simple image editor
      tldr # console command cheatsheets
      vscode # code editor / ide
      vlc # media player

      ## Kubernetes and virtualization
      minikube # local k8s deployment
      kubectl
      k9s # kubectl terminal ui
      skaffold # kubernetes deployer / dev environment
    ] ++ lib.optionals config.profile.personal [
      bitwarden # password manager
      discord # chat
    ];
}
