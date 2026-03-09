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

    MODEL=$(echo "$INPUT" | ${pkgs.jq}/bin/jq -r '.model.display_name // "?"')
    CWD=$(echo "$INPUT" | ${pkgs.jq}/bin/jq -r '.cwd // empty')
    INPUT_TOKENS=$(echo "$INPUT" | ${pkgs.jq}/bin/jq -r '.context_window.total_input_tokens // 0')
    OUTPUT_TOKENS=$(echo "$INPUT" | ${pkgs.jq}/bin/jq -r '.context_window.total_output_tokens // 0')
    COST=$(echo "$INPUT" | ${pkgs.jq}/bin/jq -r '.cost.total_cost_usd // 0')

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

    BLUE='\033[38;2;23;172;242m'
    RED='\033[38;2;230;73;90m'
    PURPLE='\033[38;2;195;133;254m'
    YELLOW='\033[38;2;232;157;55m'
    RESET='\033[0m'

    echo -e "''${BLUE}model:''${RESET} $MODEL  ''${RED}branch:''${RESET} $BRANCH  ''${PURPLE}tokens:''${RESET} $TOKENS_FMT  ''${YELLOW}cost:''${RESET} $COST_FMT"
  '';

  settings = builtins.toJSON {
    skipDangerousModePermissionPrompt = true;
    enabledPlugins = {
      "rust-analyzer-lsp@claude-plugins-official" = true;
      "superpowers@claude-plugins-official" = true;
      "claude-md-management@claude-plugins-official" = true;
    };
    statusLine = {
      type = "command";
      command = toString statusline;
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
  };

  claude-wrapped = pkgs.writeShellScriptBin "claude" ''
    exec ${claude-code}/bin/claude --allow-dangerously-skip-permissions "$@"
  '';
in
{
  home-manager.users.satajo = {
    home.packages = [
      claude-wrapped
    ];
    home.file.".claude/settings.json".text = settings;
  };
}
