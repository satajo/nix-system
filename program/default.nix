{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./foliate.nix
    ./terminal-emulator.nix
    ./git
    ./liferea
    ./noisegen
    ./obsidian.nix
    ./podman.nix
    ./timers
    ./shell
    ./rhythmbox.nix
    ./steam.nix
    ./telegram.nix
    ./thunar.nix
    ./todoist.nix
    ./vscode.nix
    ./web-browser.nix
  ];

  # System wide single-package programs with no configuration.
  environment.systemPackages = with pkgs; [
    calc
    gnumake
    nano
    pkg-config
  ];

  # Userspace single-package programs with no configuration.
  home-manager.users.satajo.home.packages =
    with pkgs;
    [
      chromium # another browser, as some sites don't work on Firefox
      evince # document viewer
      feh # image viewer
      filen-desktop # cloud drive
      gimp # slow but capable image editor
      hyperfine # benchmarking tool
      neofetch # it's basically required, right?
      nil # nix language server
      pinta # quick but simple image editor
      protonvpn-gui # vpn provider
      tldr # console command cheatsheets
      vlc # video player

      ## Kubernetes and virtualization
      minikube # local k8s deployment
      kubectl
      k9s # kubectl terminal ui
      skaffold # kubernetes deployer / dev environment
    ]
    ++ lib.optionals config.profile.personal [
      anki # spaced repetition learning tool
      bitwarden-desktop # password manager
      discord # chat
      krita # art program
    ];
}
