{ ... }:
{
  home-manager.users.satajo.programs.helix = {
    enable = true;
    settings = {
      theme = "ayu_dark";
      editor = {
        line-number = "relative";
        cursorline = true;
        bufferline = "multiple";
        color-modes = true;
        true-color = true;
        rulers = [ 100 ];
        completion-replace = true;
        trim-trailing-whitespace = true;
        end-of-line-diagnostics = "hint";

        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };

        indent-guides = {
          render = true;
        };

        statusline = {
          left = [
            "mode"
            "spinner"
            "version-control"
            "file-name"
            "file-modification-indicator"
            "read-only-indicator"
          ];
          right = [
            "diagnostics"
            "selections"
            "position"
            "file-encoding"
            "file-type"
          ];
        };

        auto-save = {
          focus-lost = true;
          after-delay = {
            enable = true;
            timeout = 60000;
          };
        };

        lsp = {
          display-messages = true;
          display-inlay-hints = true;
        };

        inline-diagnostics.cursor-line = "warning";

        file-picker.hidden = false;
      };
    };
  };
}
