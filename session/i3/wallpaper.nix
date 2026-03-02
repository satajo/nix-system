{ pkgs, ... }:
let
  theme = import ../../theme/lib.nix { pkgs = pkgs; };

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
      name="$1"
      if [ -z "$name" ]; then
        exit 1
      fi

      context="''${name:0:1}"

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
      pkgs.i3
      pkgs.jq
      contextWallpaper
    ];
    text = ''
      current=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused) | .name')
      context-wallpaper "$current"

      i3-msg -m -t subscribe '["workspace"]' | jq --unbuffered -r 'select(.change == "focus") | .current.name' | while read -r name; do
        context-wallpaper "$name"
      done
    '';
  };
in
{
  home-manager.users.satajo = {
    systemd.user.services.context-wallpaper = {
      Unit = {
        Description = "Context-aware wallpaper manager";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        Type = "simple";
        ExecStart = "${contextWallpaperListener}/bin/context-wallpaper-listener";
        Restart = "on-failure";
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
