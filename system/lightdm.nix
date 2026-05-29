{
  config,
  pkgs,
  callPackage,
  ...
}:
let
  theme = import ../theme/lib.nix { pkgs = pkgs; };
in
{
  environment.systemPackages = with pkgs; [ ayu-theme-gtk ];

  services.xserver = {
    displayManager = {
      lightdm = {
        enable = true;
        # TODO: background regex check is invalid. Fix it, and use value from layer 1.
        background = "#0d1016";
        greeters.gtk = {
          enable = true;
          # For theme names, see: /run/current-system/sw/share/themes/
          theme.name = "Ayu-Dark";
        };
      };
    };
  };

  # Autologin straight into the default session so a successful LUKS unlock at
  # boot is the only credential prompt. The runtime screen lock (xss-lock +
  # i3lock) is unaffected and still guards suspend, resume, and idle.
  services.displayManager.autoLogin = {
    enable = true;
    user = "satajo";
  };
}
