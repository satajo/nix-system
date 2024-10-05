{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.profile.personal {
    programs.steam = {
      enable = true;
      extraPackages = with pkgs; [ mangohud ];
    };
  };
}
