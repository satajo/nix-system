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

    # Fetch 5-hour usage quota from Anthropic API, shared across all Claude sessions.
    # Uses flock to ensure only one session refreshes at a time, preventing request storms.
    USAGE_5H="?"
    CACHE_DIR="${usageCacheDir}"
    CACHE="${usageCache}"
    CACHE_MAX_AGE=${toString usageCacheMaxAgeSeconds}
    CREDS_FILE="$HOME/.claude/.credentials.json"

    # -s (not -f): the lock below creates an empty file, which we must not treat as valid cache
    NEED_REFRESH=1
    if [ -s "$CACHE" ]; then
      CACHE_AGE=$(( $(date +%s) - $(stat -c %Y "$CACHE") ))
      if [ "$CACHE_AGE" -lt "$CACHE_MAX_AGE" ]; then
        NEED_REFRESH=0
      fi
    fi

    if [ "$NEED_REFRESH" -eq 1 ] && [ -f "$CREDS_FILE" ]; then
      mkdir -p "$CACHE_DIR"
      (
        # Non-blocking lock: if another session is already refreshing, skip
        ${pkgs.util-linux}/bin/flock -n 9 || exit 0
        # Re-check freshness: another session may have refreshed while we waited for the lock
        if [ -s "$CACHE" ]; then
          CACHE_AGE=$(( $(date +%s) - $(stat -c %Y "$CACHE") ))
          [ "$CACHE_AGE" -lt "$CACHE_MAX_AGE" ] && exit 0
        fi

        TOKEN=$(${pkgs.jq}/bin/jq -r '.claudeAiOauth.accessToken // empty' "$CREDS_FILE")
        [ -z "$TOKEN" ] && exit 0

        RESPONSE=$(${pkgs.curl}/bin/curl -s --max-time 10 \
          -H "Authorization: Bearer $TOKEN" \
          -H "anthropic-beta: oauth-2025-04-20" \
          -H "Content-Type: application/json" \
          "https://api.anthropic.com/api/oauth/usage" 2>/dev/null)

        # On success, atomically swap in the new data (readers are outside the lock)
        if echo "$RESPONSE" | ${pkgs.jq}/bin/jq -e '.five_hour' >/dev/null 2>&1; then
          echo "$RESPONSE" > "$CACHE.tmp" && mv "$CACHE.tmp" "$CACHE"
          exit 0
        fi

        # Fetch failed — backoff by bumping mtime so we don't retry for CACHE_MAX_AGE seconds.
        # If cache has old valid data, keep it visible; otherwise write empty object for -s check.
        [ -s "$CACHE" ] && touch "$CACHE" || { echo '{}' > "$CACHE.tmp" && mv "$CACHE.tmp" "$CACHE"; }
      ) 9>>"$CACHE" &  # Lock on the cache file itself; >> avoids truncating existing data
    fi

    if [ -s "$CACHE" ]; then
      USAGE_5H=$(${pkgs.jq}/bin/jq -r '.five_hour.utilization // empty' "$CACHE" 2>/dev/null)
      if [ -n "$USAGE_5H" ]; then
        USAGE_5H=$(${pkgs.gawk}/bin/awk "BEGIN { printf \"%.0f%%\", $USAGE_5H }")
      else
        USAGE_5H="?"
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
