{ ... }:

{
  imports = [ ../../. ];

  terraform.cloud = {
    organization = "njk";
    workspaces.name = "gencfg";
  };

  # data.terraform_remote_state.active_config = {
  #   backend = "remote";
  #   config = {
  #     organization = "njk";
  #     workspaces.name = "gencfg";
  #   };
  # };

  vultr.enable = true;
  vultr.api_key = (builtins.getEnv "VULTR_API_KEY");
  vultr.dns.domains."njk.li" = [
    {
      type = "MX";
      data = "mx.yandex.net";
      priority = 10;
      ttl = 120;
    }

    {
      type = "TXT";
      name = "mail._domainkey";
      data = "v=DKIM1; k=rsa; t=s; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDTFDmn04t0CCYlHvxJ4vuttPPP4XamEl0DRplBriTr0SmsGir50teOjz65DtJycJFwBRz9gbZwt7ozUttLBr6CtdgLi/1IgAcTfgA/I5F6RiIUteVWKJtEi7ltok/sTmklpmEPd3/m/ZYP0CYpDX0IEni+1ErV4Zgagt0r3IM9XQIDAQAB";
    }

    {
      type = "TXT";
      data = "v=spf1 redirect=_spf.yandex.net";
    }

    {
      type = "CNAME";
      name = "mail";
      data = "domain.mail.yandex.net";
    }
  ];
}
