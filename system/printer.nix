{
  # CUPS print server. cups-filters is bundled unconditionally, and with
  # services.avahi.enable on (below), NixOS also starts cups-browsed for
  # discovery of mDNS-advertised IPP printers — covering driverless IPP
  # Everywhere, which most network printers from ~2014 onward support.
  #
  # If a specific model needs a vendor driver, add it via
  # services.printing.drivers (e.g. pkgs.brlaser for Brother laser models).
  services.printing.enable = true;

  # mDNS, so the printer's *.local hostname resolves for both CUPS browsing
  # and the rest of the system.
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
