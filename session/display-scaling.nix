# Per-host display scaling, and the single source of truth for DPI.
#
# Point sizes are physical (1pt = 1/72"), so they only mean something once the
# renderer knows the panel's true density: panelDpi supplies that, and at
# scaleFactor 1 a 12pt font is genuinely 1/6" on screen. scaleFactor is the
# single ergonomic knob — larger (>1) when you sit far, smaller (<1) when you
# sit close. Their product is the logical DPI.
#
# That one DPI drives the core X11 DPI (Polybar et al.) via services.xserver.dpi
# *and* the Xft.dpi resource (Alacritty/winit, GTK, Qt) merged at session start
# below. Without the Xft half those apps fall back to the per-monitor EDID DPI,
# which on a dense panel is far higher and renders text oversized.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.displayScaling;
in
{
  options.custom.displayScaling = {
    panelDpi = lib.mkOption {
      type = lib.types.nullOr lib.types.number;
      default = null;
      description = ''
        The panel's true pixel density, in DPI: horizontal resolution divided
        by physical width in inches. From `xrandr`'s `connected` line (px and
        mm), this is widthPx / (widthMM / 25.4).
      '';
    };

    scaleFactor = lib.mkOption {
      type = lib.types.number;
      default = 1.0;
      description = "Ergonomic size multiplier on the honest panel DPI. >1 enlarges (you sit far), <1 shrinks (you sit close).";
    };
  };

  config = {
    # panelDpi × scaleFactor once a host supplies its panel facts; a plain
    # default otherwise.
    services.xserver.dpi =
      if cfg.panelDpi != null then
        builtins.floor (cfg.panelDpi * cfg.scaleFactor + 0.5)
      else
        lib.mkDefault 120;

    # Pin Xft.dpi to that value so resource-database apps scale from our DPI
    # rather than the per-monitor EDID DPI.
    services.xserver.displayManager.sessionCommands = ''
      echo "Xft.dpi: ${toString config.services.xserver.dpi}" | ${pkgs.xrdb}/bin/xrdb -merge
    '';
  };
}
