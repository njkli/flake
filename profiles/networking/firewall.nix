{ lib, ... }:
with lib;
{
  networking.firewall.enable = mkDefault true;
  networking.firewall.allowPing = mkDefault false;
  networking.firewall.logRefusedConnections = mkDefault false;
  networking.firewall.autoLoadConntrackHelpers = mkDefault true;

  networking.firewall.connectionTrackingModules = mkDefault [
    "ftp"
    "irc"
    "sane"
    "sip"
    "tftp"
    # "amanda"
    # "snmp"
  ];
}
