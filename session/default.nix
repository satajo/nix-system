{ ... }: {
  imports = [
    ./i3 # Window manager
    ./keynav
    ./lightdm.nix # Display / login manager
    ./notifications
    ./rofi # Application switcher / launcher
    ./statusbar
  ];

  services.xserver = {
    enable = true;
    dpi = 120;
    displayManager.defaultSession = "none+i3";
  };
}

