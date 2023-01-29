{ config, self, profiles, suites, lib, pkgs, modulesPath, ... }:
with lib;
let
  kernelTarget = pkgs.stdenv.hostPlatform.linux-kernel.target;
in
{
  imports = suites.networking ++ [
    profiles.users.bootstrap
    # "${modulesPath}/installer/cd-dvd/system-tarball.nix"

    profiles.core.boot-config
    profiles.core.kernel.kconfig
  ];

  deploy.params.hiDpi = false;
  deploy.params.lan.ipxe = true;

  networking.hostId = "14f002ff";
  # networking.useDHCP = true;

  services.qemuGuest.enable = true;
  services.getty.helpLine = ''<<< \l >>>'';

  boot.kernel.sysctl."fs.inotify.max_user_watches" = mkForce 524288;

  boot.initrd.network.enable = true;
  # boot.initrd.kernelModules = [ "virtio_net" ];
  boot.initrd.availableKernelModules = [
    "virtio_pci"
    "virtio_net"
    "virtio_mmio"
    "virtio_blk"
    "virtio_balloon"
    "virtio_rng"
    "unix"
    "9p"
    "9pnet_virtio"
    "virtio_console"
    # "nfs"
    "nfs4"
  ];

  environment.systemPackages = with pkgs; [ pciutils ];

  boot.loader.systemd-boot.enable = true;

  # fileSystems.fake = {
  #   mountPoint = "/";
  #   device = "/dev/something";
  # };

  fileSystems."/" = {
    fsType = "tmpfs";
    # device = "frogstar.njk.local:/nfsroot/bootstrap";
    # options = [ "nfsvers=4.2" ];
  };

  # fileSystems."/" = { device = "/dev/disk/by-label/nixos"; };
  # ip=dhcp
  system.build.ipxeBootDir = pkgs.runCommandNoCC "netbootNfs"
    {
      # nfsroot=:,v4.2,proto=tcp
      #
      pxe = ''
        #!ipxe
        kernel ${kernelTarget} root=/dev/nfs nfsroot=10.11.1.254:/nfsroot/bootstrap,vers=4.2,proto=tcp nfsrootdebug rootwait init=${config.system.build.toplevel}/init initrd=initrd ${toString config.boot.kernelParams} panic=90 console=ttyS0 console=tty
        initrd initrd
        boot
      '';
      preferLocalBuild = true;
    } ''
    mkdir -p $out
    ln -s ${config.system.build.kernel.out}/${kernelTarget} $out/${kernelTarget}
    ln -s ${config.system.build.initialRamdisk}/${config.system.boot.loader.initrdFile} $out/${config.system.boot.loader.initrdFile}
    echo "$pxe" > $out/netboot.ipxe
  '';
}
