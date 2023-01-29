{ self, config, hmUsers, pkgs, lib, profiles, ... }:
{
  imports = [
    profiles.desktop.xdmcp
    profiles.desktop.common
    profiles.desktop.stumpwm
    profiles.desktop.chromium-browser
    profiles.desktop.firefox-browser
    profiles.hardware.crypto
    profiles.core.age-secrets
  ];

  home-manager.users.nixmaniac.imports = [ hmUsers.nixmaniac ./home ];

  users.users.nixmaniac = {
    # openssh.authorizedKeys.keys = [ "" ];
    shell = pkgs.zsh;
    uid = 1001;
    hashedPassword = "$6$VsWUQCau32Oa$tNiMK5LftcuYDRPeACeP/BLikr7tYps/MHDeF3GT0bNRvyEW3PgIXXMzBY5x.FvGO6NprwhDldeFeKBzVQuhI1";
    description = "Keeping it saner";
    isNormalUser = true;

    extraGroups = [
      "scanner"
      "wireshark"
      "wheel"
      "nitrokey"
      "backup"
      "gnunet"
      "networkmanager"
      "disk"
      "lp"
      "audio"
      "video"
      "media"
      "input"
      "docker"
      "kvm"
      "plugdev"
      "network"
      "libvirtd"
      "systemd-journal"
      "adbusers"
      "xrdp"
      "dialout"
    ];

  };
}
