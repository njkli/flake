{ lib, profiles, pkgs, ... }:

with lib;
{
  imports = with profiles; [
    hardware.chuwi
    core.impermanence
    desktop.remote-display-client
  ];

  deploy.enable = true;
  deploy.params.hiDpi = true;
  deploy.params.lan.mac = "16:07:77:05:aa:ff";
  deploy.params.lan.ipv4 = "10.11.1.40/24";
  deploy.node.hostname = "10.11.1.40";
  deploy.node.fastConnection = true;
  deploy.node.sshUser = "admin";

  deploy.params.lan.dhcpClient = false;
  systemd.network.networks.lan = {
    addresses = [{ addressConfig.Address = "10.11.1.40/24"; }];
    networkConfig.Gateway = "10.11.1.254";
    dns = [ "8.8.8.8" ];
  };

  networking.hostName = "folfanga";
  networking.hostId = "25d6e1fb";

  services.redshift.brightness.night = "0.85";
  services.redshift.brightness.day = "0.85";

  services.xserver.remote-display.client.enable = true;
  services.xserver.remote-display.client.brightness = 15;
  services.xserver.remote-display.client.screens = [
    {
      id.vnc = "FOLFANGAUP";
      id.xrandr = "HDMI1";
      port = 65512;
      size.x = 1920;
      size.y = 1080;
      pos.x = 320;
      pos.y = "0";
      xrandrExtraOpts = "--primary";
    }

    {
      id.vnc = "FOLFANGADOWN";
      id.xrandr = "eDP1";
      port = 65511;
      size.x = 2560;
      size.y = 1600;
      pos.x = 0;
      pos.y = "1080";
    }
  ];

  # zfs cfg
  services.zfs.trim.enable = true;
  services.zfs.autoScrub.enable = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportAll = true;
  # zfs_arc_max is 3GB
  boot.kernelParams = mkAfter [ "zfs.zfs_arc_max=3221225472" "fbcon=rotate:0" ];
  # DEFUNCT: boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.consoleLogLevel = 0;
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.grub.enable = true;
  boot.loader.grub.splashImage = null;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.zfsSupport = true;
  boot.loader.grub.version = 2;
  boot.loader.timeout = 0;

  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r rpool/local/root@blank
  '';

  fileSystems."/boot".device = "/dev/disk/by-uuid/F555-0BEF";
  fileSystems."/boot".fsType = "vfat";

  fileSystems."/".device = "rpool/local/root";
  fileSystems."/".fsType = "zfs";

  fileSystems."/nix".device = "rpool/local/nix";
  fileSystems."/nix".fsType = "zfs";

  fileSystems."/home".device = "rpool/persist/home";
  fileSystems."/home".fsType = "zfs";

  fileSystems."/persist".neededForBoot = true;
  fileSystems."/persist".device = "rpool/persist/misc";
  fileSystems."/persist".fsType = "zfs";
}
