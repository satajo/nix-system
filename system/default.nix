{
  imports = [
    ./bootloader.nix
    ./fonts.nix
    ./input.nix
    ./keyd.nix
    ./lightdm.nix # Display / login manager
    ./locale.nix
    ./nix.nix
    ./nvidia.nix
    ./pipewire.nix # Audio server
    ./vm-guest.nix
  ];

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

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
    firewall = {
      enable = true;
      allowedTCPPorts = [ 8000 ];
    };
    networkmanager.enable = true;
  };

  # Location
  location.provider = "geoclue2";
  services.geoclue2.enable = true;

  # Time zone.
  services.localtimed.enable = true;

  # Logind.
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchDocked = "ignore";
  };
}
