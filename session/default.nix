{ ... }: {
  imports = [
    ./i3 # Window manager
    ./lightdm.nix # Display / login manage
  ];

  services.xserver = {
    enable = true;
    displayManager.defaultSession = "none+i3";
  };
}

