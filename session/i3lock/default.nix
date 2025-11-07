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
        --add-flags "--color='${theme.color.backgroundLower}'" \
        --add-flags "--inside-color='${theme.color.backgroundLower}'" \
        --add-flags "--ring-color='${theme.color.foreground}'" \
        --add-flags "--separator-color='${theme.color.backgroundLower}'" \
        --add-flags "--keyhl-color='${theme.color.positive}'" \
        --add-flags "--bshl-color='${theme.color.negative}'" \
        --add-flags "--line-uses-inside" \
        \
        --add-flags "--time-color='${theme.color.foreground}'" \
        --add-flags "--date-color='${theme.color.foreground}'" \
        \
        --add-flags "--insidever-color='${theme.color.backgroundLower}'" \
        --add-flags "--ringver-color='${theme.color.foreground}'" \
        \
        --add-flags "--insidewrong-color='${theme.color.backgroundLower}'" \
        --add-flags "--ringwrong-color='${theme.color.foreground}'" \
        \
        --add-flags "--verif-color='${theme.color.foreground}'" \
        --add-flags "--wrong-color='${theme.color.foreground}'" \
        --add-flags "--modif-color='${theme.color.foreground}'" \
    '';
  };
  lockSessionScript = pkgs.writeShellScript "lock-session.sh" ''
    # Mute audio. Run in background to instantly lock even with errors or delays.
    ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ 1 &
    # Invoke the lock script.
    ${i3lock-wrapped}/bin/i3lock --nofork    
  '';
in
{
  environment.systemPackages = [ i3lock-wrapped ];

  # i3 lock pam
  security.pam.services.i3lock.enable = true;

  programs.xss-lock = {
    enable = true;
    lockerCommand = "${lockSessionScript}";
  };

  services.xserver.displayManager.sessionCommands = ''
    xset s 600 # 10 minutes
  '';
}
