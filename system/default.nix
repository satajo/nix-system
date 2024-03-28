{
  imports = [
    ./bootloader.nix
    ./input.nix
    ./keyd.nix
    ./locale.nix
    ./nix.nix
    ./sound.nix
    ./vm-guest.nix
  ];

  # Device mounting.
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Application realtime priority grants.
  security.rtkit.enable = true;

  # Gnupg agent
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Networking
  networking = {
    networkmanager.enable = true;
    hostName = "nixos";
  };

  # Time zone.
  services.localtimed.enable = true;
  services.geoclue2.enable = true;

  # Logind.
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchDocked = "ignore";
  };
}

