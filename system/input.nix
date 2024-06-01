let
  keyboardLayout = "colemak";
in
{

  # Console keymap
  console = {
    earlySetup = true;
    keyMap = keyboardLayout;
  };

  # Xserver keymap
  services.xserver = {
    autoRepeatDelay = 200;
    autoRepeatInterval = 50;
    xkb = {
      layout = "us";
      variant = keyboardLayout;
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput = {
    enable = true;
    mouse.accelProfile = "flat";
    touchpad.accelProfile = "adaptive";
  };
}
