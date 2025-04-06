{ pkgs, ... }:
{
  virtualisation = {
    # Enable common container config files in /etc/containers
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
    };
  };

  environment.systemPackages = with pkgs; [
    dive # Image layer viewer
    podman-compose
    podman-tui
  ];
}
