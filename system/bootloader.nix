{ ... }:

{
  config = {
    # Systemd-boot for UEFI based installation.
    boot.loader.systemd-boot.enable = true;

    # Legacy BIOS grub boot for virtual machine.
    # boot.loader.grub.enable = true;
    # boot.loader.grub.device = "/dev/vda";
    # boot.loader.grub.useOSProber = true;
  };
}
