{ lib, config, ... }:
with lib;
mkMerge [
  {
    services.openssh = {
      enable = mkDefault true;
      openFirewall = mkDefault true;
      allowSFTP = true;
      permitRootLogin = mkDefault "no";
      passwordAuthentication = false;
      kbdInteractiveAuthentication = false;
      forwardX11 = mkDefault true;
      extraConfig = ''
        X11UseLocalhost yes
        ClientAliveInterval 180
        TCPKeepAlive yes
        LogLevel INFO
        LoginGraceTime 120
        StrictModes yes
        IgnoreRhosts yes
        HostbasedAuthentication no
        PermitEmptyPasswords no
        PubkeyAuthentication yes
        PrintLastLog yes
        AllowAgentForwarding yes
        AcceptEnv *
      '';

      hostKeys = [
        {
          bits = 4096;
          openSSHFormat = true;
          comment = "Default - ${config.networking.hostName}";
          path = "/etc/ssh/ssh_host_rsa_key";
          rounds = 100;
          type = "rsa";
        }

        {
          bits = 4096;
          openSSHFormat = true;
          comment = "sops/age/deploy-rs - for ${config.networking.hostName}";
          path = "/etc/ssh/ssh_host_ed25519_key";
          rounds = 100;
          type = "ed25519";
        }
      ];
    };
  }

  #TODO: services.openssh.knownHosts - collect from deploy module
]
