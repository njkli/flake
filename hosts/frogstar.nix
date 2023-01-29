{ self, lib, suites, profiles, pkgs, ... }:
with lib;
{
  imports =
    suites.base ++
    suites.networking ++
    (with profiles; [
      core.impermanence
      virtualisation.docker
      core.kernel.physical-access-system

      networks.home-lab.server

      # services.mysql-container
      # services.k3d.server
    ]);

  # networks."njk.local".master = true;
  networks."njk.local".macvlan = "lan";
  networks."njk.local".hosts = [{ hostname = "testing"; }];

  deploy.enable = true;
  deploy.params.hiDpi = false;
  deploy.params.lan.mac = "16:07:77:ff:a1:ff";
  deploy.params.lan.ipv4 = "10.11.1.254/24";
  deploy.params.lan.dhcpClient = false;

  deploy.node.hostname = "10.11.1.254";
  # deploy.node.hostname = "192.168.8.254";
  deploy.node.fastConnection = true;
  deploy.node.sshUser = "admin";

  networking.hostId = "6046ecf1";
  networking.hostName = "frogstar";

  services.zerotierone.enable = true;
  # services.zerotierone.joinNetworks = [{ "d3b09dd7f50e3236" = "admin-zt"; }];

  services.nfsv4.server.enable = true;
  # services.nfsv4.server.exports.IA.source = "/persist/backup/extracted/insurance_agent";
  # services.nfsv4.server.exports.IA.target = "10.11.1.0/24(rw,async,no_subtree_check,all_squash,anonuid=1000,anongid=100) 10.22.0.0/24(rw,async,no_subtree_check,all_squash,anonuid=1000,anongid=100)";

  services.nfsv4.server.exports.http_boot.source = "/persist/opt/http_boot";
  services.nfsv4.server.exports.http_boot.target = "10.11.1.220/24(rw,async,no_subtree_check,all_squash,anonuid=10000,anongid=100)";

  services.nfsv4.server.exports.backup.source = "/persist/backup";
  services.nfsv4.server.exports.backup.target = "10.11.1.0/24(rw,async,no_subtree_check,no_root_squash)";

  services.nfsv4.server.exports."nfsroot/bootstrap".source = "/nfsroot/bootstrap";
  services.nfsv4.server.exports."nfsroot/bootstrap".target = "10.11.1.0/24(rw,async,no_subtree_check,no_root_squash,no_all_squash)";

  services.nfsv4.server.exports.downloads.source = "/exports/downloads";
  services.nfsv4.server.exports.downloads.target = "10.22.0.0/24(rw,async,no_subtree_check,all_squash,anonuid=10000,anongid=100) 10.11.1.0/24(rw,async,no_subtree_check,all_squash,anonuid=10000,anongid=100)";

  zramSwap.enable = true;
  zramSwap.memoryPercent = 5;
  zramSwap.algorithm = "zstd";

  services.journald.extraConfig = "Storage=persistent";

  networking.wireless.enable = true;
  networking.wireless.interfaces = [ "wlp1s0" ];

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

  boot.loader.efi.canTouchEfiVariables = false;

  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r rpool/local/root@blank
  '';

  services.zfs.trim.enable = true;
  services.zfs.autoScrub.enable = true;

  # ISSUE: https://github.com/NixOS/nixpkgs/issues/54521
  boot.zfs.forceImportAll = true;
  boot.zfs.devNodes = "/dev/disk/by-partuuid";

  boot.zfs.extraPools = [ "persist" ];

  #  FIXME: before deploy!
  fileSystems."/boot".device = "/dev/disk/by-uuid/C9E7-081F";
  fileSystems."/boot".fsType = "vfat";

  fileSystems."/".device = "rpool/local/root";
  fileSystems."/".fsType = "zfs";

  fileSystems."/nix".device = "rpool/local/nix";
  fileSystems."/nix".fsType = "zfs";

  fileSystems."/home".device = "persist/home";
  fileSystems."/home".fsType = "zfs";
  fileSystems."/home".neededForBoot = true;

  fileSystems."/persist".device = "persist/misc";
  fileSystems."/persist".fsType = "zfs";
  fileSystems."/persist".neededForBoot = true;

  environment.persistence."/persist".directories = [
    "/var/lib/postgresql"
    "/opt/http_root"
  ];

}
