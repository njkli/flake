{ profiles, suites, lib, ... }:
with lib;
{
  imports =
    suites.base ++
    suites.networking ++
    [
      profiles.hardware.rtl88x2bu
      # profiles.users.nixos
      profiles.users.vod
    ];

  deploy.enable = false;
  deploy.node.hostname = "10.11.1.226";
  deploy.node.sshUser = "admin";
  deploy.node.fastConnection = true;

  networking.hostId = "111ff2f1";
  services.qemuGuest.enable = true;

  environment.persistence."/persist".directories = [
    # "/etc/ssh"
    "/var/log"
    "/var/lib/docker"
    "/var/lib/libvirt"
    "/var/lib/systemd/rfkill"
    "/var/lib/bluetooth"
    "/var/lib/yubico"
    # "/etc/NetworkManager/system-connections"
  ];

  # NOTE: This only works for local-fs stuff, don't put any network deps here!
  systemd.tmpfiles.rules = mkAfter [ "v /opt 0755 root root - -" ];

  fileSystems."/boot".device = "/dev/disk/by-partlabel/bootEFI";
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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  boot.initrd = {
    # Impermanence module
    postDeviceCommands = lib.mkAfter ''
      zfs rollback -r rpool/local/root@blank
    '';
    # Required to open the EFI partition and Yubikey
    kernelModules = [ "vfat" "nls_cp437" "nls_iso8859-1" "usbhid" ];

    # Support for Yubikey PBA
    luks.yubikeySupport = true;

    luks.devices."encrypted" = {
      device = "/dev/disk/by-partlabel/luksDevice"; # Be sure to update this to the correct volume
      yubikey.slot = 2;
      yubikey.twoFactor = true; # Set to false for 1FA
      yubikey.gracePeriod = 30; # Time in seconds to wait for Yubikey to be inserted
      yubikey.keyLength = 64; # Set to $KEY_LENGTH/8
      yubikey.saltLength = 16; # Set to $SALT_LENGTH

      yubikey.storage.device = "/dev/disk/by-partlabel/bootEFI"; # Be sure to update this to the correct volume
      yubikey.storage.fsType = "vfat";
      yubikey.storage.path = "/crypt-storage/default";
    };
  };
}
