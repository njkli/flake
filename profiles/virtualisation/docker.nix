{ config, lib, pkgs, ... }:
with lib;
with builtins;
let
  inInitrd = any (fs: fs == "zfs") config.boot.initrd.supportedFilesystems;
  inSystem = any (fs: fs == "zfs") config.boot.supportedFilesystems;
  isZfs = (inInitrd || inSystem) &&
    hasAttr "/" config.fileSystems &&
    config.fileSystems."/".fsType == "zfs";
  zpoolName = elemAt (splitString "/" config.fileSystems."/".device) 0;
  storageDriver = if isZfs then "zfs" else "overlay2";
in

mkMerge [
  (mkIf isZfs {
    systemd.services.docker.preStart = ''
      ! zfs list ${zpoolName}/local/docker && zfs create ${zpoolName}/local/docker || true
    '';

    environment.etc."docker/daemon.json".text = toJSON
      {
        storage-opts = [ "zfs.fsname=${zpoolName}/local/docker" ];
        exec-opts = [ "native.cgroupdriver=systemd" ];
      };
  })

  {
    systemd.enableUnifiedCgroupHierarchy = true;
    boot.kernelParams = [ "cgroup_enable=cpuset" "cgroup_memory=1" "cgroup_enable=memory" ];
    boot.kernelModules = [
      "rbd"
      "br_netfilter"
      "ip_conntrack"
      "ip_vs"
      "ip_vs_rr"
      "ip_vs_wrr"
      "ip_vs_sh"
      "overlay"
    ];

    # environment.etc."docker/daemon.json".text = toJSON
    #   { exec-opts = [ "native.cgroupdriver=systemd" ]; };

    virtualisation.oci-containers.backend = "docker";

    virtualisation.docker.enable = true;
    virtualisation.docker.enableOnBoot = true;
    virtualisation.docker.storageDriver = storageDriver;
    virtualisation.docker.autoPrune.enable = mkDefault true;
    virtualisation.docker.autoPrune.dates = mkDefault "daily";

    environment.systemPackages = with pkgs; [
      docker-compose
      # docker-machine-kvm2
    ];
  }

]
