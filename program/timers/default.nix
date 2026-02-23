{ pkgs, ... }:
let
  timers = pkgs.writeShellScriptBin "timers" ''
    set -e

    COMMAND="$1"

    DIR_NAME=/tmp/timers

    function print_help {
      echo "Usage: $0 <command>"
      echo ""
      echo "  start <name> <duration>  Start a new timer"
      echo "  stop <name>              Stop a timer"
      echo "  get <name>               Get the elapsed time of a timer"
      echo "  list                     List all active timers"
      echo "  help                     Print this help message"
    }

    function print_error {
      echo "Error: $@" 1>&2
    }

    mkdir -p $DIR_NAME

    if [[ $COMMAND == "list" ]]; then
      for file in $DIR_NAME/*; do
        if [[ -f $file ]]; then
          basename "$file"
        fi
      done

    elif [[ $COMMAND == "get" ]]; then
      if [[ -z $2 ]]; then
        print_error "Timer name not provided"
        exit 1
      fi

      FILE_PATH="$DIR_NAME/$2"

      if [[ ! -f "$FILE_PATH" ]]; then
        exit 0
      fi

      END_TIME=$(cat "$FILE_PATH")
      CURRENT_TIME=$(${pkgs.coreutils}/bin/date +%s)
      TIME_REMAINING=$(( $END_TIME - $CURRENT_TIME ))

      format_time() {
        local secs=$1
        local mm_ss=$(${pkgs.coreutils}/bin/date -u -d @"$secs" +"%M:%S")
        if [[ $secs -ge 3600 ]]; then
          local hours=$(( secs / 3600 ))
          echo "$hours:$mm_ss"
        else
          echo "$mm_ss"
        fi
      }

      if [[ $TIME_REMAINING -ge 0 ]]; then
        echo "$(format_time $TIME_REMAINING)"
      else
        ELAPSED=$(( 0 - $TIME_REMAINING ))
        echo "-$(format_time $ELAPSED)"
      fi

    elif [[ $COMMAND == "start" ]]; then
      if [[ -z $2 ]]; then
        print_error "Timer name not provided"
        exit 1
      fi

      if [[ -z $3 ]]; then
        print_error "Timer duration not provided"
        exit 1
      fi

      RE='^[1-9][0-9]*$'
      if ! [[ $3 =~ $RE ]]; then
        print_error "Invalid timer duration: $3"
        exit 1
      fi

      CURRENT_TIME=$(${pkgs.coreutils}/bin/date +%s)
      END_TIME=$(( $CURRENT_TIME + $3 ))
      echo $END_TIME > "$DIR_NAME/$2"
      echo "Timer started: $2"

    elif [[ $COMMAND == "stop" ]]; then
      if [[ -z $2 ]]; then
        print_error "Timer name not provided"
        exit 1
      fi

      rm -f "$DIR_NAME/$2"
      echo "Timer stopped: $2"

    elif [[ $COMMAND == "help" ]]; then
      echo "Timers"
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
  home-manager.users.satajo.home.packages = [ timers ];

  longcut.fragments = [
    {
      core.layers = [
        {
          name = "Tool";
          layers = [
            {
              name = "Timers";
              shortcut = "i";
              commands = [
                {
                  name = "New timer";
                  shortcut = "n";
                  steps = "${timers}/bin/timers start '{0}' '{1}'";
                  parameters = [
                    {
                      name = "Name";
                      type = "text";
                    }
                    {
                      name = "Duration (seconds)";
                      type = "text";
                    }
                  ];
                }
                {
                  name = "Stop timer";
                  shortcut = "s";
                  steps = "${timers}/bin/timers stop '{0}'";
                  parameters = [
                    {
                      name = "Timer";
                      type = "choose";
                      generate_options.command = "${timers}/bin/timers list";
                    }
                  ];
                }
                {
                  name = "Start Pomodoro";
                  shortcut = "p";
                  steps = "${timers}/bin/timers start Pomodoro 1800";
                }
              ];
            }
          ];
        }
      ];
    }
  ];
}
