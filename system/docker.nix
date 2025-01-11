{ pkgs, ... }:
{
  virtualisation.docker = {
    autoPrune.enable = true;
    enable = true;
    liveRestore = false; # Can delay system shutdown
    package = pkgs.docker_26;
  };

  # Docker requires the user to be in the group to run certain operations. This
  # has some negative security consequences, but it is practically required as
  # Docker insists on running stuff under root.
  #
  # TODO Look into how viable rootless Docker is. Or maybe podman.
  users.extraGroups.docker.members = [ "satajo" ];

  # Related tools.
  environment.systemPackages = with pkgs; [ dive ];
}
