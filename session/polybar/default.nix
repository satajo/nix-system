{ pkgs, ... }:
let
  theme = import ../../theme/lib.nix { inherit pkgs; };
  c = theme.color;
  bin = {
    playerctl = "${pkgs.playerctl}/bin/playerctl";
    grep = "${pkgs.gnugrep}/bin/grep";
    xset = "${pkgs.xset}/bin/xset";
    pgrep = "${pkgs.procps}/bin/pgrep";
  };
in
{
  home-manager.users.satajo = {
    services.polybar = {
      enable = true;
      script = "polybar primary &";

      settings = {
        settings = {
          screenchange-reload = true;
          pseudo-transparency = true;
        };

        "bar/primary" = {
          width = "100%";
          height = 31;
          radius = 0;
          module-margin = 1;
          background = c.background;
          foreground = c.foreground;
          border-bottom-size = 1;
          border-bottom-color = c.border;
          line-size = "3pt";
          font = [
            "${theme.font.monospace}:size=13:weight=Medium;4"
            "${theme.font.icon}:size=13:weight=Medium;4"
          ];
          cursor-click = "pointer";
          cursor-scroll = "pointer";
          enable-ipc = true;

          # TODO: Make these externally injectable somewhen. For now, "noisegen" and "timers" are cheating.
          modules-left = "xworkspaces xwindow";
          modules-center = "insomnia now-playing noisegen timers";
          modules-right = "cpu memory disk volume battery-1 battery-2 calendar clock";
        };

        "module/battery-common" = {
          type = "internal/battery";
          full-at = 98;
          low-at = 15;
          format-charging = "<ramp-capacity> <label-charging>";
          format-charging-underline = c.positive;
          label-charging = "%percentage%%";
          format-discharging = "<ramp-capacity> <label-discharging>";
          label-discharging = "%percentage%%";
          format-full = "<ramp-capacity> <label-full>";
          label-full = "%percentage%%";
          format-low = "<ramp-capacity> <label-low>";
          format-low-underline = c.negative;
          label-low = "%percentage%%";
          ramp-capacity = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰁹"
          ];
        };

        "module/battery-1" = {
          "inherit" = "module/battery-common";
          battery = "BAT0";
        };

        "module/battery-2" = {
          "inherit" = "module/battery-common";
          battery = "BAT1";
        };

        "module/calendar" = {
          type = "internal/date";
          interval = 3600;
          date = "%A %d.%m.%Y w%V";
          label = "󰃭 %date%";
        };

        "module/clock" = {
          type = "internal/date";
          interval = 1;
          time = "%H:%M:%S";
          label = "󱑌 %time% ";
        };

        "module/cpu" = {
          type = "internal/cpu";
          interval = 1;
          label = "󰍛 %percentage%%";
        };

        "module/disk" = {
          type = "internal/fs";
          interval = 60;
          label-mounted = "󰋊 %percentage_used%%";
        };

        "module/memory" = {
          type = "internal/memory";
          interval = 5;
          label = " %percentage_used%%";
        };

        "module/insomnia" = {
          type = "custom/script";
          exec = "${bin.xset} q | ${bin.grep} -q \"timeout:  0\" && echo \"󰅶 Insomnia\" || echo \"\"";
          interval = 5;
        };

        "module/now-playing" = {
          type = "custom/script";
          exec = "${bin.playerctl} metadata --format \"{{artist}} - {{title}}\"";
          exec-if = "[ $(${bin.playerctl} status) == Playing ]";
          interval = 5;
          label = " %output:0:30:...%";
        };

        "module/volume" = {
          type = "internal/alsa";
          label-volume = "󰕾 %percentage%%";
          label-muted = "󰖁 %percentage%%";
          label-muted-underline = c.negative;
        };

        "module/xwindow" = {
          type = "internal/xwindow";
          label = "%title:0:30:...%";
        };

        "module/xworkspaces" = {
          type = "internal/xworkspaces";
          label-active = "%name%";
          label-active-foreground = c.foreground;
          label-active-background = c.background;
          label-active-underline = c.accent;
          label-active-padding = 1;
          label-occupied = "%name%";
          label-occupied-padding = 1;
          label-urgent = "%name%";
          label-urgent-background = c.background;
          label-urgent-underline = c.accent;
          label-urgent-padding = 1;
          label-empty = "%name%";
          label-empty-foreground = c.background;
          label-empty-padding = 1;
        };
      };
    };
  };
}
