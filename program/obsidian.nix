{ config, lib, pkgs, ... }: {
  config = lib.mkIf config.profile.personal {
    home-manager.users.satajo.home.packages = with pkgs; [ obsidian ];

    # Obsidian depends on electron which is outdated.
    nixpkgs.config.permittedInsecurePackages = [ "electron-25.9.0" ];
  };
}
