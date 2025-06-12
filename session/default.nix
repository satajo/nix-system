{ ... }:
{
  imports = [
    ./activitywatch # Tracker
    ./dunst # Notifications
    ./gtk
    ./i3 # Window manager
    ./i3lock # Screen locker
    ./keynav
    ./longcut # Command runner
    ./polybar # Status bar
    ./redshift.nix
    ./rofi # Application switcher / launcher
  ];

  services.displayManager.defaultSession = "none+i3";

  services.xserver = {
    enable = true;
    dpi = 120;
    wacom.enable = true;
  };

  # Keyring management
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;
}
