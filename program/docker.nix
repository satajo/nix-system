{ pkgs, ... }:
{
  virtualisation.docker = {
    enable = true;
    # Configuration
    autoPrune.enable = true;
  };

  # Adding user to the docker group.
  users.extraGroups.docker.members = [ "satajo" ];

  # Related tools.
  environment.systemPackages = with pkgs; [ dive ];
}
