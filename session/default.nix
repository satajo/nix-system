{ ... }: {
  imports = [
    ./i3 # Window manager
    ./lightdm.nix # Display / login manage
    ./polybar # Status bar
  ];

  services.xserver = {
    enable = true;
    displayManager.defaultSession = "none+i3";
  };
}

