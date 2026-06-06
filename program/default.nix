{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./claude
    ./direnv
    ./foliate.nix
    ./git
    ./helix.nix
    ./liferea
    ./music-player.nix
    ./noisegen
    ./obsidian.nix
    ./podman.nix
    ./shell
    ./steam.nix
    ./telegram.nix
    ./terminal-emulator.nix
    ./thunar.nix
    ./timers
    ./todoist.nix
    ./web-browser.nix
    ./zed.nix
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
      filen-desktop # cloud drive (pulls in EOL electron, see permittedInsecurePackages below)
      gimp # slow but capable image editor
      hyperfine # benchmarking tool
      fastfetch # it's basically required, right?
      nil # nix language server
      pinta # quick but simple image editor
      proton-vpn # vpn provider
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

  nixpkgs.config.permittedInsecurePackages = [
    "electron-39.8.10" # filen-desktop wraps the default electron, which is EOL
  ];
}
