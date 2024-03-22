{ ... }: {
  imports = [
    ./i3 # Window manager
    ./lightdm.nix # Display / login manage
    ./notifications
    ./polybar # Status bar
    ./rofi # Application switcher / launcher
  ];

  services.xserver = {
    enable = true;
    dpi = 120;
    displayManager.defaultSession = "none+i3";
  };
}

