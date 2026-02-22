{ pkgs, theme }:
let
  bin = {
    bluetoothctl = "${pkgs.bluez}/bin/bluetoothctl";
    brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
    cut = "${pkgs.coreutils}/bin/cut";
    date = "${pkgs.coreutils}/bin/date";
    dunstctl = "${pkgs.dunst}/bin/dunstctl";
    firefox = "${pkgs.firefox}/bin/firefox";
    gpick = "${pkgs.gpick}/bin/gpick";
    grep = "${pkgs.gnugrep}/bin/grep";
    i3 = "${pkgs.i3}/bin/i3";
    i3Msg = "${pkgs.i3}/bin/i3-msg";
    jq = "${pkgs.jq}/bin/jq";
    loginctl = "${pkgs.systemd}/bin/loginctl";
    nmcli = "${pkgs.networkmanager}/bin/nmcli";
    notifySend = "${pkgs.libnotify}/bin/notify-send";
    playerctl = "${pkgs.playerctl}/bin/playerctl";
    pwDump = "${pkgs.pipewire}/bin/pw-dump";
    rofi = "${pkgs.rofi}/bin/rofi";
    scrot = "${pkgs.scrot}/bin/scrot";
    setxkbmap = "${pkgs.xorg.setxkbmap}/bin/setxkbmap";
    systemctl = "${pkgs.systemd}/bin/systemctl";
    trans = "${pkgs.translate-shell}/bin/trans";
    wpctl = "${pkgs.wireplumber}/bin/wpctl";
    xclip = "${pkgs.xclip}/bin/xclip";
    xdotool = "${pkgs.xdotool}/bin/xdotool";
    xprop = "${pkgs.xorg.xprop}/bin/xprop";
    xrandr = "${pkgs.xorg.xrandr}/bin/xrandr";
    xsel = "${pkgs.xsel}/bin/xsel";
  };
