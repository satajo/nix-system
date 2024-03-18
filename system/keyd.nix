{
  # Keyd key remapping daemon
  services.keyd.enable = true;
  services.keyd.keyboards.default.settings = {
    main = {
      space = "overloadt2(spacelayer, space, 150)";
      grave = "escape";
      backspace = "delete";
    };
    spacelayer = {
      # Undo esc-mapping
      grave = "grave";
      # Map esc to grave for 60% layouts
      escape = "grave";

      # Keynav scroll-lock under h
      h = "scrolllock";

      # Arrow keys on right hand home position
      j = "left";
      k = "down";
      l = "up";
      ";" = "right";

      # Movement keys under the right hand home position
      m = "home";
      comma = "pagedown";
      dot = "pageup";
      "/" = "end";

      # Function keys over number keys
      "1" = "f1";
      "2" = "f2";
      "3" = "f3";
      "4" = "f4";
      "5" = "f5";
      "6" = "f6";
      "7" = "f7";
      "8" = "f8";
      "9" = "f9";
      "0" = "f10";
      "-" = "f11";
      "=" = "f12";
    };
  };
}
