{ ... }:
{
  home-manager.users.satajo = {
    services.mpd = {
      enable = true;

      extraConfig = ''
        audio_output {
          type "pipewire"
          name "PipeWire"
        }
        auto_update "yes"
        restore_paused "yes"
        replaygain "album"
      '';
    };

    # Bridge MPD to the MPRIS2 D-Bus interface so playerctl-based consumers
    # (Longcut Media layer, polybar now-playing) can see and control it.
    # MPD speaks only its own protocol on port 6600; without this bridge it
    # is invisible to the standard desktop media-control ecosystem.
    services.mpd-mpris.enable = true;
  };
}
