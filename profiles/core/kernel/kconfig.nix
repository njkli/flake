{
  boot.kernelPatches = [
    {
      name = "iotop CONFIG_TASK_DELAY_ACCT";
      patch = null;
      extraConfig = ''
        TASK_DELAY_ACCT y
      '';
    }

    {
      name = "systemd-nspawn-and-opensnitch";
      patch = null;
      extraConfig = ''
        BPF y
        KPROBES y
        KPROBE_EVENTS y
        BPF_SYSCALL y
        BPF_EVENTS y
        CGROUP_BPF y
      '';
    }

    {
      name = "zswap-config";
      patch = null;
      extraConfig = ''
        CRYPTO_ZSTD y
        ZSWAP y
        Z3FOLD y
      '';
    }

    {
      name = "nfsroot-config";
      patch = null;
      extraConfig = ''
        IP_PNP y
        IP_PNP_DHCP y
        FSCACHE y
        NFS_FS y
        NFS_FSCACHE y
        ROOT_NFS y
        NFS_V4 y
        NFS_V4_2 y
      '';

      # IP_PNP_BOOTP y
      # IP_PNP_RARP y
      # DEVTMPFS y
      # DEVTMPFS_MOUNT y
    }

  ];

  boot.kernelParams = [
    "zswap.enabled=1"
    "zswap.zpool=z3fold"
    "zswap.compressor=zstd"
  ];

}
