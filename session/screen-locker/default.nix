# i3lock-color based screen locker.
{ pkgs, ... }:
let
  theme = import ../../theme/lib.nix { pkgs = pkgs; };
  i3lock-wrapped = pkgs.symlinkJoin {
    name = "i3lock";
    paths = [ pkgs.i3lock-color ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/i3lock \
        --add-flags "--ignore-empty-password" \
        \
        --add-flags "--noinput-text='No input'" \
        --add-flags "--verif-text='Verifying'" \
        --add-flags "--wrong-text='Incorrect'" \
        \
        --add-flags "--indicator" \
        --add-flags "--clock" \
        --add-flags "--radius=120" \
        --add-flags "--ring-width=10" \
        --add-flags "--time-str='%H:%M:%S'" \
        --add-flags "--date-str='%A %d.%m.%Y'" \
        \
        --add-flags "--date-font='${theme.font.monospace}'" \
        --add-flags "--greeter-font='${theme.font.monospace}'" \
        --add-flags "--layout-font='${theme.font.monospace}'" \
        --add-flags "--time-font='${theme.font.monospace}'" \
        --add-flags "--verif-font='${theme.font.monospace}'" \
        --add-flags "--wrong-font='${theme.font.monospace}'" \
        \
        --add-flags "--color='${theme.color.layer1.background}'" \
        --add-flags "--inside-color='${theme.color.layer1.background}'" \
        --add-flags "--ring-color='${theme.color.layer1.foreground}'" \
        --add-flags "--separator-color='${theme.color.layer1.background}'" \
        --add-flags "--keyhl-color='${theme.color.layer1.positive}'" \
        --add-flags "--bshl-color='${theme.color.layer1.negative}'" \
        --add-flags "--line-uses-inside" \
        \
        --add-flags "--time-color='${theme.color.layer1.foreground}'" \
        --add-flags "--date-color='${theme.color.layer1.foreground}'" \
        \
        --add-flags "--insidever-color='${theme.color.layer1.background}'" \
        --add-flags "--ringver-color='${theme.color.layer1.foreground}'" \
        \
        --add-flags "--insidewrong-color='${theme.color.layer1.background}'" \
        --add-flags "--ringwrong-color='${theme.color.layer1.foreground}'" \
        \
        --add-flags "--verif-color='${theme.color.layer1.foreground}'" \
        --add-flags "--wrong-color='${theme.color.layer1.foreground}'" \
        --add-flags "--modif-color='${theme.color.layer1.foreground}'" \
    '';
  };
in { environment.systemPackages = [ i3lock-wrapped ]; }
