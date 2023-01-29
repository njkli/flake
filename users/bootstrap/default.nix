{ pkgs, lib, ... }:
let inherit (lib) mkAfter fileContents;inherit (pkgs) writeText; in
{
  # boot.kernelParams = mkAfter [ "console=ttyS0" ];

  programs.zsh.enable = true;
  programs.zsh.promptInit = ''
    eval "$(${pkgs.starship}/bin/starship init zsh)"
  '';

  environment.shellInit = ''
    export STARSHIP_CONFIG=${
      writeText "starship.toml"
      (fileContents ./starship.toml)
    }
  '';

  users.users.bootstrap = {
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCwIsdZ2Wz2u1hyQpzDqSwk2x8kmh4Uo0w47eTVQLpIWn+zur9BjlwCWSy5xnRlnu5C8BqBhDF1dl5MeXKakIFiXRPNPtHMfeTe+Q9B0Q1cM5/ZiHM9Du9rdZ6nZRlkjB1t8ShqxVrMRKn6Ed+3yX3DJ/Ab8szxgoO4IDrnJDs4cUvGv7n4XrkESrHddeQfOuik0rZiLu1iw12cyuLQmJWpq8Q5BMHEBeGWvj68D5wHeHLhfK+ZacU8IezqUmPp+ECZLR9vhf3Kel1QZb1s9F2+RUWgbo+KPJSNxSmHJ25kji32M1eVd6cA9BoPqRFzHWISXL7CM52z5Z+E+hyeVmR2jIx9agS9iTLczTO7Hs4lEoFESPmT/FkB0YefIzy17j+8bKItCeZDfmy5M056I/kShZIPp86fM5dmH/PSKngyozKz6MrbBxJkhAlsXmhbGqmHALcy19vEYF/4mbb4gf6gLWUwsho10UvkMybQ2jpsdvGkqJg89hMqFbYKBPN9lAnRoPVlKS7SBBfnLjC9RtHduwvoYHJeXQNaGW1mNCbg1M/WmqghY4BWKTqxCPoraejtFVLjB9DepRAmQg+fZrQYq+Q+A1yHFVTwrxapIseD9Udth+kAsUKbYP3vUsFDlSdFz3U6QWH8TnhwCsRbIvOYptPmc0o3kNQ4buC/vZCP1w== openpgp:0x1F41C323" ];
    shell = pkgs.zsh;
    uid = 11000;
    hashedPassword = "$6$F9Ng9.HV.f/qvOfV$uRRVYjoyEJgadp6kW7Qmt9uptJ9a2BNVmhLRRZmQy/e0EYMwdcoKcAyoMXid2SZvXtgyjUHJSCCyYqxEQ6r6s/";
    description = "bootstrap";
    isNormalUser = true;

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
