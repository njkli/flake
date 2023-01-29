{ self, config, inputs, lib, pkgs, suites, profiles, ... }:
with lib;
{
  imports = with profiles;
    [
      users.bootstrap
      users.admin
      users.vod
      users.nixmaniac

      core.impermanence

      networking.adblocking

      virtualisation.docker
      virtualisation.libvirt

      core.kernel.physical-access-system

      desktop.multimedia
    ]
    # ++ (with hardware; [ rtl88x2bu ])

    # ++ (with core; [
    #   boot-config
    #   nix-config
    #   packages
    #   shell-defaults
    #   kernel.kconfig
    # ])

    ++ suites.base
    ++ suites.networking;

  # services.huginn.enable = true;
  # services.huginn.agents = 1;
  # services.huginn.log-driver = "none";

  services.zerotierone.enable = mkForce false;

  deploy.enable = true;
  deploy.params.lan.mac = "16:07:77:cf:0a:ff";
  # deploy.params.lan.ipv4 = "10.11.1.43/24";

  # deploy.node.hostname = "10.11.1.107";
  deploy.node.hostname = "localhost";
  deploy.node.fastConnection = true;
  deploy.node.sshUser = "bootstrap";

  deploy.params.hiDpi = false;
  deploy.params.lan.ipxe = false;

  networking.hostName = "bootstrap-zfs";
  networking.domain = "0.njk.li";
  networking.hostId = "1f4c02f0";
  networking.enableIPv6 = false;

  networking.wireless.enable = false;
  networking.networkmanager.enable = true;
  services.udev.packages = with pkgs; [ crda ];
  environment.systemPackages = with pkgs; [ networkmanagerapplet ];

  # networking.wireless.userControlled.enable = true;
  # networking.firewall.allowPing = mkForce true;

  boot.initrd.postDeviceCommands = mkAfter ''
    zfs rollback -r rpool/local/root@blank
  '';

  systemd.tmpfiles.rules = mkAfter [ "v /opt 0755 root root - -" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  boot.plymouth.enable = true;
  boot.consoleLogLevel = 0;
  boot.kernelParams = mkAfter [ "zfs.zfs_arc_max=${toString (2 * 1024 * 1024 * 1024)}" ];

  fileSystems."/".device = "rpool/local/root";
  fileSystems."/".fsType = "zfs";

  fileSystems."/boot".device = "/dev/disk/by-uuid/9906-DD9E";
  fileSystems."/boot".fsType = "vfat";

  fileSystems."/nix".device = "rpool/local/nix";
  fileSystems."/nix".fsType = "zfs";

  fileSystems."/home".device = "rpool/persist/home";
  fileSystems."/home".fsType = "zfs";

  fileSystems."/persist".neededForBoot = true;
  fileSystems."/persist".device = "rpool/persist/misc";
  fileSystems."/persist".fsType = "zfs";

  hardware.bluetooth.enable = true;
  hardware.bluetooth.disabledPlugins = [ "sap" ];

  hardware.acpilight.enable = true;
  hardware.enableRedistributableFirmware = true;
  # services.getty.helpLine = mkForce "[ ${config.networking.hostName} ] Ahoyhoy install!";
  services.journald.extraConfig = "Storage=volatile";
  # services.openssh.forwardX11 = false;
  services.acpid.enable = true;
  services.logind.lidSwitch = mkForce "ignore";

  # documentation.enable = false;
  # documentation.nixos.enable = false;

  powerManagement.enable = true;

  # environment.noXlibs = mkForce true;
  # environment.variables.GC_INITIAL_HEAP_SIZE = "1M";
}
