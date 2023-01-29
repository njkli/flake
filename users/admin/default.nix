{ config, hmUsers, pkgs, lib, ... }:
let
  user = builtins.baseNameOf ./.;
in

{
  # services.xserver.windowManager.stumpwm-new.enable = true;

  home-manager.users.admin.imports = [
    hmUsers.admin

    ({ pkgs, ... }: {
      programs.doom-emacs.emacsPackagesOverlay = self: super: {
        copilot = self.trivialBuild {
          inherit (pkgs.sources.copilot-el) pname version src;
          ename = "copilot";
          buildInputs = [ pkgs.nodejs ];
        };

        color-rg = self.trivialBuild rec {
          inherit (pkgs.sources.color-rg) pname version src;
          ename = pname;
          buildInputs = [ pkgs.ripgrep ];
        };

      };
      # programs.doom-emacs.doomPrivateDir = pkgs.callPackage ./dotfiles/doom.d { };
    })

    ({ profiles, suites, name, ... }: {
      programs.git.userName = name;
      programs.git.userEmail = name + "@njk.local";
      programs.git.extraConfig.credential.helper = "cache";

      dconf.enable = true;
      dconf.settings = {
        "org/mate/desktop/session".idle-delay = 15;
        "org/mate/screensaver".mode = "blank-only";
        "org/gtk/settings/file-chooser".sort-directories-first = true;
        "org/mate/desktop/peripherals/mouse".motion-acceleration = 7;
        "org/mate/desktop/interface".window-scaling-factor = 1;
      };

      imports = with profiles; suites.base ++ [
        # emacs
        # developer.direnv
        # developer.nix
        # developer.git
        shell.screen
        shell.zsh
        shell.cli-tools
        look-and-feel.starship-prompt
      ];
    })
  ];

  # services.xserver.desktopManager.xfce.enable = true;
  # services.xserver.desktopManager.xfce.thunarPlugins = with pkgs.xfce; [ thunar-archive-plugin thunar-media-tags-plugin ];

  # services.xserver.desktopManager.cde.enable = true;
  # services.xserver.desktopManager.cde.extraPackages = with pkgs.xorg; [
  #   xclock bitmap xlsfonts xfd xrefresh xload xwininfo xdpyinfo xwd xwud
  # ];

  users.users.admin = {
    # FIXME: switch to using age instead of credentials mod
    # inherit (credentials [ "defaults" "users" "admin" ] { openssh.authorizedKeys.keys = [ "CI test value" ]; }) openssh;
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCwIsdZ2Wz2u1hyQpzDqSwk2x8kmh4Uo0w47eTVQLpIWn+zur9BjlwCWSy5xnRlnu5C8BqBhDF1dl5MeXKakIFiXRPNPtHMfeTe+Q9B0Q1cM5/ZiHM9Du9rdZ6nZRlkjB1t8ShqxVrMRKn6Ed+3yX3DJ/Ab8szxgoO4IDrnJDs4cUvGv7n4XrkESrHddeQfOuik0rZiLu1iw12cyuLQmJWpq8Q5BMHEBeGWvj68D5wHeHLhfK+ZacU8IezqUmPp+ECZLR9vhf3Kel1QZb1s9F2+RUWgbo+KPJSNxSmHJ25kji32M1eVd6cA9BoPqRFzHWISXL7CM52z5Z+E+hyeVmR2jIx9agS9iTLczTO7Hs4lEoFESPmT/FkB0YefIzy17j+8bKItCeZDfmy5M056I/kShZIPp86fM5dmH/PSKngyozKz6MrbBxJkhAlsXmhbGqmHALcy19vEYF/4mbb4gf6gLWUwsho10UvkMybQ2jpsdvGkqJg89hMqFbYKBPN9lAnRoPVlKS7SBBfnLjC9RtHduwvoYHJeXQNaGW1mNCbg1M/WmqghY4BWKTqxCPoraejtFVLjB9DepRAmQg+fZrQYq+Q+A1yHFVTwrxapIseD9Udth+kAsUKbYP3vUsFDlSdFz3U6QWH8TnhwCsRbIvOYptPmc0o3kNQ4buC/vZCP1w== openpgp:0x1F41C323" ];
    shell = pkgs.zsh;
    uid = 10000;
    hashedPassword = "$6$DT4UrKIPEsfx$gAdX.dQQhn8nGqxneII.HOvDVYuiyoMv3pr9m.F5VlM7KLyxafNTJNIt9shbIFG5wxI2IGWcYz2iX1SnLD8TL0";
    # TODO: passwordFile = config.sops.secrets."users/${user}".path;
    description = "Admin";
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