in
{
  gui = {
    font_family = theme.font.monospace;
    font_size = 20;

    window_height = 360;
    window_width = 1280;

    # Normal
    background_color = theme.color.background;
    border_color = theme.color.border;
    foreground_color = theme.color.foreground;

    # Errors
    error_border_color = theme.color.negative;

    # Actions
    placeholder_color = theme.color.foregroundLower;
    action_branch_color = theme.color.accent;
    action_execute_color = theme.color.foreground;
    action_system_color = theme.color.foregroundLower;
  };

  shell = {
    default_timeout_ms = 3000;
  };

  core = {
    keys_activate = [
      "Super_L"
      "Super_R"
    ];
    keys_back = "BackSpace";
    keys_deactivate = [
      "Super_L"
      "Super_R"
      "Escape"
    ];

    commands = [
      {
        name = "Media";
        shortcut = "m";
        steps = "${bin.playerctl} --player {0} {1}";
        parameters = [
          {
            name = "Player name";
            type = "choose";
            generate_options.command = "${bin.playerctl} --list-all";
          }
          {
            name = "Control action";
            type = "choose";
            options = [
              "next"
              "play"
              "pause"
              "previous"
              "stop"
            ];
          }
        ];
      }

      {
        name = "Workspace";
        shortcut = "w";
        steps = "${bin.i3Msg} workspace '{0}'";
        parameters = [
          {
            name = "Workspace number";
            type = "character";
          }
        ];
      }

      ## Focus commands
      {
        name = "Focus down";
        shortcut = "Down";
        final = false;
        steps = "${bin.i3Msg} focus down";
      }
      {
        name = "Focus left";
        shortcut = "Left";
        final = false;
        steps = "${bin.i3Msg} focus left";
      }
      {
        name = "Focus right";
        shortcut = "Right";
        final = false;
        steps = "${bin.i3Msg} focus right";
      }
      {
        name = "Focus up";
        shortcut = "Up";
        final = false;
        steps = "${bin.i3Msg} focus up";
      }
      {
        name = "Focus parent";
        shortcut = "PageUp";
        final = false;
        steps = "${bin.i3Msg} focus parent";
      }
      {
        name = "Focus child";
        shortcut = "PageDown";
        final = false;
        steps = "${bin.i3Msg} focus child";
      }

      ## Move commands
      {
        name = "Move down";
        shortcut = {
          key = "Down";
          modifiers = "shift";
        };
        final = false;
        steps = "${bin.i3Msg} move container down";
      }
      {
        name = "Move left";
        shortcut = {
          key = "Left";
          modifiers = "shift";
        };
        final = false;
        steps = "${bin.i3Msg} move container left";
      }
      {
        name = "Move Right";
        shortcut = {
          key = "Right";
          modifiers = "shift";
        };
        final = false;
        steps = "${bin.i3Msg} move container right";
      }
      {
        name = "Move up";
        shortcut = {
          key = "Up";
          modifiers = "shift";
        };
        final = false;
        steps = "${bin.i3Msg} move container up";
      }

      ## Resize commands
      {
        name = "Shorten";
        shortcut = {
          key = "Down";
          modifiers = "control";
        };
        final = false;
        steps = "${bin.i3Msg} resize shrink height";
      }
      {
        name = "Heighten";
        shortcut = {
          key = "Up";
          modifiers = "control";
        };
        final = false;
        steps = "${bin.i3Msg} resize grow height";
      }
      {
        name = "Narrow";
        shortcut = {
          key = "Left";
          modifiers = "control";
        };
        final = false;
        steps = "${bin.i3Msg} resize shrink width";
      }
      {
        name = "Widen";
        shortcut = {
          key = "Right";
          modifiers = "control";
        };
        final = false;
        steps = "${bin.i3Msg} resize grow width";
      }
    ];

    layers = [
      ## Keymaps layer
      {
        name = "Keymaps";
        shortcut = "0";
        commands = [
          {
            name = "US Colemak";
            shortcut = "0";
            steps = "${bin.setxkbmap} us -variant colemak";
          }
          {
            name = "Greek Colemak";
            shortcut = "1";
            steps = "${bin.setxkbmap} gr -variant colemak";
          }
          {
            name = "Finnish Qwerty";
            shortcut = "2";
            steps = "${bin.setxkbmap} fi";
          }
        ];
      }

      ## Layout layer
      {
        name = "Layout";
        shortcut = "l";
        commands = [
          {
            name = "Horizontal";
            shortcut = "h";
            steps = "${bin.i3Msg} layout splith";
          }
          {
            name = "Stacking";
            shortcut = "s";
            steps = "${bin.i3Msg} layout stacking";
          }
          {
            name = "Tabbed";
            shortcut = "t";
            steps = "${bin.i3Msg} layout tabbed";
          }
          {
            name = "Vertical";
            shortcut = "v";
            steps = "${bin.i3Msg} layout splitv";
          }
        ];
      }

      ## Noise layer
      {
        name = "Noise";
        shortcut = "n";
        commands = [
          {
            name = "Play";
            shortcut = "p";
            steps = "~/applications/noisegen.sh play";
          }
          {
            name = "Stop";
            shortcut = "s";
            steps = "~/applications/noisegen.sh stop";
          }
        ];
      }

      ## Open layer
      {
        name = "Open";
        shortcut = "o";
        commands = [
          {
            name = "Application";
            shortcut = "a";
            steps = "${bin.rofi} -show drun -show-icons";
            synchronous = false;
          }
          {
            name = "Empty container";
            shortcut = "e";
            steps = "${bin.i3Msg} open";
          }
          {
            name = "Horizontally";
            shortcut = "h";
            final = false;
            steps = "${bin.i3Msg} split h";
          }
          {
            name = "Vertically";
            shortcut = "v";
            final = false;
            steps = "${bin.i3Msg} split v";
          }
        ];
      }

      ## Pomodoro layer
      {
        name = "Pomodoro";
        shortcut = "p";
        commands = [
          {
            name = "Begin";
            shortcut = "b";
            steps = "~/applications/pomodoro.sh begin 1800";
          }
          {
            name = "End";
            shortcut = "e";
            steps = "~/applications/pomodoro.sh end";
          }
        ];
      }

      ## Search layer
      {
        name = "Search";
        shortcut = "e";
        layers = [
          {
            name = "Nix";
            shortcut = "x";
            commands = [
              {
                name = "Options";
                shortcut = "o";
                steps = "${bin.firefox} --new-window 'https://search.nixos.org/options?query={0}'";
                synchronous = false;
                parameters = [
                  {
                    name = "Search term";
                    type = "text";
                  }
                ];
              }
              {
                name = "Packages";
                shortcut = "p";
                steps = "${bin.firefox} --new-window 'https://search.nixos.org/packages?query={0}'";
                synchronous = false;
                parameters = [
                  {
                    name = "Search term";
                    type = "text";
                  }
                ];
              }
            ];
          }
        ];
        commands = [
          {
            name = "Crates.io";
            shortcut = "c";
            steps = "${bin.firefox} --new-window 'https://crates.io/search?q={0}'";
            synchronous = false;
            parameters = [
              {
                name = "Search term";
                type = "text";
              }
            ];
          }
          {
            name = "Duck Duck Go";
            shortcut = "d";
            steps = "${bin.firefox} --new-window 'https://www.duckduckgo.com/{0}'";
            synchronous = false;
            parameters = [
              {
                name = "Search term";
                type = "text";
              }
            ];
          }
          {
            name = "Google";
            shortcut = "g";
            steps = "${bin.firefox} --new-window 'https://www.google.com/search?q={0}'";
            synchronous = false;
            parameters = [
              {
                name = "Search term";
                type = "text";
              }
            ];
          }
          {
            name = "Hoogle";
            shortcut = "h";
            steps = "${bin.firefox} --new-window 'https://hoogle.haskell.org/?hoogle={0}'";
            synchronous = false;
            parameters = [
              {
                name = "Search term";
                type = "text";
              }
            ];
          }
          {
            name = "Kagi";
            shortcut = "k";
            steps = "${bin.firefox} --new-window 'https://kagi.com/search?q={0}'";
            synchronous = false;
            parameters = [
              {
                name = "Search term";
                type = "text";
              }
            ];
          }
          {
            name = "Merriam-Webster";
            shortcut = "m";
            steps = "${bin.firefox} --new-window 'https://merriam-webster.com/dictionary/{0}'";
            synchronous = false;
            parameters = [
              {
                name = "Word to look up";
                type = "text";
              }
            ];
          }
          {
            name = "Npm";
            shortcut = "n";
            steps = "${bin.firefox} --new-window 'https://npmjs.com/search?q={0}'";
            synchronous = false;
            parameters = [
              {
                name = "Search term";
                type = "text";
              }
            ];
          }
          {
            name = "Reddit";
            shortcut = "r";
            steps = "${bin.firefox} --new-window 'https://www.reddit.com/search/?q={0}'";
            synchronous = false;
            parameters = [
              {
                name = "Search term";
                type = "text";
              }
            ];
          }
          {
            name = "Youtube";
            shortcut = "y";
            steps = "${bin.firefox} --new-window 'https://www.youtube.com/results?search_query={0}'";
            synchronous = false;
            parameters = [
              {
                name = "Search term";
                type = "text";
              }
            ];
          }
        ];
      }

      ## System layer
      {
        name = "System";
        shortcut = "s";
        commands = [
          {
            name = "i3 restart";
            shortcut = "3";
            steps = "${bin.i3} restart";
          }
        ];
        layers = [
          {
            name = "Audio";
            shortcut = "a";
            commands = [
              {
                name = "Select sink";
                shortcut = "s";
                steps = ''
                  SINK_ID=$(${bin.pwDump} | ${bin.jq} -r '.[] | select(.info.props."node.name"=="{0}") | .id')
                  ${bin.wpctl} set-default $SINK_ID
                '';
                parameters = [
                  {
                    name = "Name";
                    type = "choose";
                    generate_options.command = ''
                      ${bin.pwDump} | ${bin.jq} -r '.[] | select(.info.props."media.class"=="Audio/Sink") | .info.props."node.name"'
                    '';
                  }
                ];
              }
              {
                name = "Volume down";
                shortcut = "d";
                final = false;
                steps = "${bin.wpctl} set-volume --limit 1.0 @DEFAULT_AUDIO_SINK@ 1%-";
              }
              {
                name = "Mute";
                shortcut = "m";
                steps = "${bin.wpctl} set-mute @DEFAULT_AUDIO_SINK@ 1";
              }
              {
                name = "Unmute";
                shortcut = "n";
                steps = "${bin.wpctl} set-mute @DEFAULT_AUDIO_SINK@ 0";
              }
              {
                name = "Volume up";
                shortcut = "u";
                final = false;
                steps = "${bin.wpctl} set-volume --limit 1.0 @DEFAULT_AUDIO_SINK@ 1%+";
              }
            ];
          }

          {
            name = "Monitor";
            shortcut = "m";
            layers = [
              {
                name = "Backlight";
                shortcut = "b";
                commands = [
                  {
                    name = "Down";
                    shortcut = "d";
                    steps = "${bin.brightnessctl} --exponent set 3%-";
                    final = false;
                  }
                  {
                    name = "Up";
                    shortcut = "u";
                    steps = "${bin.brightnessctl} --exponent set 3%+";
                    final = false;
                  }
                ];
              }
            ];
            commands = [
              {
                name = "Rotate";
                shortcut = "r";
                parameters = [
                  {
                    name = "Monitor name";
                    type = "choose";
                    generate_options.command = ''
                      ${bin.xrandr} | ${bin.grep} " connected " | ${bin.cut} -d ' ' -f 1
                    '';
                  }
                  {
                    name = "Direction";
                    type = "choose";
                    options = [
                      "left"
                      "right"
                      "normal"
                      "inverted"
                    ];
                  }
                ];
                steps = "${bin.xrandr} --output {0} --rotate {1}";
              }
            ];
          }

          {
            name = "Bluetooth";
            shortcut = "b";
            commands = [
              {
                name = "On";
                shortcut = "1";
                steps = "${bin.bluetoothctl} power on && ${bin.notifySend} \"Bluetooth\" \"Powered ON\"";
              }
              {
                name = "Off";
                shortcut = "0";
                steps = "${bin.bluetoothctl} power off && ${bin.notifySend} \"Bluetooth\" \"Powered OFF\"";
              }
              {
                name = "Connect";
                shortcut = "c";
                steps = ''
                  MAC=$(echo "{0}" | ${bin.cut} -d ' ' -f 1)
                  NAME=$(echo "{0}" | ${bin.cut} -d ' ' -f 2-)
                  if ${bin.bluetoothctl} show | ${bin.grep} -q "Powered: yes"; then
                    ${bin.bluetoothctl} connect $MAC && ${bin.notifySend} "Bluetooth" "Connected to $NAME"
                  else
                    ${bin.notifySend} "Bluetooth" "Error: Bluetooth is powered OFF"
                    exit 1
                  fi
                '';
                parameters = [
                  {
                    name = "Device";
                    type = "choose";
                    generate_options.command = "${bin.bluetoothctl} devices | ${bin.cut} -d ' ' -f 2-";
                  }
                ];
              }
              {
                name = "Disconnect";
                shortcut = "d";
                steps = ''
                  MAC=$(echo "{0}" | ${bin.cut} -d ' ' -f 1)
                  NAME=$(echo "{0}" | ${bin.cut} -d ' ' -f 2-)
                  ${bin.bluetoothctl} disconnect $MAC && ${bin.notifySend} "Bluetooth" "Disconnected from $NAME"
                '';
                parameters = [
                  {
                    name = "Device";
                    type = "choose";
                    generate_options.command = "${bin.bluetoothctl} devices Connected | ${bin.cut} -d ' ' -f 2-";
                  }
                ];
              }
            ];
          }

          {
            name = "Network";
            shortcut = "n";
            commands = [
              {
                name = "Connect";
                shortcut = "c";
                steps = "${bin.nmcli} connection up {0}";
                timeout = 5000;
                parameters = [
                  {
                    name = "Connection";
                    type = "choose";
                    generate_options.command = ''
                      ${bin.nmcli} -t -f name,type connection show | ${bin.grep} -E "wireless|ethernet" | ${bin.cut} -d ':' -f 1
                    '';
                  }
                ];
              }
            ];
          }

          {
            name = "Notification";
            shortcut = "o";
            commands = [
              {
                name = "Act";
                shortcut = "a";
                steps = "${bin.dunstctl} action";
              }
              {
                name = "Close";
                shortcut = "c";
                steps = "${bin.dunstctl} close";
              }
              {
                name = "Close all";
                shortcut = {
                  key = "c";
                  modifiers = "control";
                };
                steps = "${bin.dunstctl} close-all";
              }
              {
                name = "History pop";
                shortcut = "h";
                steps = "${bin.dunstctl} history-pop";
              }
            ];
          }

          {
            name = "Session";
            shortcut = "s";
            commands = [
              {
                name = "Lock";
                shortcut = "l";
                steps = "${bin.loginctl} lock-session";
              }
              {
                name = "Power off";
                shortcut = "p";
                steps = "${bin.systemctl} poweroff";
              }
              {
                name = "Reboot";
                shortcut = "r";
                steps = "${bin.systemctl} reboot";
              }
              {
                name = "Suspend";
                shortcut = "s";
                steps = "${bin.systemctl} suspend";
              }
              {
                name = "Terminate";
                shortcut = "t";
                steps = "${bin.loginctl} terminate-user \"\"";
              }
            ];
          }
        ];
      }

      {
        name = "Tool";
        shortcut = "t";
        layers = [
          {
            name = "Take note";
            shortcut = "n";
            commands = [
              {
                name = "Manual";
                shortcut = "m";
                steps = ''
                  TIMESTAMP=$(${bin.date} '+%Y-%m-%d %H:%M:%S')
                  echo "$TIMESTAMP [MANUAL] {0}" >> ~/notes.txt
                  ${bin.notifySend} "Note saved" "{0}"
                '';
                parameters = [
                  {
                    name = "Note";
                    type = "text";
                  }
                ];
              }
              {
                name = "Selection";
                shortcut = "s";
                steps = ''
                  TIMESTAMP=$(${bin.date} '+%Y-%m-%d %H:%M:%S')
                  SELECTION=$(${bin.xsel} -o)
                  echo "$TIMESTAMP [SELECTION] $SELECTION" >> ~/notes.txt
                  ${bin.notifySend} "Note saved from selection" "$SELECTION"
                '';
              }
            ];
          }

          {
            name = "Translate";
            shortcut = "t";
            commands = [
              {
                name = "Manual";
                shortcut = "m";
                steps = ''
                  TRANSLATION=$(${bin.trans} -brief {0}:{1} '{2}')
                  ${bin.notifySend} "{0} -> {1}" "$TRANSLATION"
                '';
                parameters = [
                  {
                    name = "From";
                    type = "choose";
                    options = [
                      "de"
                      "en"
                      "fi"
                      "fr"
                      "it"
                      "nl"
                    ];
                  }
                  {
                    name = "Into";
                    type = "choose";
                    options = [
                      "de"
                      "en"
                      "fi"
                      "fr"
                      "it"
                      "nl"
                    ];
                  }
                  {
                    name = "Text to translate";
                    type = "text";
                  }
                ];
              }
              {
                name = "Selection to English";
                shortcut = "s";
                steps = ''
                  SELECTION=$(${bin.xsel} -o)
                  TRANSLATION=$(${bin.trans} -brief :en "$SELECTION")
                  ${bin.notifySend} "Translated to English" "$TRANSLATION"
                '';
              }
            ];
          }

          {
            name = "Capture";
            shortcut = "c";
            commands = [
              {
                name = "Color";
                shortcut = "c";
                steps = ''
                  COLOR=$(${bin.gpick} --single --output --converter-name color_{0})
                  echo -n "$COLOR" | ${bin.xsel} -ib
                  ${bin.notifySend} "Color captured" "$COLOR"
                '';
                synchronous = false;
                parameters = [
                  {
                    name = "Converter";
                    type = "choose";
                    options = [
                      "css_hsl"
                      "css_rgb"
                      "web_hex"
                    ];
                  }
                ];
              }
              {
                name = "Region";
                shortcut = "r";
                steps = "${bin.scrot} --select --line mode=edge,width=4 - | ${bin.xclip} -selection c -t image/png";
                synchronous = false;
              }
              {
                name = "Window";
                shortcut = "i";
                steps = "${bin.scrot} --focused --line mode=edge,width=4 - | ${bin.xclip} -selection c -t image/png";
                synchronous = false;
              }
              {
                name = "Workspace";
                shortcut = "w";
                steps = "${bin.scrot} --line mode=edge,width=4 - | ${bin.xclip} -selection c -t image/png";
                synchronous = false;
              }
            ];
          }
        ];
      }

      {
        name = "Window";
        shortcut = "i";
        layers = [
          {
            name = "Inspect";
            shortcut = "i";
            commands = [
              {
                name = "Class";
                shortcut = "c";
                steps = ''
                  VAL=$(${bin.xprop} -id $(${bin.xdotool} getactivewindow) WM_CLASS | ${bin.cut} -d '"' -f 4)
                  echo -n "$VAL" | ${bin.xsel} -ib
                  ${bin.notifySend} "Window Class" "$VAL"
                '';
              }
              {
                name = "Title";
                shortcut = "t";
                steps = ''
                  VAL=$(${bin.xdotool} getactivewindow getwindowname)
                  echo -n "$VAL" | ${bin.xsel} -ib
                  ${bin.notifySend} "Window Title" "$VAL"
                '';
              }
              {
                name = "PID";
                shortcut = "p";
                steps = ''
                  VAL=$(${bin.xprop} -id $(${bin.xdotool} getactivewindow) _NET_WM_PID | ${bin.cut} -d ' ' -f 3)
                  echo -n "$VAL" | ${bin.xsel} -ib
                  ${bin.notifySend} "Window PID" "$VAL"
                '';
              }
            ];
          }
        ];
        commands = [
          {
            name = "Fullscreen toggle";
            shortcut = "f";
            steps = "${bin.i3Msg} fullscreen toggle";
          }
          {
            name = "Hover toggle";
            shortcut = "h";
            steps = "${bin.i3Msg} floating toggle";
          }
          {
            name = "Kill active";
            shortcut = "k";
            steps = "${bin.i3Msg} kill";
          }
          {
            name = "Move to workspace";
            shortcut = "m";
            steps = "${bin.i3Msg} move container to workspace {0}";
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
  };
}
