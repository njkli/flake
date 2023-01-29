{ config, lib, ... }:
with lib;
# NOTE: zfs diff rpool/local/root@blank
# TODO: module with zfs - zfs allow wheel create,mount,diff,clone,receive,send,snapshot rpool

mkMerge [

  { environment.persistence."/persist".directories = [ "/var/log" ]; }

  # (mkIf ((length config.services.printing.drivers) > 0) {
  #   environment.persistence."/persist".directories = [ "/etc/cups" ];
  # })

  ### FIXME: adguardHome serviceConfig.StateDirectory
  # (mkIf config.services.adguardhome.enable {
  #   environment.persistence."/persist".directories = [ "/var/lib/AdGuardHome" ];
  # })

  (mkIf (config.networking.wireless.enable || config.hardware.bluetooth.enable) {
    environment.persistence."/persist".directories = [ "/var/lib/systemd/rfkill" ];
  })

  (mkIf config.networking.networkmanager.enable {
    environment.persistence."/persist".directories = [ "/etc/NetworkManager/system-connections" ];
  })

  (mkIf config.hardware.bluetooth.enable {
    environment.persistence."/persist".directories = [ "/var/lib/bluetooth" ];
  })

  (mkIf config.services.xserver.displayManager.lightdm.enable {
    environment.persistence."/persist".directories = [ "/var/cache/lightdm" ];
  })

  (mkIf config.services.opensnitch.enable {
    environment.persistence."/persist".directories = [ "/etc/opensnitchd/rules" ];
  })

  (mkIf config.virtualisation.docker.enable {
    environment.persistence."/persist".directories = [ "/var/lib/docker" ];
  })

  (mkIf config.virtualisation.libvirtd.enable {
    environment.persistence."/persist".directories = [ "/var/lib/libvirt" ];
  })

  (mkIf config.services.zerotierone.enable {
    # TODO: maybe only keep identity.secret in /persist for zerotier
    environment.persistence."/persist".directories = [ config.services.zerotierone.homeDir ];
  })

  (mkIf config.services.openssh.enable {

    age.identityPaths = mkDefault [
      "/persist/etc/ssh/ssh_host_ed25519_key"
      "/persist/etc/ssh/ssh_host_rsa_key"
    ];

    environment.persistence."/persist".files = mkDefault [
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_rsa_key"
    ];
  })
]
