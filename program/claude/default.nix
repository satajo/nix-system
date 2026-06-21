{ pkgs, pkgs-unstable, ... }:
let
  claude-code = pkgs-unstable.claude-code;

  notify-hook = pkgs.writeShellScript "claude-notify" ''
    INPUT=$(cat)

    ACTIVE_WINDOW=$(${pkgs.xdotool}/bin/xdotool getactivewindow 2>/dev/null)
    if [ "$ACTIVE_WINDOW" = "$WINDOWID" ]; then
      exit 0
    fi

    PROJECT=$(echo "$INPUT" | ${pkgs.jq}/bin/jq -r '.cwd | split("/") | last')
    EVENT=$(echo "$INPUT" | ${pkgs.jq}/bin/jq -r '.hook_event_name')
    MESSAGE=$(echo "$INPUT" | ${pkgs.jq}/bin/jq -r '.message // empty')

    if [ "$EVENT" = "Notification" ] && [ -n "$MESSAGE" ]; then
      ${pkgs.libnotify}/bin/notify-send "Claude Code [$PROJECT]" "$MESSAGE"
    else
      ${pkgs.libnotify}/bin/notify-send "Claude Code [$PROJECT]" "Ready for input"
    fi
  '';

  statusline = pkgs.writeShellScript "claude-statusline" ''
    INPUT=$(cat)

    IFS=$'\t' read -r MODEL EFFORT CWD CONTEXT_TOKENS USAGE_5H RESET_5H < <(
      echo "$INPUT" | ${pkgs.jq}/bin/jq -r '[
        (.model.display_name // "?"),
        (.effort.level // "?"),
        (.cwd // ""),
        (.context_window.total_input_tokens // 0 | tostring),
        (.rate_limits.five_hour.used_percentage // empty | tostring),
        (.rate_limits.five_hour.resets_at // empty | tostring)
      ] | join("\t")')

    format_tokens() {
      local n=$1
      if [ "$n" -lt 1000 ]; then
        echo "$n"
      elif [ "$n" -lt 10000 ]; then
        ${pkgs.gawk}/bin/awk "BEGIN { printf \"%.2fk\", $n / 1000 }"
      elif [ "$n" -lt 100000 ]; then
        ${pkgs.gawk}/bin/awk "BEGIN { printf \"%.1fk\", $n / 1000 }"
      elif [ "$n" -lt 1000000 ]; then
        ${pkgs.gawk}/bin/awk "BEGIN { printf \"%.0fk\", $n / 1000 }"
      else
        ${pkgs.gawk}/bin/awk "BEGIN { printf \"%.1fM\", $n / 1000000 }"
      fi
    }

    CONTEXT_FMT=$(format_tokens "$CONTEXT_TOKENS")

    BRANCH=""
    if [ -n "$CWD" ] && [ -d "$CWD" ]; then
      BRANCH=$(${pkgs.git}/bin/git -C "$CWD" branch --show-current 2>/dev/null)
    fi
    BRANCH=''${BRANCH:-"?"}

    # The 5h quota window exposes only used_percentage and resets_at, so the
    # elapsed fraction is derived against the fixed 18000s (5h) window length.
    # Pairing used% with that elapsed clock% reveals spend pace: a used% running
    # ahead of the clock% means burning the quota faster than the window refills.
    if [ -n "$USAGE_5H" ] && [ -n "$RESET_5H" ]; then
      QUOTA=$(${pkgs.gawk}/bin/awk \
        -v used="$USAGE_5H" -v reset="$RESET_5H" -v now="$(${pkgs.coreutils}/bin/date +%s)" '
        BEGIN {
          window = 18000
          remaining = reset - now
          if (remaining < 0) remaining = 0
          if (remaining > window) remaining = window
          clock = (window - remaining) * 100 / window
          printf "%.0f%% / %.0f%%", used, clock
        }')
    elif [ -n "$USAGE_5H" ]; then
      QUOTA=$(${pkgs.gawk}/bin/awk "BEGIN { printf \"%.0f%%\", $USAGE_5H }")
    else
      QUOTA="?"
    fi

    BLUE='\033[34m'
    RED='\033[31m'
    PURPLE='\033[35m'
    YELLOW='\033[33m'
    GREEN='\033[32m'
    RESET='\033[0m'

    echo -e "''${BLUE}model:''${RESET} $MODEL  ''${YELLOW}effort:''${RESET} $EFFORT  ''${GREEN}quota:''${RESET} $QUOTA  ''${PURPLE}context:''${RESET} $CONTEXT_FMT  ''${RED}branch:''${RESET} $BRANCH"
  '';

  # Passed via --settings flag instead of home-manager's home.file because
  # Claude Code writes runtime state to the same settings.json, which requires
  # the file to be mutable.
  settings = builtins.toJSON {
    attribution = {
      commit = "";
      pr = "";
    };
    hooks = {
      Notification = [
        {
          matcher = "";
          hooks = [
            {
              type = "command";
              command = toString notify-hook;
            }
          ];
        }
      ];
      Stop = [
        {
          matcher = "";
          hooks = [
            {
              type = "command";
              command = toString notify-hook;
            }
          ];
        }
      ];
    };
    permissions = {
      defaultMode = "auto";
    };
    skipDangerousModePermissionPrompt = true;
    statusLine = {
      type = "command";
      command = toString statusline;
    };
    tui = "fullscreen";
    voice = {
      enabled = true;
    };
  };

  keybindings = builtins.toJSON {
    bindings = [
      {
        context = "Chat";
        bindings = {
          "\\" = "voice:pushToTalk";
        };
      }
    ];
  };

  claude-wrapped = pkgs.writeShellScriptBin "claude" ''
    exec ${claude-code}/bin/claude --settings '${settings}' "$@"
  '';
in
{
  home-manager.users.satajo = {
    home.packages = [
      claude-wrapped
      pkgs.sox
    ];

    home.file.".claude/keybindings.json".text = keybindings;
  };
}
