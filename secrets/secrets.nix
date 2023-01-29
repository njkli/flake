/*
  NOTE: age keys can only be generated from private ssh-rsa/ssh-ed25519 keys.
  It won't work with gpg ssh stuff on yubikey, since there's no way to get to the private key part of the pgp ssh key.
*/

let
  master_keys = {
    admin = "age1yubikey1q2nxheaj20m9l56gua4fpzp8dmeg6sq0ldjdhvkzke69r8excrdh27jt6l0"; # yk5
    admin_master = "age1yubikey1qgmlzyalykr4lye32ha76eux86z5p2gkg0zrwgntqhd4lecfwwdlkwr4jyp"; # yk4
    backup_master = "age10qpys9e60hjcclyg6n8c5wgf6gf7fwmt8kt3wxs58xmxttzcgpfq2aqhe5";
  };

  backup_keys = with master_keys; [ admin admin_master backup_master ];

  # set ssh public keys here for your system and user
  hosts = {
    eadrax = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGfL90hJu4x8W72BcSSJD3yM8Yd5vinSFfbd50eJDCC5";
    argabuthon = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDdQGKtRw2lBNX/WQXTu61n24ULIzA9DSdH4RJdwjdpH";
    NixOS = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAd4FkN4x3PcnSpoWdMQjROCI4Ch+wFC0at1yPKKI+TO";
    frogstar_vm = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPi05ImZcwyrf97qvvcvGboO269msILiy42hluyCOWV6";
    frogstar = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKl50vqIpMXCuC9iPqa7e6eC73FgK6d2S7e5pHBm83oC";
    maintenance = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILVgW/y/c9V6UoF/7pyOG31OG8kPNWSRTTjuosvOpCim";
    eadrax-copy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICyBkHHi+RW2NpVhY0432McJ2J+OFIx6U0xGrwWNTTGW";
    bootstrap-zfs = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICyBkHHi+RW2NpVhY0432McJ2J+OFIx6U0xGrwWNTTGW";
  };

  users = {
    vod = "";
  };

  allKeys = [ hosts.NixOS ] ++ backup_keys;

in
{
  # "users/vod/authinfo.age".publicKeys = [ hosts.eadrax ] ++ backup_keys;
  "users/vod/hashedPassword.age".publicKeys = [ hosts.eadrax ] ++ backup_keys;

  "hosts/eadrax/nebula.crt.age".publicKeys = [ hosts.eadrax ] ++ backup_keys;
  "hosts/eadrax/nebula.key.age".publicKeys = [ hosts.eadrax ] ++ backup_keys;
  "hosts/eadrax/zerotier-legacy.pk.age".publicKeys = [ hosts.eadrax ] ++ backup_keys;

  "shared/wifi_EadraxHB.age".publicKeys = [
    hosts.eadrax
    hosts.frogstar
    hosts.frogstar_vm
    hosts.argabuthon
    hosts.maintenance
    hosts.eadrax-copy
  ] ++ backup_keys;
  "shared/wg-lon.age".publicKeys = [ hosts.eadrax hosts.frogstar hosts.frogstar_vm ] ++ backup_keys;
  "shared/zerotier-controller.age".publicKeys = [ hosts.frogstar ] ++ backup_keys;

  "shared/powerdns-admin-secret-key.age".publicKeys = [ hosts.frogstar ] ++ backup_keys;
  "shared/powerdns-admin-secret-salt.age".publicKeys = [ hosts.frogstar ] ++ backup_keys;

  "shared/gitea-admin.age".publicKeys = [ hosts.frogstar ] ++ backup_keys;

  "shared/cyberghost-nl/auth-user-pass.age".publicKeys = [ hosts.argabuthon ] ++ backup_keys;
  "shared/cyberghost-nl/ca.crt.age".publicKeys = [ hosts.argabuthon ] ++ backup_keys;
  "shared/cyberghost-nl/client.crt.age".publicKeys = [ hosts.argabuthon ] ++ backup_keys;
  "shared/cyberghost-nl/client.key.age".publicKeys = [ hosts.argabuthon ] ++ backup_keys;

  "containers/lan/gateway/zt-key.age".publicKeys = [ hosts.frogstar ] ++ backup_keys;
  "containers/lan/dhcp-boot-server/zt-key.age".publicKeys = [ hosts.frogstar ] ++ backup_keys;
  "containers/lan/http-boot-server/zt-key.age".publicKeys = [ hosts.frogstar ] ++ backup_keys;
  "containers/lan/tftp-boot-server/zt-key.age".publicKeys = [ hosts.frogstar ] ++ backup_keys;
  "containers/lan/powerdns-recursor/zt-key.age".publicKeys = [ hosts.frogstar ] ++ backup_keys;
}
