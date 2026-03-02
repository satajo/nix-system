{ pkgs, ... }:
let
  theme = import ../../theme/lib.nix { inherit pkgs; };
  c = theme.color;

in
pkgs.writeShellApplication {
  name = "i3-context-workspaces";
  runtimeInputs = with pkgs; [
    i3
    jq
    coreutils
  ];
  text = ''
    i3msg="${pkgs.i3}/bin/i3-msg"
    bg="${c.background}"
    bg_upper="${c.backgroundUpper}"

    ${theme.stringToThemeColorBashFn}

    render() {
      local workspaces_json focused active_context active_workspace context_color
      local -a contexts context_ws
      local output=""

      workspaces_json=$($i3msg -t get_workspaces)
      focused=$(echo "$workspaces_json" | jq -r '.[] | select(.focused) | .name')
      if [ -z "$focused" ]; then
        echo ""
        return
      fi

      active_context="''${focused:0:1}"
      active_workspace="''${focused:1}"
      context_color=$(string_to_theme_color "$active_context")

      # Collect unique sorted contexts
      mapfile -t contexts < <(echo "$workspaces_json" | jq -r '.[].name' | cut -c1 | sort -u)

      # Collect workspaces in active context (second char onwards, sorted)
      mapfile -t context_ws < <(echo "$workspaces_json" | jq -r --arg c "$active_context" \
        '.[] | select(.name | startswith($c)) | .name' | sort | while read -r name; do echo "''${name:1}"; done)

      # Contexts section
      for ctx in "''${contexts[@]}"; do
        if [ "$ctx" = "$active_context" ]; then
          output+="%{B''${context_color}}%{F''${bg}} ''${ctx} %{F-}%{B-}"
        else
          output+="%{A1:$i3msg workspace ''${ctx}''${active_workspace}:} ''${ctx} %{A}"
        fi
      done

      output+="  "

      # Workspaces section (within active context)
      for ws in "''${context_ws[@]}"; do
        if [ "$ws" = "$active_workspace" ]; then
          output+="%{u''${context_color}}%{+u}%{B''${bg_upper}} ''${ws} %{B-}%{-u}"
        else
          output+="%{A1:$i3msg workspace ''${active_context}''${ws}:} ''${ws} %{A}"
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
