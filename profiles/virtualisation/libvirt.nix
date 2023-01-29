{ pkgs, lib, config, ... }:
with lib;
mkMerge [
  {
    # https://github.com/NixOS/nixpkgs/issues/37540
    environment.systemPackages = with pkgs; [ libguestfs-with-appliance inetutils ];

    virtualisation.libvirtd.enable = true;
    virtualisation.libvirtd.qemu.ovmf.enable = true;
    virtualisation.libvirtd.qemu.package = pkgs.qemu_kvm;
    virtualisation.spiceUSBRedirection.enable = true;

    boot.kernelModules = [ "kvm-intel" ];
  }

  (mkIf config.services.xserver.enable {
    environment.systemPackages = with pkgs; [ virt-manager ];
    home-manager.sharedModules = [
      ({ config, lib, ... }: lib.mkIf config.dconf.enable {
        dconf.settings."org/virt-manager/virt-manager/connections" = {
          autoconnect = [ "qemu:///system" ];
          uris = [ "qemu:///system" ];
        };
      })
    ];
  })
]
