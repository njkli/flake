# build with: `bud build bootstrap bootstrapIso`
{ self, profiles, suites, lib, pkgs, ... }:
let inherit (lib) mkForce; in
{
  imports = suites.networking ++
    [
      profiles.users.bootstrap
      # "${self.inputs.netboot-nix}/quickly.nix"
    ];

  deploy.params.hiDpi = false;
  deploy.params.lan.ipxe = false;

  # systemd.network.networks.lan.dhcpV4Config = {
  #   # SendOption = "252:uint8:1";
  #   RequestOptions = "4 5 16 17 23 69 70 73 74 77 81 117 119 252";
  # };

  networking.hostId = "11ff02ff";

  services.qemuGuest.enable = true;
  # services.getty.autologinUser = mkForce "bootstrap"; # FIXME: change back to null!
  services.getty.helpLine = ''<<< \l >>>'';

  boot.kernel.sysctl."fs.inotify.max_user_watches" = mkForce 524288;

  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = lib.mkForce 0;

  environment.systemPackages = with pkgs; [ pciutils ];
  # fileSystems."/".fsType = lib.mkForce "ext4";
  # NOTE: will be overridden by the bootstrapIso instrumentation
  # fileSystems."/".device = "/dev/disk/by-partlabel/root";
  # fileSystems."/boot".fsType = "vfat";

}
