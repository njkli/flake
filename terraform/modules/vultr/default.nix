{ config, lib, pkgs, ... }:
with lib;
with builtins;
let
  cfg = config.vultr;
  sanitize = _:
    # NOTE: Resource names must start with a letter or underscore
    # and may contain only letters, digits, underscores, and dashes.
    # https://www.terraform.io/language/resources/syntax
    let
      charset = "abcdefghijklmnopqrstuvxyz-_0123456789";
      allowed = unique (stringToCharacters (charset + (toUpper charset)));
    in
    concatStrings (map (e: if elem e allowed then e else "_") (stringToCharacters _));
  recID_tf = { domain, counter }:
    "_" + (sanitize domain) + "_record_" + (toString counter);

  provisioner_script = pkgs.writeShellScript "vultr_dns_provisioner" (readFile ./vultr_dns_provisioner.sh);
  provisioner = dom: [
    {
      local-exec = [
        {
          # NOTE: runs on create only!
          command = "${provisioner_script} create ${dom}";
          interpreter = [ "bash" "-c" ];
        }
      ];
    }

    {
      local-exec = [
        {
          # NOTE: runs on destroy only!
          when = "destroy";
          command = "${provisioner_script} destroy ${dom}";
          interpreter = [ "bash" "-c" ];
        }
      ];
    }
  ];

  record_opts = with types; { ... }: {
    options = {
      priority = mkOption {
        description = "for MX/SRV records";
        default = null;
        type = nullOr int;
      };
      ttl = mkOption {
        description = "ttl";
        default = 120;
        type = int;
      };
      type = mkOption {
        description = "type";
        type = enum [ "A" "AAAA" "CNAME" "NS" "MX" "SRV" "TXT" "CAA" "SSHFP" ];
      };
      name = mkOption {
        default = null; # vultr api hack
        description = "name";
        type = nullOr str;
        apply = _: if isNull _ then "" else _;
      };
      data = mkOption {
        description = "data";
        type = str;
      };
    };
  };

in
{
  options.vultr = with types; {
    enable = mkEnableOption "vultr dns support";
    api_key = mkOption {
      description = "api key";
      type = str;
    };

    dns = {
      domains = mkOption {
        description = "Configured domains";
        type = attrsOf (listOf (submodule [ record_opts ]));
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      provider.vultr.api_key = cfg.api_key;
      provider.vultr.rate_limit = 3000; # 3 sec.
      provider.vultr.retry_limit = 5;

      resource.vultr_dns_domain = mapAttrs'
        (domain: _: nameValuePair (sanitize domain) {
          # TODO: vultr dns server_ip is no longer required in v2 API
          inherit domain;
          ip = "127.0.0.1";
          dns_sec = "enabled";
          provisioner = provisioner domain;
        })
        cfg.dns.domains;

      resource.vultr_dns_record =
        let
          doms = map
            (domain: (imap0
              (counter: record: nameValuePair (recID_tf { inherit domain counter; }) (record // {
                inherit domain;
                depends_on = [ "vultr_dns_domain.${sanitize domain}" ];
                data = if elem record.type [ "TXT" ] then ("\"" + record.data + "\"") else record.data;
              }))
              cfg.dns.domains."${domain}"))
            (attrNames cfg.dns.domains);
        in
        listToAttrs (flatten doms);
    })
  ];
}
