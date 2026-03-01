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
        steps = [ { bash = "${bin.playerctl} --player {0} {1}"; } ];
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
            steps = [ { bash = "${bin.setxkbmap} us -variant colemak"; } ];
          }
          {
            name = "Greek Colemak";
            shortcut = "1";
            steps = [ { bash = "${bin.setxkbmap} gr -variant colemak"; } ];
          }
          {
            name = "Finnish Qwerty";
            shortcut = "2";
            steps = [ { bash = "${bin.setxkbmap} fi"; } ];
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
            steps = [ { bash = "${bin.rofi} -show drun -show-icons"; } ];
            synchronous = false;
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
                steps = [ { bash = "${bin.firefox} --new-window 'https://search.nixos.org/options?query={0}'"; } ];
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
                steps = [ { bash = "${bin.firefox} --new-window 'https://search.nixos.org/packages?query={0}'"; } ];
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
            steps = [ { bash = "${bin.firefox} --new-window 'https://crates.io/search?q={0}'"; } ];
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
            steps = [ { bash = "${bin.firefox} --new-window 'https://www.duckduckgo.com/{0}'"; } ];
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
            steps = [ { bash = "${bin.firefox} --new-window 'https://www.google.com/search?q={0}'"; } ];
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
            steps = [ { bash = "${bin.firefox} --new-window 'https://hoogle.haskell.org/?hoogle={0}'"; } ];
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
            steps = [ { bash = "${bin.firefox} --new-window 'https://kagi.com/search?q={0}'"; } ];
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
            steps = [ { bash = "${bin.firefox} --new-window 'https://merriam-webster.com/dictionary/{0}'"; } ];
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
            steps = [ { bash = "${bin.firefox} --new-window 'https://npmjs.com/search?q={0}'"; } ];
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
            steps = [ { bash = "${bin.firefox} --new-window 'https://www.reddit.com/search/?q={0}'"; } ];
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
            steps = [
              { bash = "${bin.firefox} --new-window 'https://www.youtube.com/results?search_query={0}'"; }
            ];
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
        layers = [
          {
            name = "Audio";
            shortcut = "a";
            commands = [
              {
                name = "Select sink";
                shortcut = "s";
                steps = [
                  {
                    bash = ''
                      SINK_ID=$(${bin.pwDump} | ${bin.jq} -r '.[] | select(.info.props."node.name"=="{0}") | .id')
                      ${bin.wpctl} set-default $SINK_ID
                    '';
                  }
                ];
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
                steps = [ { bash = "${bin.wpctl} set-volume --limit 1.0 @DEFAULT_AUDIO_SINK@ 1%-"; } ];
              }
              {
                name = "Mute";
                shortcut = "m";
                steps = [ { bash = "${bin.wpctl} set-mute @DEFAULT_AUDIO_SINK@ 1"; } ];
              }
              {
                name = "Unmute";
                shortcut = "n";
                steps = [ { bash = "${bin.wpctl} set-mute @DEFAULT_AUDIO_SINK@ 0"; } ];
              }
              {
                name = "Volume up";
                shortcut = "u";
                final = false;
                steps = [ { bash = "${bin.wpctl} set-volume --limit 1.0 @DEFAULT_AUDIO_SINK@ 1%+"; } ];
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
                    steps = [ { bash = "${bin.brightnessctl} --exponent set 3%-"; } ];
                    final = false;
                  }
                  {
                    name = "Up";
                    shortcut = "u";
                    steps = [ { bash = "${bin.brightnessctl} --exponent set 3%+"; } ];
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
                steps = [ { bash = "${bin.xrandr} --output {0} --rotate {1}"; } ];
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
                steps = [
                  { bash = "${bin.bluetoothctl} power on && ${bin.notifySend} \"Bluetooth\" \"Powered ON\""; }
                ];
              }
              {
                name = "Off";
                shortcut = "0";
                steps = [
                  { bash = "${bin.bluetoothctl} power off && ${bin.notifySend} \"Bluetooth\" \"Powered OFF\""; }
                ];
              }
              {
                name = "Connect";
                shortcut = "c";
                steps = [
                  {
                    bash = ''
                      MAC=$(echo "{0}" | ${bin.cut} -d ' ' -f 1)
                      NAME=$(echo "{0}" | ${bin.cut} -d ' ' -f 2-)
                      if ${bin.bluetoothctl} show | ${bin.grep} -q "Powered: yes"; then
                        ${bin.bluetoothctl} connect $MAC && ${bin.notifySend} "Bluetooth" "Connected to $NAME"
                      else
                        ${bin.notifySend} "Bluetooth" "Error: Bluetooth is powered OFF"
                        exit 1
                      fi
                    '';
                  }
                ];
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
                steps = [
                  {
                    bash = ''
                      MAC=$(echo "{0}" | ${bin.cut} -d ' ' -f 1)
                      NAME=$(echo "{0}" | ${bin.cut} -d ' ' -f 2-)
                      ${bin.bluetoothctl} disconnect $MAC && ${bin.notifySend} "Bluetooth" "Disconnected from $NAME"
                    '';
                  }
                ];
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
                steps = [ { bash = "${bin.nmcli} connection up {0}"; } ];
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
                steps = [ { bash = "${bin.dunstctl} action"; } ];
              }
              {
                name = "Close";
                shortcut = "c";
                steps = [ { bash = "${bin.dunstctl} close"; } ];
              }
              {
                name = "Close all";
                shortcut = {
                  key = "c";
                  modifiers = "control";
                };
                steps = [ { bash = "${bin.dunstctl} close-all"; } ];
              }
              {
                name = "History pop";
                shortcut = "h";
                steps = [ { bash = "${bin.dunstctl} history-pop"; } ];
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
                steps = [ { bash = "${bin.loginctl} lock-session"; } ];
              }
              {
                name = "Power off";
                shortcut = "p";
                steps = [ { bash = "${bin.systemctl} poweroff"; } ];
              }
              {
                name = "Reboot";
                shortcut = "r";
                steps = [ { bash = "${bin.systemctl} reboot"; } ];
              }
              {
                name = "Suspend";
                shortcut = "s";
                steps = [ { bash = "${bin.systemctl} suspend"; } ];
              }
              {
                name = "Terminate";
                shortcut = "t";
                steps = [ { bash = "${bin.loginctl} terminate-user \"\""; } ];
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
                steps = [
                  {
                    bash = ''
                      TIMESTAMP=$(${bin.date} '+%Y-%m-%d %H:%M:%S')
                      echo "$TIMESTAMP [MANUAL] {0}" >> ~/notes.txt
                      ${bin.notifySend} "Note saved" "{0}"
                    '';
                  }
                ];
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
                steps = [
                  {
                    bash = ''
                      TIMESTAMP=$(${bin.date} '+%Y-%m-%d %H:%M:%S')
                      SELECTION=$(${bin.xsel} -o)
                      echo "$TIMESTAMP [SELECTION] $SELECTION" >> ~/notes.txt
                      ${bin.notifySend} "Note saved from selection" "$SELECTION"
                    '';
                  }
                ];
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
                steps = [
                  {
                    bash = ''
                      TRANSLATION=$(${bin.trans} -brief {0}:{1} '{2}')
                      ${bin.notifySend} "{0} -> {1}" "$TRANSLATION"
                    '';
                  }
                ];
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
                steps = [
                  {
                    bash = ''
                      SELECTION=$(${bin.xsel} -o)
                      TRANSLATION=$(${bin.trans} -brief :en "$SELECTION")
                      ${bin.notifySend} "Translated to English" "$TRANSLATION"
                    '';
                  }
                ];
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
                steps = [
                  {
                    bash = ''
                      COLOR=$(${bin.gpick} --single --output --converter-name color_{0})
                      echo -n "$COLOR" | ${bin.xsel} -ib
                      ${bin.notifySend} "Color captured" "$COLOR"
                    '';
                  }
                ];
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
                steps = [
                  {
                    bash = "${bin.scrot} --select --line mode=edge,width=4 - | ${bin.xclip} -selection c -t image/png";
                  }
                ];
                synchronous = false;
              }
              {
                name = "Window";
                shortcut = "i";
                steps = [
                  {
                    bash = "${bin.scrot} --focused --line mode=edge,width=4 - | ${bin.xclip} -selection c -t image/png";
                  }
                ];
                synchronous = false;
              }
              {
                name = "Workspace";
                shortcut = "w";
                steps = [
                  { bash = "${bin.scrot} --line mode=edge,width=4 - | ${bin.xclip} -selection c -t image/png"; }
                ];
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
                steps = [
                  {
                    bash = ''
                      VAL=$(${bin.xprop} -id $(${bin.xdotool} getactivewindow) WM_CLASS | ${bin.cut} -d '"' -f 4)
                      echo -n "$VAL" | ${bin.xsel} -ib
                      ${bin.notifySend} "Window Class" "$VAL"
                    '';
                  }
                ];
              }
              {
                name = "Title";
                shortcut = "t";
                steps = [
                  {
                    bash = ''
                      VAL=$(${bin.xdotool} getactivewindow getwindowname)
                      echo -n "$VAL" | ${bin.xsel} -ib
                      ${bin.notifySend} "Window Title" "$VAL"
                    '';
                  }
                ];
              }
              {
                name = "PID";
                shortcut = "p";
                steps = [
                  {
                    bash = ''
                      VAL=$(${bin.xprop} -id $(${bin.xdotool} getactivewindow) _NET_WM_PID | ${bin.cut} -d ' ' -f 3)
                      echo -n "$VAL" | ${bin.xsel} -ib
                      ${bin.notifySend} "Window PID" "$VAL"
                    '';
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
