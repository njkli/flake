{ config, lib, suites, profiles, ... }:
with lib;
let
  hName = lib.our.capitalize config.networking.hostName;
in
{
  imports =
    suites.base ++
    suites.networking ++
    (with profiles; [
      core.kernel.physical-access-system
      # virtualisation.docker
      # TODO: networking.nebula-admin
    ]);

  services.journald.extraConfig = "Storage=volatile"; # TODO: collect system logs properly

  networking = {
    wireless.enable = mkDefault false;
    networkmanager.enable = false;
    enableIPv6 = false;
    firewall.allowPing = true;
    firewall.enable = true;
  };

  boot.loader.efi.canTouchEfiVariables = false;

  # NOTE: battery charge rate < drain rate, possibly due to RTL wifi/bt driver, so disabling it.
  boot.blacklistedKernelModules = [ "rtl8723bs" "btrtl" "hci_uart" ];
  hardware.bluetooth.enable = false;
  hardware.bluetooth.powerOnBoot = false;

  # FIXME: newer kernels have an old bug with backlight not being detected/adjustable!
  # Option "Backlight" "string"
  # For my HKC displays, this might help detect initial resolution properly
  # Option "CustomEDID" "string"

  services.xserver.videoDrivers = [ "intel" ];

  services.xserver.remote-display.client.enable = mkDefault true;
  services.xserver.remote-display.client.dbg.enable = mkDefault false;
  services.xserver.remote-display.client.brightness = mkDefault 10;
  services.xserver.remote-display.client.dbg.port = mkDefault 22220;

  zramSwap.enable = mkDefault true;
  zramSwap.memoryPercent = mkDefault 5;
  zramSwap.algorithm = mkDefault "zstd";

  fileSystems."/".device = mkDefault "/dev/disk/by-partlabel/${hName}_root";
  fileSystems."/".fsType = mkDefault "ext4";
  fileSystems."/boot".device = mkDefault "/dev/disk/by-partlabel/${hName}_boot";
  fileSystems."/boot".fsType = mkDefault "vfat";
}
