{
  home-manager.users.satajo = {
    services.keynav.enable = true;

    xdg.configFile."keynav/keynavrc".source = ./keynavrc;
  };
}
