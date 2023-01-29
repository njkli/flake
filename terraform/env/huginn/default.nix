{ ... }:

{
  imports = [ ../../config_terranix.nix ];
  vultr.enable = true;
  vultr.api_key = "shittything";
  vultr.dns.domains."pazuzu.com" = [{
    type = "A";
    name = "fuck";
    data = "192.11.11.1";
  }];

  provider.digitalocean.token = "some_shit";
}
