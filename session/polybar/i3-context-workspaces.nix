{ pkgs, ... }:
let
  theme = import ../../theme/lib.nix { inherit pkgs; };
  cws = import ../i3/i3-contextual-workspaces.nix { inherit pkgs; };
  c = theme.color;

in
pkgs.writeShellApplication {
  name = "i3-context-workspaces";
  runtimeInputs = with pkgs; [
    i3
    jq
    coreutils
    cws.query
  ];
  text = ''
    i3msg="${pkgs.i3}/bin/i3-msg"
    bg="${c.background}"
    bg_upper="${c.backgroundUpper}"

    ${theme.stringToThemeColorBashFn}

    render() {
      local state active_context active_workspace context_color
      local -a contexts context_ws
      local output=""

      state=$(i3cws-query)
      active_context=$(echo "$state" | jq -r '.focused.context')
      active_workspace=$(echo "$state" | jq -r '.focused.workspace')
      if [ -z "$active_context" ] || [ "$active_context" = "null" ]; then
        echo ""
        return
      fi

      context_color=$(string_to_theme_color "$active_context")

      mapfile -t contexts < <(echo "$state" | jq -r '.contexts[].name')
      mapfile -t context_ws < <(echo "$state" | jq -r --arg c "$active_context" \
        '.contexts[] | select(.name == $c) | .workspaces[]')

      # Contexts section
      for ctx in "''${contexts[@]}"; do
        if [ "$ctx" = "$active_context" ]; then
          output+="%{B''${context_color}}%{F''${bg}} ''${ctx} %{F-}%{B-}"
        else
          output+="%{A1:${cws.switchToContext}/bin/i3cws-switch-to-context ''${ctx}:} ''${ctx} %{A}"
        fi
      done

      output+="  "

      # Workspaces section (within active context)
      for ws in "''${context_ws[@]}"; do
        if [ "$ws" = "$active_workspace" ]; then
          output+="%{u''${context_color}}%{+u}%{B''${bg_upper}} ''${ws} %{B-}%{-u}"
        else
          output+="%{A1:${cws.switchToWorkspace}/bin/i3cws-switch-to-workspace ''${ws}:} ''${ws} %{A}"
        fi
      done

      echo "$output"
    }

    render

    $i3msg -m -t subscribe '["workspace"]' | jq --unbuffered -r '.change' | while read -r _; do
      render
    done

    echo "%{F${c.negative}}workspaces unavailable%{F-}"
  '';
}
