{ pkgs, ... }:
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

  # Publishes desktop preferences (e.g. color-scheme) over a toolkit-independent
  # D-Bus interface so portal-aware apps (Zed, Electron, etc.) can react to them.
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "gtk";
  };

  # Tells the portal that dark appearance is preferred. home-manager's gtk
  # module wraps the underlying dconf write; the option lives under `gtk`
  # only by name, the value is desktop-independent (any portal-aware app
  # reads it, regardless of toolkit).
  home-manager.users.satajo.gtk.colorScheme = "dark";

  # Keyring management
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;
}
