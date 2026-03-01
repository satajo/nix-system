{ pkgs, ... }:
let
  theme = import ../../theme/lib.nix { pkgs = pkgs; };

  applyWallpaperTheme =
    image:
    pkgs.runCommand "wallpaper.png" { nativeBuildInputs = [ pkgs.imagemagick ]; } ''
      magick ${image} -colorspace RGB \
        -fill "${theme.color.background}" -opaque "#ffffff" \
        -fill "${theme.color.backgroundLower}" -opaque "#000000" \
        $out
    '';

  i3Msg = "${pkgs.i3}/bin/i3-msg";
in
{
  environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw

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

    # Wire up the tray target to enable home-manager based tray-services to autostart.
    systemd.user.targets.tray = {
      Unit.After = [ "graphical-session.target" ];
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };

  longcut.fragments = [
    {
      core = {
        commands = [
          {
            name = "Switch context";
            shortcut = "c";
            steps = [ { bash = "${i3Msg} workspace {0}{1}"; } ];
            parameters = [
              {
                name = "Context name";
                type = "character";
              }
              {
                name = "Workspace name";
                type = "character";
              }
            ];
          }
          {
            name = "Switch workspace";
            shortcut = "w";
            steps = [
              {
                bash = ''
                  CONTEXT=$(${i3Msg} -t get_workspaces | jq -r '.[] | select(.focused) | .name[0:1]')
                  ${i3Msg} workspace "$CONTEXT"{0}
                '';
              }
            ];
            parameters = [
              {
                name = "Workspace name";
                type = "character";
              }
            ];
          }

          ## Focus commands
          {
            name = "Focus down";
            shortcut = "Down";
            final = false;
            steps = [ { bash = "${i3Msg} focus down"; } ];
          }
          {
            name = "Focus left";
            shortcut = "Left";
            final = false;
            steps = [ { bash = "${i3Msg} focus left"; } ];
          }
          {
            name = "Focus right";
            shortcut = "Right";
            final = false;
            steps = [ { bash = "${i3Msg} focus right"; } ];
          }
          {
            name = "Focus up";
            shortcut = "Up";
            final = false;
            steps = [ { bash = "${i3Msg} focus up"; } ];
          }
          {
            name = "Focus parent";
            shortcut = "PageUp";
            final = false;
            steps = [ { bash = "${i3Msg} focus parent"; } ];
          }
          {
            name = "Focus child";
            shortcut = "PageDown";
            final = false;
            steps = [ { bash = "${i3Msg} focus child"; } ];
          }

          ## Move commands
          {
            name = "Move down";
            shortcut = {
              key = "Down";
              modifiers = "shift";
            };
            final = false;
            steps = [ { bash = "${i3Msg} move container down"; } ];
          }
          {
            name = "Move left";
            shortcut = {
              key = "Left";
              modifiers = "shift";
            };
            final = false;
            steps = [ { bash = "${i3Msg} move container left"; } ];
          }
          {
            name = "Move Right";
            shortcut = {
              key = "Right";
              modifiers = "shift";
            };
            final = false;
            steps = [ { bash = "${i3Msg} move container right"; } ];
          }
          {
            name = "Move up";
            shortcut = {
              key = "Up";
              modifiers = "shift";
            };
            final = false;
            steps = [ { bash = "${i3Msg} move container up"; } ];
          }

          ## Resize commands
          {
            name = "Shorten";
            shortcut = {
              key = "Down";
              modifiers = "control";
            };
            final = false;
            steps = [ { bash = "${i3Msg} resize shrink height"; } ];
          }
          {
            name = "Heighten";
            shortcut = {
              key = "Up";
              modifiers = "control";
            };
            final = false;
            steps = [ { bash = "${i3Msg} resize grow height"; } ];
          }
          {
            name = "Narrow";
            shortcut = {
              key = "Left";
              modifiers = "control";
            };
            final = false;
            steps = [ { bash = "${i3Msg} resize shrink width"; } ];
          }
          {
            name = "Widen";
            shortcut = {
              key = "Right";
              modifiers = "control";
            };
            final = false;
            steps = [ { bash = "${i3Msg} resize grow width"; } ];
          }
        ];

        layers = [
          {
            name = "Layout";
            shortcut = "l";
            commands = [
              {
                name = "Horizontal";
                shortcut = "h";
                steps = [ { bash = "${i3Msg} layout splith"; } ];
              }
              {
                name = "Stacking";
                shortcut = "s";
                steps = [ { bash = "${i3Msg} layout stacking"; } ];
              }
              {
                name = "Tabbed";
                shortcut = "t";
                steps = [ { bash = "${i3Msg} layout tabbed"; } ];
              }
              {
                name = "Vertical";
                shortcut = "v";
                steps = [ { bash = "${i3Msg} layout splitv"; } ];
              }
            ];
          }

          {
            name = "Open";
            shortcut = "o";
            commands = [
              {
                name = "Empty container";
                shortcut = "0";
                steps = [ { bash = "${i3Msg} open"; } ];
              }
              {
                name = "Horizontally";
                shortcut = "h";
                final = false;
                steps = [ { bash = "${i3Msg} split h"; } ];
              }
              {
                name = "Vertically";
                shortcut = "v";
                final = false;
                steps = [ { bash = "${i3Msg} split v"; } ];
              }
            ];
          }

          {
            name = "System";
            shortcut = "s";
            commands = [
              {
                name = "i3 restart";
                shortcut = "3";
                steps = [ { bash = "${i3Msg} restart"; } ];
              }
            ];
          }

          {
            name = "Window";
            shortcut = "i";
            commands = [
              {
                name = "Fullscreen toggle";
                shortcut = "f";
                steps = [ { bash = "${i3Msg} fullscreen toggle"; } ];
              }
              {
                name = "Hover toggle";
                shortcut = "h";
                steps = [ { bash = "${i3Msg} floating toggle"; } ];
              }
              {
                name = "Kill active";
                shortcut = "k";
                steps = [ { bash = "${i3Msg} kill"; } ];
              }
            ];
            layers = [
              {
                name = "Move";
                shortcut = "m";
                commands = [
                  {
                    name = "To context";
                    shortcut = "c";
                    steps = [ { bash = "${i3Msg} move container to workspace {0}{1}"; } ];
                    parameters = [
                      {
                        name = "Target context";
                        type = "character";
                      }
                      {
                        name = "Target workspace";
                        type = "character";
                      }
                    ];
                  }
                  {
                    name = "To workspace";
                    shortcut = "w";
                    steps = [
                      {
                        bash = ''
                          CONTEXT=$(${i3Msg} -t get_workspaces | jq -r '.[] | select(.focused) | .name[0:1]')
                          ${i3Msg} move container to workspace "$CONTEXT"{0}
                        '';
                      }
                    ];
                    parameters = [
                      {
                        name = "Target workspace";
                        type = "character";
                      }
                    ];
                  }
                ];
              }
            ];
          }
        ];
      };
    }
  ];
}
