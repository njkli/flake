{ self, config, hmUsers, pkgs, lib, profiles, ... }:
let
  user = builtins.baseNameOf ./.;
in

{
  imports = [
    profiles.desktop.xdmcp
    profiles.desktop.common
    profiles.desktop.stumpwm
    profiles.desktop.chromium-browser
    profiles.desktop.firefox-browser
    profiles.hardware.crypto
    profiles.core.age-secrets

    # profiles.legacy.admin-machine
  ];
  # This replaces gnome-keyring and uses pass!
  # TODO: Namespace the module as gnome-keyring, modules/services/desktops/
  services.pass-secret-service.enable = true;

  # for kdeconnect and such
  services.zerotierone.joinNetworks = [{ "a84ac5c10a162ba4" = "mobiles"; }];
  networking.firewall.interfaces.mobiles.allowedUDPPorts = [ 139 445 ];
  networking.firewall.interfaces.mobiles.allowedTCPPorts = [ 137 138 ];


  nix.gc.automatic = false;
  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    # "armv6l-linux"
    # "armv7l-linux"
  ];

  environment.systemPackages = with pkgs; [ ventoy-bin-full ntp ];

  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark;

  home-manager.users.vod.imports = [ hmUsers.vod ./home ];

  # age.secrets."${user}.passwd".file = "${self}/secrets/users/${user}/hashedPassword.age";
  # NOTE/FIXME: emacs var auth-sources accepts authinfo.gpg
  #
  # age.secrets."${user}.home.authinfo" = {
  #   file = "${self}/secrets/users/${user}/authinfo.age";
  #   mode = "0400";
  #   owner = user;
  #   group = "users";
  #   path = "${config.users.users.vod.home}/.authinfo";
  # };

  users.users.vod = {
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCwIsdZ2Wz2u1hyQpzDqSwk2x8kmh4Uo0w47eTVQLpIWn+zur9BjlwCWSy5xnRlnu5C8BqBhDF1dl5MeXKakIFiXRPNPtHMfeTe+Q9B0Q1cM5/ZiHM9Du9rdZ6nZRlkjB1t8ShqxVrMRKn6Ed+3yX3DJ/Ab8szxgoO4IDrnJDs4cUvGv7n4XrkESrHddeQfOuik0rZiLu1iw12cyuLQmJWpq8Q5BMHEBeGWvj68D5wHeHLhfK+ZacU8IezqUmPp+ECZLR9vhf3Kel1QZb1s9F2+RUWgbo+KPJSNxSmHJ25kji32M1eVd6cA9BoPqRFzHWISXL7CM52z5Z+E+hyeVmR2jIx9agS9iTLczTO7Hs4lEoFESPmT/FkB0YefIzy17j+8bKItCeZDfmy5M056I/kShZIPp86fM5dmH/PSKngyozKz6MrbBxJkhAlsXmhbGqmHALcy19vEYF/4mbb4gf6gLWUwsho10UvkMybQ2jpsdvGkqJg89hMqFbYKBPN9lAnRoPVlKS7SBBfnLjC9RtHduwvoYHJeXQNaGW1mNCbg1M/WmqghY4BWKTqxCPoraejtFVLjB9DepRAmQg+fZrQYq+Q+A1yHFVTwrxapIseD9Udth+kAsUKbYP3vUsFDlSdFz3U6QWH8TnhwCsRbIvOYptPmc0o3kNQ4buC/vZCP1w== openpgp:0x1F41C323" ];
    shell = pkgs.zsh;
    uid = 1000;
    hashedPassword = "$6$VsWUQCau32Oa$tNiMK5LftcuYDRPeACeP/BLikr7tYps/MHDeF3GT0bNRvyEW3PgIXXMzBY5x.FvGO6NprwhDldeFeKBzVQuhI1";
    # passwordFile = config.age.secrets."${user}.passwd".path;
    description = "Никто кроме нас";
    isNormalUser = true;

    extraGroups = [
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
