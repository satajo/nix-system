{ pkgs, ... }:
let
  theme = import ../../theme/lib.nix { pkgs = pkgs; };
  cws = import ./i3-contextual-workspaces.nix { inherit pkgs; };

  wallpaperCacheKey = builtins.hashString "sha256" (
    builtins.concatStringsSep "" [
      (toString ./wallpaper.png)
      theme.color.backgroundLower
      theme.stringToThemeColorBashFn
    ]
  );

  contextWallpaper = pkgs.writeShellApplication {
    name = "context-wallpaper";
    runtimeInputs = with pkgs; [
      imagemagick
      feh
      coreutils
    ];
    text = ''
      context="$1"
      if [ -z "$context" ]; then
        exit 1
      fi

      ${theme.stringToThemeColorBashFn}
      context_color=$(string_to_theme_color "$context")

      cache_dir="''${XDG_CACHE_HOME:-$HOME/.cache}/context-wallpapers/${wallpaperCacheKey}"
      cached="$cache_dir/$context.png"

      if [ ! -f "$cached" ]; then
        mkdir -p "$cache_dir"
        magick ${./wallpaper.png} -colorspace RGB \
          -fill "$context_color" -opaque "#ffffff" \
          -fill "${theme.color.backgroundLower}" -opaque "#000000" \
          "$cached"
      fi

      feh --bg-center --image-bg "${theme.color.backgroundLower}" "$cached"
    '';
  };

  contextWallpaperListener = pkgs.writeShellApplication {
    name = "context-wallpaper-listener";
    runtimeInputs = [
      cws.watchFocus
      contextWallpaper
    ];
    text = ''
      i3cws-watch-focus | while read -r context _; do
        context-wallpaper "$context"
      done
    '';
  };
in
{
  home-manager.users.satajo = {
    systemd.user.services.context-wallpaper = {
      Unit = {
        Description = "Context-aware wallpaper manager";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        Type = "simple";
        ExecStart = "${contextWallpaperListener}/bin/context-wallpaper-listener";
        Restart = "on-failure";
        RestartSec = "1";
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
