{ ... }:

{
  imports = [ ../../. ];
  vultr.enable = true;
  vultr.api_key = (builtins.getEnv "VULTR_API_KEY");
  vultr.dns.domains."infinidim.enterprises" = [
    {
      type = "MX";
      data = "mx.zoho.com";
      priority = 10;
      ttl = 120;
    }
    {
      type = "MX";
      data = "mx2.zoho.com";
      priority = 20;
      ttl = 120;
    }
    {
      type = "MX";
      data = "mx3.zoho.com";
      priority = 50;
      ttl = 120;
    }
    {
      type = "TXT";
      name = "selector1._domainkey";
      data = "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCGp39L02fmEDVk7h2KxM7xcRUsyYK5nlki1ZbT5WQ7gS+JiDPZ8GQKgEFYc5w71I5qPvyoSIlVBfzUtjAeF21PSrtEeqRbyyD/MZgyGliDMDnUOODZEIYN3NxxPTMDvriswwgTp89WG4h5ZHSSUx4NB5RDZGuv4RCrttXKqI6avQIDAQAB";
    }
    {
      type = "TXT";
      data = "v=spf1 include:zoho.com ~all";
    }
  ];
}
