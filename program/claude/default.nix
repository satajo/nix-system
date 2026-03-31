{ inputs, pkgs, ... }:
let
  claude-code = inputs.claude-code.packages.x86_64-linux.default;

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

    IFS=$'\t' read -r MODEL CWD INPUT_TOKENS OUTPUT_TOKENS COST USAGE_5H < <(
      echo "$INPUT" | ${pkgs.jq}/bin/jq -r '[
        (.model.display_name // "?"),
        (.cwd // ""),
        (.context_window.total_input_tokens // 0 | tostring),
        (.context_window.total_output_tokens // 0 | tostring),
        (.cost.total_cost_usd // 0 | tostring),
        (.rate_limits.five_hour.used_percentage // empty | tostring)
      ] | join("\t")')

    TOTAL_TOKENS=$((INPUT_TOKENS + OUTPUT_TOKENS))

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

    TOKENS_FMT=$(format_tokens "$TOTAL_TOKENS")
    COST_FMT=$(${pkgs.gawk}/bin/awk "BEGIN { printf \"\\$%.2f\", $COST }")

    BRANCH=""
    if [ -n "$CWD" ] && [ -d "$CWD" ]; then
      BRANCH=$(${pkgs.git}/bin/git -C "$CWD" branch --show-current 2>/dev/null)
    fi
    BRANCH=''${BRANCH:-"?"}

    if [ -n "$USAGE_5H" ]; then
      USAGE_5H=$(${pkgs.gawk}/bin/awk "BEGIN { printf \"%.0f%%\", $USAGE_5H }")
    else
      USAGE_5H="?"
    fi

    BLUE='\033[34m'
    RED='\033[31m'
    PURPLE='\033[35m'
    YELLOW='\033[33m'
    GREEN='\033[32m'
    RESET='\033[0m'

    echo -e "''${BLUE}model:''${RESET} $MODEL  ''${RED}branch:''${RESET} $BRANCH  ''${PURPLE}tokens:''${RESET} $TOKENS_FMT  ''${YELLOW}cost:''${RESET} $COST_FMT  ''${GREEN}quota:''${RESET} $USAGE_5H"
  '';

  # Passed via --settings flag instead of home-manager's home.file because
  # Claude Code writes runtime state to the same settings.json, which requires
  # the file to be mutable.
  settings = builtins.toJSON {
    attribution = {
      commit = "";
      pr = "";
    };
    enabledPlugins = {
      "claude-md-management@claude-plugins-official" = true;
      "rust-analyzer-lsp@claude-plugins-official" = true;
      "superpowers@claude-plugins-official" = true;
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
    skipDangerousModePermissionPrompt = true;
    statusLine = {
      type = "command";
      command = toString statusline;
    };
    voiceEnabled = true;
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
    exec ${claude-code}/bin/claude --allow-dangerously-skip-permissions --settings '${settings}' "$@"
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
