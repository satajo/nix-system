{ config, pkgs, ... }:

{
  imports = [
    ./bash
    ./starship
  ];

  # Useful command-line utilities.
  environment.systemPackages = with pkgs; [
    bc # calculator
    coreutils # GNU coreutils
    curl
    htop
    ripgrep
    tree
    wget
    units # conversion between different units
    usbutils
    unzip # .zip extraction
  ];

  # fzf
  programs.fzf = {
    keybindings = true;
    fuzzyCompletion = true;
  };
}
