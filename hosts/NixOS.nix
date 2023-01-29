{ inputs, profiles, suites, ... }:
{
  imports = with suites;
    base ++
    networking ++
    [ profiles.hardware.rtl88x2bu profiles.users.nixos "${inputs.netboot-nix}/quickly.nix" ];

  deploy.enable = false;
  deploy.params.lan.ipxe = false;
  deploy.params.hiDpi = false;

  deploy.node.hostname = "192.168.122.156";
  deploy.node.sshUser = "admin";
  deploy.node.fastConnection = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  networking.hostId = "11ff02f0";
  services.qemuGuest.enable = true;

  # fileSystems."/" = { device = "/dev/disk/by-label/nixos"; };
  fileSystems."/".device = "/dev/disk/by-partlabel/root";
  fileSystems."/boot".device = "/dev/disk/by-partlabel/boot";
}
