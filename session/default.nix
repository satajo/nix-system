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

  services.displayManager.defaultSession = "none+i3";

  services.xserver = {
    enable = true;
    dpi = 120;
  };
}

