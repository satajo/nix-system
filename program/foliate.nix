{
  config,
  lib,
  pkgs,
  ...
}:
{
  home-manager.users.satajo.home.packages = with pkgs; [ foliate ];

  # Foliate uses webkit to render text, which breaks on nvidia environments.
  # Maybe this should be in nvidia settings?
  environment.sessionVariables = lib.mkIf config.profile.nvidia {
    WEBKIT_DISABLE_DMABUF_RENDERER = "1";
  };
}
