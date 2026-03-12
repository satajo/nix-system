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

  usageCacheDir = "\${XDG_CACHE_HOME:-$HOME/.cache}/claude";
  usageCache = "${usageCacheDir}/usage.json";
  usageCacheMaxAgeSeconds = 60;

  statusline = pkgs.writeShellScript "claude-statusline" ''
    INPUT=$(cat)

    IFS=$'\t' read -r MODEL CWD INPUT_TOKENS OUTPUT_TOKENS COST < <(
      echo "$INPUT" | ${pkgs.jq}/bin/jq -r '[
        (.model.display_name // "?"),
        (.cwd // ""),
        (.context_window.total_input_tokens // 0 | tostring),
        (.context_window.total_output_tokens // 0 | tostring),
        (.cost.total_cost_usd // 0 | tostring)
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

    # Fetch subscription usage with cached response
    USAGE_5H="?"
    CACHE_DIR="${usageCacheDir}"
    CACHE="${usageCache}"
    CACHE_MAX_AGE=${toString usageCacheMaxAgeSeconds}
    CREDS_FILE="$HOME/.claude/.credentials.json"

    NEED_REFRESH=1
    if [ -f "$CACHE" ]; then
      CACHE_AGE=$(( $(date +%s) - $(stat -c %Y "$CACHE") ))
      if [ "$CACHE_AGE" -lt "$CACHE_MAX_AGE" ]; then
        NEED_REFRESH=0
      fi
    fi

    if [ "$NEED_REFRESH" -eq 1 ] && [ -f "$CREDS_FILE" ]; then
      mkdir -p "$CACHE_DIR"
      (
        TOKEN=$(${pkgs.jq}/bin/jq -r '.claudeAiOauth.accessToken // empty' "$CREDS_FILE")
        if [ -n "$TOKEN" ]; then
          RESPONSE=$(${pkgs.curl}/bin/curl -s --max-time 3 \
            -H "Authorization: Bearer $TOKEN" \
            -H "anthropic-beta: oauth-2025-04-20" \
            -H "Content-Type: application/json" \
            "https://api.anthropic.com/api/oauth/usage" 2>/dev/null)
          if echo "$RESPONSE" | ${pkgs.jq}/bin/jq -e '.five_hour' >/dev/null 2>&1; then
            echo "$RESPONSE" > "$CACHE.tmp" && mv "$CACHE.tmp" "$CACHE"
          fi
        fi
      ) &
    fi

    if [ -f "$CACHE" ]; then
      USAGE_5H=$(${pkgs.jq}/bin/jq -r '.five_hour.utilization // "?"' "$CACHE")
      if [ "$USAGE_5H" != "?" ]; then
        USAGE_5H=$(${pkgs.gawk}/bin/awk "BEGIN { printf \"%.0f%%\", $USAGE_5H }")
      fi
    fi

    BLUE='\033[34m'
    RED='\033[31m'
    PURPLE='\033[35m'
    YELLOW='\033[33m'
    GREEN='\033[32m'
    RESET='\033[0m'

    echo -e "''${BLUE}model:''${RESET} $MODEL  ''${RED}branch:''${RESET} $BRANCH  ''${PURPLE}tokens:''${RESET} $TOKENS_FMT  ''${YELLOW}cost:''${RESET} $COST_FMT  ''${GREEN}quota:''${RESET} $USAGE_5H"
  '';

  settings = builtins.toJSON {
    skipDangerousModePermissionPrompt = true;
    attribution = {
      commit = "";
      pr = "";
    };
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
      pkgs.sox
    ];
    home.file.".claude/settings.json".text = settings;
  };
}
