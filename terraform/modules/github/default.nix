{ config, lib, ... }:
with lib;
let cfg = config.github; in
{
  options.github = with types; {
    enable = mkEnableOption "github support";
    token = mkOption { description = "Personal access token"; type = str; };
    owner = mkOption { description = "Organization or user"; type = str; };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      terraform.required_providers.github.source = "integrations/github";
      provider.github.token = cfg.token;
      provider.github.owner = cfg.owner;
    })
  ];

}
