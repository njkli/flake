{ self, lib, pkgs, profiles, suites, ... }:
with lib;

{
  services.zerotierone.joinNetworks = [{ "d3b09dd7f50e3236" = "admin-znsd"; }];

  imports =
    suites.base ++
    suites.networking ++
    (with profiles; [
      core.impermanence

      hardware.rtl88x2bu

      virtualisation.docker
      virtualisation.libvirt

      core.kernel.physical-access-system
      # services.mysql-container
      # services.k3s.node
    ]);

  #####
  # services.multimedia.server.httpd.enable = true;
  # services.multimedia.server.httpd.locations."/duff" = "http://somehost:8080/sabnzbd";

  age.secrets."cyberghost-nl-auth-user-pass" = {
    file = "${self}/secrets/shared/cyberghost-nl/auth-user-pass.age";
    path = "/run/secrets/auth-user-pass";
  };

  age.secrets."cyberghost-nl-ca.crt" = {
    file = "${self}/secrets/shared/cyberghost-nl/ca.crt.age";
    path = "/run/secrets/ca.crt";
  };

  age.secrets."cyberghost-nl-client.crt" = {
    file = "${self}/secrets/shared/cyberghost-nl/client.crt.age";
    path = "/run/secrets/client.crt";
  };

  age.secrets."cyberghost-nl-client.key" = {
    file = "${self}/secrets/shared/cyberghost-nl/client.key.age";
    path = "/run/secrets/client.key";
  };

  services.multimedia.server.secrets.vpn = [
    "/run/secrets/auth-user-pass"
    "/run/secrets/ca.crt"
    "/run/secrets/client.crt"
    "/run/secrets/client.key"
  ];

  # services.multimedia.server.enable = true;

  #####
  deploy.enable = true;
  deploy.params.hiDpi = false;
  deploy.params.lan.mac = "16:07:77:03:aa:ff";
  deploy.params.lan.ipv4 = "10.11.1.222/24";
  deploy.params.lan.dhcpClient = false;

  deploy.node.hostname = "10.11.1.222";
  deploy.node.fastConnection = true;
  deploy.node.sshUser = "admin";

  # systemd.network.networks.wifi-generic.matchConfig.Name = "wlp0s20u1";
  # systemd.network.networks.lan.dhcpV4Config.UseRoutes = false; # FIXME: candidate for deploy module
  systemd.network.networks.local-eth.matchConfig.Name = "enp1s0";

  systemd.network.networks.lan.networkConfig.DNSSEC = "allow-downgrade";
  # maybe DNSSECNegativeTrustAnchors
  systemd.network.networks.lan.networkConfig.DNSDefaultRoute = true;
  systemd.network.networks.lan.gateway = [ "10.11.1.254" ];
  systemd.network.networks.lan.dns = [ "10.11.1.4:53" ];
  systemd.network.networks.lan.domains = [ "njk.local" ];

  systemd.network.networks.lan.addresses = [{ addressConfig.Address = "10.11.1.222/24"; }];

  networking = {
    hostName = "argabuthon";
    hostId = "e6b20044";
    wireless.enable = false; #
  };

  # NOTE: Enabling USB3
  boot.extraModprobeConfig = ''
    options 88x2bu rtw_switch_usb_mode=1
  '';

  zramSwap.enable = true;
  zramSwap.memoryPercent = 3;
  zramSwap.algorithm = "zstd";

  services.zfs.trim.enable = true;
  services.zfs.autoScrub.enable = true;

  fileSystems."/boot".device = "/dev/disk/by-uuid/70C0-169A";
  fileSystems."/boot".fsType = "vfat";

  fileSystems."/".device = "rpool/local/root";
  fileSystems."/".fsType = "zfs";

  fileSystems."/nix".device = "rpool/local/nix";
  fileSystems."/nix".fsType = "zfs";

  fileSystems."/home".device = "rpool/persist/home";
  fileSystems."/home".fsType = "zfs";
  fileSystems."/home".neededForBoot = true;

  fileSystems."/persist".device = "rpool/persist/misc";
  fileSystems."/persist".fsType = "zfs";
  fileSystems."/persist".neededForBoot = true;

  # zfs cfg
  boot.supportedFilesystems = [ "zfs" ];
  # zfs diff rpool/local/root@blank
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r rpool/local/root@blank
  '';

  boot.zfs.forceImportAll = true;
  boot.kernelParams = [ "zfs.zfs_arc_max=822083584" ];
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.grub.enable = true;
  boot.loader.grub.splashImage = null;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.zfsSupport = true;
  boot.loader.grub.version = 2;
  boot.loader.timeout = 0;

  systemd.tmpfiles.rules = mkAfter [ "d /mnt 0755 root root - -" ];

  services.journald.extraConfig = "Storage=volatile";
  services.logind.lidSwitch = "ignore";
  services.acpid.enable = true;
  powerManagement.enable = true;

  hardware.firmware = [ pkgs.broadcom-bt-firmware ];
  hardware.bluetooth.enable = true;
  environment.systemPackages = with pkgs; [ bluez-tools ];
}
