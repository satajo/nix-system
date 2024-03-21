{ pkgs, ... }: {
  imports = [ ./alacritty ./longcut ./shell ./file-manager ];

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
  home-manager.users.satajo.home.packages = with pkgs; [
    firefox # Browser
    hyperfine # Benchmarking tool
    tldr # Console command cheatsheets
    vscode # Visual Studio Code
  ];
}
