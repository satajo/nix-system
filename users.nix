{ lib, config, pkgs, ... }:

{
  # Main user account. Don't forget to set a password with ‘passwd’.
  users.users.satajo = {
    isNormalUser = true;
    description = "satajo";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      git
      hyperfine # Benchmarking tool
      tig # Git terminal gui
    ];
  };
}
