{ ... }: {
  imports = [
    ./i3 # Window manager
    ./keynav
    ./lightdm.nix # Display / login manager
    ./notifications
    ./rofi # Application switcher / launcher
    ./screen-locker
    ./statusbar
  ];

  services.xserver = {
    enable = true;
    dpi = 120;
    displayManager.defaultSession = "none+i3";
  };
}

