{ config, ... }:

{
  config.boot.loader = if config.profile.vm-guest then {
    # Legacy BIOS grub boot for virtual machine.
    grub.enable = true;
    grub.device = "/dev/vda";
    grub.useOSProber = true;
  } else {
    # Systemd-boot for UEFI based installation.
    systemd-boot.enable = true;
  };
}
