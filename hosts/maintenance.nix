{ self, config, inputs, lib, pkgs, suites, profiles, ... }:
with lib;
{
  imports = with profiles;
    [ users.bootstrap ]
    # ++ [ "${inputs.netboot-nix}/quickly.nix" ]
    ++ (with hardware; [ rtl88x2bu chuwi ])
    ++ (with core; [
      boot-config
      nix-config
      packages
      shell-defaults
      kernel.kconfig
    ])
    # ++ suites.base
    ++ suites.networking;

  deploy.enable = true;
  # deploy.params.lan.mac = "16:07:77:0a:aa:ff";
  # deploy.params.lan.ipv4 = "10.11.1.43/24";

  deploy.node.hostname = "10.11.1.101";
  deploy.node.fastConnection = true;
  deploy.node.sshUser = "bootstrap";

  deploy.params.hiDpi = false;
  deploy.params.lan.ipxe = false;

  networking.hostName = "maintenance";
  networking.domain = "0.njk.li";
  networking.hostId = "1f4f02f0";
  networking.enableIPv6 = false;
  networking.wireless.enable = true;
  networking.wireless.userControlled.enable = true;
  networking.firewall.allowPing = mkForce true;

  fileSystems."/".device = "/dev/disk/by-partlabel/maintRoot";
  fileSystems."/".fsType = "ext4";
  fileSystems."/".options = [ "defaults" ];

  fileSystems."/boot".device = "/dev/disk/by-partlabel/maintBoot";
  fileSystems."/boot".fsType = "vfat";

  # environment.etc."nixos/flake".source = self;

  boot.kernelParams = mkAfter [ "fbcon=rotate:0" ];
  boot.initrd.kernelModules = [
    "nfs4"
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
  ];

  # location.provider = "manual";
  # location.longitude = 50.123929;
  # location.latitude = 8.6402113;

  # time.timeZone = "Europe/Berlin";
  # i18n.defaultLocale = "en_US.UTF-8";
  # i18n.supportedLocales = [
  #   "ru_RU.UTF-8/UTF-8"
  #   "en_US.UTF-8/UTF-8"
  #   "en_GB.UTF-8/UTF-8"
  #   "de_DE.UTF-8/UTF-8"
  # ];

  # i18n.extraLocaleSettings.LC_MESSAGES = "en_US.UTF-8";
  # i18n.extraLocaleSettings.LC_TIME = "en_GB.UTF-8";
  # i18n.extraLocaleSettings.LC_NUMERIC = "en_US.UTF-8";
  # i18n.extraLocaleSettings.LC_PAPER = "de_DE.UTF-8";
  # i18n.extraLocaleSettings.LC_TELEPHONE = "de_DE.UTF-8";
  # i18n.extraLocaleSettings.LC_MONETARY = "de_DE.UTF-8";
  # i18n.extraLocaleSettings.LC_ADDRESS = "de_DE.UTF-8";
  # i18n.extraLocaleSettings.LC_MEASUREMENT = "de_DE.UTF-8";

  # boot.initrd.postDeviceCommands =
  #   ''
  #     # qemu-kvm guest workaround
  #     hwclock -s
  #   '';

  # zramSwap.enable = true;
  # zramSwap.memoryPercent = 25;
  # zramSwap.algorithm = "zstd";

  nix.maxJobs = mkForce 1;

  hardware.sensor.iio.enable = false;
  hardware.enableRedistributableFirmware = true;

  # services.qemuGuest.enable = true;

  services.openssh.forwardX11 = false;

  # services.getty.greetingLine              = mkDefault "<<< \l >>>";
  services.getty.helpLine = mkForce "[ ${config.networking.hostName} ] Ahoyhoy!";
  services.journald.extraConfig = "Storage=volatile";

  services.acpid.enable = true;
  services.logind.lidSwitch = mkForce "ignore";

  environment.systemPackages = with pkgs; [
    ###
    self.nixosConfigurations.bootstrap-zfs.config.system.build.toplevel
    ###
    acl
    (writeShellScriptBin "rotate-console" ''
      echo $1 > /sys/class/graphics/fbcon/rotate
    '')
    git
    git-crypt
  ];

  # system.build.netbootIpxe = pkgs.linkFarm "boot-ipxe-dir" [
  #   {
  #     name = "boot/${config.networking.hostName}/bzImage";
  #     path = "${config.system.build.kernel}/${config.system.build.toplevel.stdenv.hostPlatform.linux-kernel.target}";
  #   }

  #   {
  #     name = "boot/${config.networking.hostName}/initrd";
  #     path = "${config.system.build.netbootRamdisk}/initrd";
  #   }

  #   {
  #     name = "boot/${config.networking.hostName}/netboot.ipxe";
  #     path = pkgs.writeText "${config.networking.hostName}_netboot.ipxe" ''
  #       #!ipxe
  #       # ${config.networking.hostName}.${config.networking.domain}

  #       set kernel-url ''${base-url}/${config.networking.hostName}/bzImage
  #       set initrd-url ''${base-url}/${config.networking.hostName}/initrd

  #       set init-cmd init=${config.system.build.toplevel}/init initrd=initrd
  #       set cmd-line ''${init-cmd} ${toString config.boot.kernelParams}

  #       kernel ''${kernel-url} ''${cmd-line}
  #       initrd ''${initrd-url}
  #       boot
  #     '';
  #   }

  # ];

  documentation.enable = false;
  documentation.nixos.enable = false;

  powerManagement.enable = true;

  environment.noXlibs = mkForce true;
  environment.variables.GC_INITIAL_HEAP_SIZE = "1M";
}
