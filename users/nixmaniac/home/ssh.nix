{ pkgs, lib, name, osConfig, ... }:
with lib;
let
  defaults = { identityFile = "~/.ssh/id_rsa.pub"; };
  defaults_git = { user = "git"; } // defaults;
  defaults_njk = { user = "admin"; forwardAgent = true; } // defaults;
  defaults_njk_gitea = { user = "gitea"; } // defaults;
in
mkMerge [
  {
    programs.ssh = {
      enable = true;
      compression = true;
      serverAliveInterval = 15;
      extraOptionOverrides = {
        StrictHostKeyChecking = "no";
        IdentitiesOnly = "no";
      };

      matchBlocks = {
        "git.0a.njk.li" = defaults_njk_gitea;
        "*.0a.njk.li" = defaults_njk;
        "*.0.njk.li" = defaults_njk;
        "nowhat* nowhat*.0*.njk.li".port = 65522;
        "maintenance* maintenance*.0*.njk.li".port = 65522;
        "kakrafoon* kakrafoon*.0*.njk.li".port = 65522;
        "bitbucket.org" = defaults_git;
        "github.com" = defaults_git;
      };
    };
  }
  (mkIf ((length osConfig.users.users.${name}.openssh.authorizedKeys.keys) > 0) {
    home.file.".ssh/id_rsa.pub".text = head osConfig.users.users.${name}.openssh.authorizedKeys.keys;
  })
]
