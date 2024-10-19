{ pkgs, ... }:
let
  theme = import ../../theme/lib.nix { pkgs = pkgs; };

  applyWallpaperTheme =
    image:
    pkgs.runCommand "wallpaper.png" { nativeBuildInputs = [ pkgs.imagemagick ]; } ''
      magick ${image} -colorspace RGB \
        -fill "${theme.color.layer2.background}" -opaque "#ffffff" \
        -fill "${theme.color.layer1.background}" -opaque "#000000" \
        $out
    '';
in
{
  environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw

  # i3 comes with no compositor so we use picom with it.
  services.picom = {
    enable = true;
  };

  services.xserver = {
    desktopManager.xterm.enable = false;

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [ feh ];
    };
  };

  home-manager.users.satajo = {
    xdg.configFile."i3/config".source = theme.substitute ./config.template;
    xdg.configFile."i3/wallpaper.png".source = applyWallpaperTheme ./wallpaper.png;
  };
}
