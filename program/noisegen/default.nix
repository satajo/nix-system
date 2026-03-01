{
  config,
  lib,
  pkgs,
  ...
}:
let
  noisegen = pkgs.writeShellScriptBin "noisegen" ''
    set -e

    COMMAND=$1
    PROCESS_NAME="play"

    function stop_background_playback {
      if [[ $(${pkgs.procps}/bin/pgrep --exact $PROCESS_NAME) ]]; then
        echo "...existing playback detected"
        ${pkgs.procps}/bin/pkill --exact $PROCESS_NAME
        echo "...stopped existing playback"
      else
        echo "...no existing playback detected"
      fi
    }

    function begin_background_playback {
      echo "...beginning background playback"
      # Both IO streams are directed do null to avoid unnecessary output from a background job.
      1>/dev/null 2>/dev/null ${pkgs.sox}/bin/play --null --no-show-progress --channels 2 "$@" &
      echo "...playing in background"
    }

    function print_help {
      echo "Usage: $0 <command>"
      echo ""
      echo "  help Show this help"
      echo "  play Begin playback"
      echo "  stop Stop playback"
    }

    function print_error {
      echo "Error: $@" 1>&2;
    }

    if [[ $COMMAND == "play" ]]; then
      # Existing playback is stopped
      stop_background_playback
      # Starting the new synth
      begin_background_playback \
        synth brownnoise \
        bass 2 \
        treble -2 \
        reverb \
        tremolo 0.2 70 \
        vol 1
      echo "Playing"
      exit 0

    elif [[ $COMMAND == "stop" ]]; then
      stop_background_playback
      echo "Stopped"
      exit 0

    elif [[ $COMMAND == "help" ]]; then
      echo "NoiseGen - Happy buzz for focus and relaxation!"
      echo ""
      print_help

    elif [[ -z $COMMAND ]]; then
      print_error "Missing command parameter"
      echo ""
      echo "For more information, try $0 help"
      exit 1

    else
      print_error "Unknown command: $1"
      echo ""
      echo "For more information, try $0 help"
      exit 1
    fi
  '';
in
{
  home-manager.users.satajo = {
    home.packages = [ noisegen ];

    services.polybar.settings = {
      "module/noisegen" = {
        type = "custom/script";
        exec = "echo 󱑽 Noisegen";
        exec-if = "${pkgs.procps}/bin/pgrep -x play";
        interval = 5;
      };
    };
  };

  longcut.fragments = [
    {
      core.layers = [
        {
          name = "Noise";
          shortcut = "n";
          commands = [
            {
              name = "Play";
              shortcut = "p";
              steps = [ { bash = "${noisegen}/bin/noisegen play"; } ];
            }
            {
              name = "Stop";
              shortcut = "s";
              steps = [ { bash = "${noisegen}/bin/noisegen stop"; } ];
            }
          ];
        }
      ];
    }
  ];
}
