{ lib, ... }: {
  options.profile = {
    # Nvidia GPU integration with various services"
    nvidia = lib.mkEnableOption "nvidia gpu";

    # Chat applications, games, etc.
    personal = lib.mkEnableOption "personal profile features";

    # Services and configs for having the system work as a guest OS.
    vm-guest = lib.mkEnableOption
      "virtual machine guest operating system compatibility features";
  };
}
