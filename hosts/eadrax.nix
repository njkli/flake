{ config, lib, pkgs, profiles, suites, ... }:
with lib;

{
  imports =
    suites.base ++
    suites.networking ++
    (with profiles; [
      users.vod
      core.impermanence

      hardware.rtl88x2bu
      hardware.keyboards.uhk-60v2

      virtualisation.docker
      virtualisation.libvirt

      core.kernel.physical-access-system
      desktop.remote-display-host-8-heads

      legacy.admin-machine

      networking.adblocking

      # networking.nebula-admin
      # networking.netmaker-tunnel
      # networking.debug
      networking.samba
    ]);

  deploy.enable = true;
  # deploy.params.hiDpi = true;
  deploy.params.lan.mac = "16:07:77:00:aa:ff";
  deploy.params.lan.ipv4 = "10.11.1.220/24";

  deploy.node.hostname = "127.0.0.1";
  deploy.node.fastConnection = true;
  deploy.node.sshUser = "admin";

  systemd.network.networks.wifi-generic.matchConfig.Name = "wlp4s0u2";
  systemd.network.networks.lan.dhcpV4Config.UseRoutes = false; # FIXME: candidate for deploy module
  systemd.network.networks.local-eth.matchConfig.Name = "enp0s31f6";

  # systemd.network.networks.lan.networkConfig.DNSSEC = true;
  systemd.network.networks.lan.networkConfig.DNSDefaultRoute = true;
  systemd.network.networks.lan.dns = [ "10.11.1.4:53" ];
  systemd.network.networks.lan.domains = [ "njk.local" ];
  systemd.network.networks.lan.gateway = [ "10.11.1.1" ];

  deploy.params.lan.dhcpClient = false;
  systemd.network.networks.lan.addresses = [{ addressConfig.Address = "10.11.1.220/24"; }];

  networking = {
    hostName = "eadrax";
    hostId = "11ff021a";
    wireless.enable = true; #
    networkmanager.enable = false;
    enableIPv6 = false;
    firewall.allowPing = true;
    firewall.enable = true;
    # firewall.logRefusedConnections = true;
    # hosts."151.101.122.217" = [ "cache.nixos.org" ]; # FIXME: kinda fast server
  };

  services.journald.extraConfig = "Storage=volatile"; # TODO: collect system logs properly

  # TODO: services.uvcvideo.dynctrl.enable = true; # 0203:145f - aukey uvcvideo
  # FIXME: hardware.bluetooth.enable = true;
  # hardware.bluetooth.powerOnBoot = true;

  # environment.systemPackages = with pkgs; [ bluez-tools ];

  hardware.enableAllFirmware = true;

  zramSwap.enable = true;
  zramSwap.memoryPercent = 5;
  zramSwap.algorithm = "zstd";

  boot.zfs.forceImportAll = true;

  # NOTE: The machine has 64GB of ram and 3x nve 250GB drives, running with 16GB zfs_arc_max

  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.grub.enable = true;
  boot.loader.grub.splashImage = null;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.zfsSupport = true;
  boot.loader.grub.version = 2;

  boot.loader.timeout = 0;

  boot.plymouth.enable = true;
  boot.plymouth.font =
    let
      nerdFonts = head (filter (e: e ? pname && e.pname == "nerdfonts") config.fonts.fonts);
      dumbDrv = pkgs.runCommandNoCC "dumb-nerdfonts-pkg-plymouth" { buildInputs = [ nerdFonts ]; } ''
        mkdir -p $out
        cp '${nerdFonts}/share/fonts/truetype/NerdFonts/Ubuntu Medium Nerd Font Complete Mono.ttf' $out/nerd_font_ubuntu_mono.ttf
      '';
    in
    "${dumbDrv}/nerd_font_ubuntu_mono.ttf";
  boot.plymouth.extraConfig = ''
    DeviceScale=2
  '';

  boot.consoleLogLevel = 0;
  boot.initrd.supportedFilesystems = [ "ext4" "zfs" ];
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "usbhid"
    "usb_storage"
    "sd_mod"
    "sdhci_acpi"
    "rtsx_pci_sdmmc"
    "nvme"
    "nvme_core"
  ];
  boot.blacklistedKernelModules = [ "nouveau" ];

  boot.kernelParams = mkAfter [
    "video.use_native_backlight=1"
    "vt.global_cursor_default=0"
    "elevator=none" # NOTE: https://grahamc.com/blog/nixos-on-zfs
    # "i915.fastboot=1"
    # "systemd.show_status=0"
    # "systemd.log_level=0"

    # FIXME: https://github.com/NixOS/nixpkgs/issues/40388#issuecomment-991946354
    #        https://archived.forum.manjaro.org/t/how-to-choose-the-proper-acpi-kernel-argument/80035
    # FIXME: "acpi_osi=!"
    # FIXME: "acpi_osi='Windows 2009'"
    # "acpi_osi=!"
    # "acpi_osi=\"Windows 2015\""

    # NOTE: likely not needed with newer systemd - investigate! "resume=LABEL=hibernate"
    # NOTE: pci-passthrough "intel_iommu=on" "iommu=pt"
    # "i915.modeset=1" "i915.enable_dpcd_backlight=1"

    "zfs.zfs_arc_max=${toString (16 * 1024 * 1024 * 1024)}" # NOTE: 16GB
    "splash"
  ];

  ### NOTE: PCI passthrough options vfio-pci ids=10de:1402,10de:0fba,8086:8ca0
  # boot.extraModprobeConfig = ''
  # '';
  #
  # boot.kernelModules = [
  #   # "vfio"
  #   # "vfio-pci"
  #   # "vfio_mdev"
  #   # "vfio_virqfd"
  # ]; # NOTE: https://github.com/qdm12/VFIO-Arch-Guide

  # NOTE: Desktop graphics don't support backlight at least via HDMI and Elecom panel :(
  services.xserver.videoDrivers = [ "intel" ];

  services.acpid.enable = true;
  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "performance";

  ###
  # ZFS
  services.zfs.trim.enable = true;
  services.zfs.autoScrub.enable = true;

  # NOTE: zfs diff rpool/local/root@blank
  # TODO: module with zfs - zfs allow wheel create,mount,diff,clone,receive,send,snapshot rpool
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r rp/local/root@blank
  '';

  # NOTE: This only works for local-fs stuff, don't put any network deps here!
  systemd.tmpfiles.rules = mkAfter [
    "v /opt 0755 root root - -"
  ];

  swapDevices = [{ label = "hibernate"; }];

  boot.kernel.sysctl."vm.swappiness" = 1;

  fileSystems."/boot".device = "/dev/disk/by-uuid/773A-032D";
  fileSystems."/boot".fsType = "vfat";

  fileSystems."/".device = "rp/local/root";
  fileSystems."/".fsType = "zfs";

  fileSystems."/nix".device = "rp/local/nix";
  fileSystems."/nix".fsType = "zfs";

  fileSystems."/home".device = "rp/persist/home";
  fileSystems."/home".fsType = "zfs";

  fileSystems."/persist".neededForBoot = true;
  fileSystems."/persist".device = "rp/persist/misc";
  fileSystems."/persist".fsType = "zfs";
}
