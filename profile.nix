{ lib, ... }: {
  options.profile = {
    # Chat applications, games, etc.
    personal = lib.mkEnableOption "personal profile features";
    # Services and configs for having the system work as a guest OS.
    vm-guest = lib.mkEnableOption
      "virtual machine guest operating system compatibility features";
  };
}
