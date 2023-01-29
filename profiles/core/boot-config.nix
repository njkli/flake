{ config, lib, pkgs, ... }:
with lib;
let kernel = config.boot.kernelPackages; in
{
  systemd.tmpfiles.rules = mkAfter [
    "d /mnt 0755 root root - -"
  ];

  environment.systemPackages = [ pkgs.efibootmgr ];
  hardware.cpu.intel.updateMicrocode = true;

  # boot.extraModulePackages = optional (versionOlder (kernel.version) "5.6") kernel.wireguard;
  # TODO: services.smartd.enable

  boot.loader.timeout = mkDefault 0;
  boot.supportedFilesystems = [ "ext4" "zfs" "nfs4" "nfs" ];

  boot.initrd.compressor = mkDefault "${pkgs.pigz}/bin/pigz --best --recursive";
  boot.initrd.supportedFilesystems = [ "ext4" "zfs" "vfat" ];
  boot.initrd.kernelModules = [ "nfs" ];
  boot.initrd.availableKernelModules = optionals config.virtualisation.libvirtd.enable [
    # qemu-guest
    "virtio_pci"
    "virtio_mmio"
    "virtio_blk"
    "virtio_balloon"
    "virtio_rng"
    "ext4"
    "unix"
    "9p"
    "9pnet_virtio"
    "virtio_console"
  ] ++ [
    # Mostly useful
    "crc32c_generic"
    "xhci_pci"
    "ehci_pci"
    "sdhci_pci"
    "sdhci_acpi"
    "ahci"
    "uhci_hcd"
    "usbhid"
    "usb_storage"
    "sd_mod"
    "sr_mod"
    "rtsx_pci_sdmmc"
    "rtsx_usb_sdmmc"
  ];

  boot.kernelParams = mkAfter [
    "panic=15"
    "boot.panic_on_fail"
    "consoleblank=90"
    "systemd.gpt_auto=0"
    "systemd.crash_reboot=1"
    "systemd.dump_core=0"
    "udev.log_priority=3"
    "quiet"
  ];

}
