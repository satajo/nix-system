{ pkgs }:
let
  i3Msg = "${pkgs.i3}/bin/i3-msg";
  jq = "${pkgs.jq}/bin/jq";

  currentContext = "$(${i3Msg} -t get_workspaces | ${jq} -r '.[] | select(.focused) | .name | split(\":\") | .[0]')";

  query = pkgs.writeShellApplication {
    name = "i3cws-query";
    runtimeInputs = [
      pkgs.i3
      pkgs.jq
    ];
    text = ''
      i3-msg -t get_workspaces | jq '
        [.[] | {name: .name, focused: .focused,
                context: (.name | split(":") | .[0]),
                workspace: (.name | split(":") | .[1])}]
        | {
            focused: (map(select(.focused)) | first | {context, workspace}),
            contexts: group_by(.context)
              | map({name: .[0].context,
                     workspaces: [.[] | .workspace] | sort})
              | sort_by(.name)
          }
      '
    '';
  };

  watchFocus = pkgs.writeShellApplication {
    name = "i3cws-watch-focus";
    runtimeInputs = [
      pkgs.i3
      pkgs.jq
    ];
    text = ''
      i3-msg -t get_workspaces | jq -r '.[] | select(.focused) | .name | split(":") | "\(.[0]) \(.[1])"'

      i3-msg -m -t subscribe '["workspace"]' | jq --unbuffered -r '
        select(.change == "focus") | .current.name | split(":") | "\(.[0]) \(.[1])"
      '
    '';
  };

  rememberContextWorkspaceAssociation = pkgs.writeShellApplication {
    name = "i3cws-remember-context-workspace-association";
    runtimeInputs = with pkgs; [ coreutils ];
    text = ''
      context="$1"
      workspace="$2"
      if [ -z "$context" ] || [ -z "$workspace" ]; then
        exit 1
      fi

      dir="''${XDG_CACHE_HOME:-$HOME/.cache}/i3-context-workspaces"
      mkdir -p "$dir"
      echo -n "$workspace" > "$dir/$context"
    '';
  };

  switchToContext = pkgs.writeShellApplication {
    name = "i3cws-switch-to-context";
    runtimeInputs = [
      pkgs.i3
      pkgs.coreutils
    ];
    text = ''
      context="$1"
      if [ -z "$context" ]; then
        exit 1
      fi

      dir="''${XDG_CACHE_HOME:-$HOME/.cache}/i3-context-workspaces"
      state_file="$dir/$context"
      workspace=""
      if [ -f "$state_file" ]; then
        workspace=$(cat "$state_file")
      fi
      if [ -z "$workspace" ]; then
        workspace="0"
      fi

      i3-msg workspace "$context:$workspace"
    '';
  };

  switchToWorkspace = pkgs.writeShellApplication {
    name = "i3cws-switch-to-workspace";
    runtimeInputs = [
      pkgs.i3
      pkgs.jq
    ];
    text = ''
      workspace="$1"
      if [ -z "$workspace" ]; then
        exit 1
      fi

      context=${currentContext}
      i3-msg workspace "$context:$workspace"
    '';
  };

  moveToContext = pkgs.writeShellApplication {
    name = "i3cws-move-to-context";
    runtimeInputs = [ pkgs.i3 ];
    text = ''
      context="$1"
      if [ -z "$context" ]; then
        exit 1
      fi

      i3-msg move container to workspace "''${context}:0"
    '';
  };

  moveToWorkspace = pkgs.writeShellApplication {
    name = "i3cws-move-to-workspace";
    runtimeInputs = [
      pkgs.i3
      pkgs.jq
    ];
    text = ''
      workspace="$1"
      if [ -z "$workspace" ]; then
        exit 1
      fi

      context=${currentContext}
      i3-msg move container to workspace "$context:$workspace"
    '';
  };

in
{
  inherit
    query
    watchFocus
    rememberContextWorkspaceAssociation
    switchToContext
    switchToWorkspace
    moveToContext
    moveToWorkspace
    ;
}
