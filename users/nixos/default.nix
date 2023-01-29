{ config, hmUsers, pkgs, lib, profiles, ... }:
let
  user = builtins.baseNameOf ./.;
in

{
  imports = with profiles; [
    profiles.desktop.common
    profiles.desktop.stumpwm
    profiles.desktop.chromium-browser
    profiles.desktop.firefox-browser
    profiles.hardware.crypto
  ];

  # services.xserver.displayManager.autoLogin.user = "nixos";
  # services.xserver.displayManager.autoLogin.enable = true;
  # services.xserver.displayManager.lightdm.autoLogin.timeout = 0;
  services.xserver.displayManager.defaultSession = "stumpwm";

  home-manager.users.nixos = { suites, ... }: {
    imports = [ hmUsers.nixos ./home ]
      ++ suites.desktop;
    # ++ suites.office;
  };

  # sops.secrets."users/${user}".neededForUsers = true;

  users.users.nixos = {
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCwIsdZ2Wz2u1hyQpzDqSwk2x8kmh4Uo0w47eTVQLpIWn+zur9BjlwCWSy5xnRlnu5C8BqBhDF1dl5MeXKakIFiXRPNPtHMfeTe+Q9B0Q1cM5/ZiHM9Du9rdZ6nZRlkjB1t8ShqxVrMRKn6Ed+3yX3DJ/Ab8szxgoO4IDrnJDs4cUvGv7n4XrkESrHddeQfOuik0rZiLu1iw12cyuLQmJWpq8Q5BMHEBeGWvj68D5wHeHLhfK+ZacU8IezqUmPp+ECZLR9vhf3Kel1QZb1s9F2+RUWgbo+KPJSNxSmHJ25kji32M1eVd6cA9BoPqRFzHWISXL7CM52z5Z+E+hyeVmR2jIx9agS9iTLczTO7Hs4lEoFESPmT/FkB0YefIzy17j+8bKItCeZDfmy5M056I/kShZIPp86fM5dmH/PSKngyozKz6MrbBxJkhAlsXmhbGqmHALcy19vEYF/4mbb4gf6gLWUwsho10UvkMybQ2jpsdvGkqJg89hMqFbYKBPN9lAnRoPVlKS7SBBfnLjC9RtHduwvoYHJeXQNaGW1mNCbg1M/WmqghY4BWKTqxCPoraejtFVLjB9DepRAmQg+fZrQYq+Q+A1yHFVTwrxapIseD9Udth+kAsUKbYP3vUsFDlSdFz3U6QWH8TnhwCsRbIvOYptPmc0o3kNQ4buC/vZCP1w== openpgp:0x1F41C323" ];
    # inherit (credentials [ "defaults" "users" "admin" ] { openssh.authorizedKeys.keys = [ "CI test value" ]; }) openssh;
    shell = pkgs.zsh; # NOTE: nushell sucks!
    uid = 20000;
    hashedPassword = "$6$6LvEKHcQDfOMHIb6$JL.LY6GTN8lRattef3WLXwinXyOY1akXR9TBhsNOJIYtHbXcmH6iJ/FEwGu4r3J/ucXV2pVVcxuRkcSpMZhEA0";
    # passwordFile = config.sops.secrets."users/${user}".path;
    description = "default test user";
    isNormalUser = true;
    # openssh.authorizedKeys.keys = [ ];

    extraGroups = [
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
