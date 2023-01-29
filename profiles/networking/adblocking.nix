{ lib, pkgs, ... }:
let
  all_filters = [
    # NOTE:  https://github.com/AdguardTeam/AdguardFilters
    "https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt"
    "https://adaway.org/hosts.txt"
    "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-social/hosts"

    "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/RussianFilter/sections/specific.txt"
    "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/RussianFilter/sections/adservers.txt"
    "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/RussianFilter/sections/adservers_firstparty.txt"
    "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/RussianFilter/sections/antiadblock.txt"
    "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/RussianFilter/sections/css_extended.txt"
    "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/RussianFilter/sections/general_elemhide.txt"
    "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/RussianFilter/sections/general_extensions.txt"
    "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/RussianFilter/sections/general_url.txt"
    "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/RussianFilter/sections/news_exchange.txt"

    "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/AnnoyancesFilter/Cookies/sections/cookies_specific.txt"
    "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/AnnoyancesFilter/Cookies/sections/cookies_general.txt"
    "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/AnnoyancesFilter/Cookies/sections/cookies_allowlist.txt"
    "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/AnnoyancesFilter/MobileApp/sections/mobile-app_allowlist.txt"
    "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/AnnoyancesFilter/MobileApp/sections/mobile-app_general.txt"
    "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/AnnoyancesFilter/MobileApp/sections/mobile-app_specific.txt"
    "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/AnnoyancesFilter/Other/sections/annoyances.txt"
    "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/AnnoyancesFilter/Other/sections/self-promo.txt"
    "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/AnnoyancesFilter/Other/sections/tweaks.txt"
    "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/AnnoyancesFilter/Popups/sections/antiadblock.txt"
    "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/AnnoyancesFilter/Popups/sections/popups_allowlist.txt"
    "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/AnnoyancesFilter/Popups/sections/popups_general.txt"
    "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/AnnoyancesFilter/Popups/sections/popups_specific.txt"
    "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/AnnoyancesFilter/Popups/sections/push-notifications_allowlist.txt"
    "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/AnnoyancesFilter/Popups/sections/push-notifications_general.txt"
    "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/AnnoyancesFilter/Popups/sections/push-notifications_specific.txt"
    "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/AnnoyancesFilter/Popups/sections/subscriptions_allowlist.txt"
    "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/AnnoyancesFilter/Popups/sections/subscriptions_general.txt"
    "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/AnnoyancesFilter/Popups/sections/subscriptions_specific.txt"
    "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/AnnoyancesFilter/Widgets/sections/widgets.txt"

    "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/SpywareFilter/sections/cname_trackers.txt"
    "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/SpywareFilter/sections/cookies.txt"
    "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/SpywareFilter/sections/css_extended.txt"
    "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/SpywareFilter/sections/general_elemhide.txt"
    "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/SpywareFilter/sections/general_extensions.txt"
    "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/SpywareFilter/sections/general_url.txt"
    "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/SpywareFilter/sections/mobile.txt"
    "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/SpywareFilter/sections/mobile_allowlist.txt"
    "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/SpywareFilter/sections/specific.txt"
    "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/SpywareFilter/sections/tracking_servers.txt"
    "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/SpywareFilter/sections/tracking_servers_firstparty.txt"
  ];

  filters = with lib; imap1 (counter: v: { enabled = true; id = counter; url = v; name = "filter_${toString counter}"; }) all_filters;
in
{
  # networking.extraHosts = lib.readFile "${pkgs.sources.StevenBlack-hosts.src}/alternates/fakenews-gambling-porn-social/hosts";

  services.adguardhome.enable = true;
  services.adguardhome.host = "127.0.0.1";
  services.adguardhome.port = 8888;
  services.adguardhome.mutableSettings = false;
  services.adguardhome.settings = {

    bind_host = "127.0.0.1";
    bind_port = 8888;

    auth_attempts = 5;
    beta_bind_port = 0;
    block_auth_min = 15;
    clients = { persistent = [ ]; runtime_sources = { arp = true; dhcp = true; hosts = true; rdns = true; whois = true; }; };
    debug_pprof = false;
    dhcp = {
      dhcpv4 = { gateway_ip = ""; icmp_timeout_msec = 1000; lease_duration = 86400; options = [ ]; range_end = ""; range_start = ""; subnet_mask = ""; };
      dhcpv6 = { lease_duration = 86400; ra_allow_slaac = false; ra_slaac_only = false; range_start = ""; };
      enabled = false;
      interface_name = "";
      local_domain_name = "lan";
    };

    dns = {
      aaaa_disabled = true;
      all_servers = false;
      allowed_clients = [ ];
      anonymize_client_ip = false;
      bind_hosts = [ "127.0.0.1" ];
      blocked_hosts = [ "version.bind" "id.server" "hostname.bind" ];
      blocked_response_ttl = 10;
      blocked_services = [ ];
      blocking_ipv4 = "";
      blocking_ipv6 = "";
      blocking_mode = "default";
      bogus_nxdomain = [ ];
      bootstrap_dns = [ "9.9.9.10" "149.112.112.10" "2620:fe::10" "2620:fe::fe:10" ];
      cache_optimistic = false;
      cache_size = 4194304;
      cache_time = 30;
      cache_ttl_max = 0;
      cache_ttl_min = 0;
      disallowed_clients = [ ];
      edns_client_subnet = false;
      enable_dnssec = false;
      fastest_addr = false;
      fastest_timeout = "1s";
      filtering_enabled = true;
      filters_update_interval = 24;
      ipset = [ ];
      local_ptr_upstreams = [ ];
      max_goroutines = 300;
      parental_block_host = "family-block.dns.adguard.com";
      parental_cache_size = 1048576;
      parental_enabled = false;
      port = 53;
      private_networks = [ ];
      protection_enabled = true;
      querylog_enabled = true;
      querylog_file_enabled = true;
      querylog_interval = "2160h";
      querylog_size_memory = 1000;
      ratelimit = 0;
      ratelimit_whitelist = [ ];
      refuse_any = true;
      rewrites = [ ];
      safebrowsing_block_host = "standard-block.dns.adguard.com";
      safebrowsing_cache_size = 1048576;
      safebrowsing_enabled = false;
      safesearch_cache_size = 1048576;
      safesearch_enabled = false;
      statistics_interval = 90;
      trusted_proxies = [ "127.0.0.0/8" "::1/128" ];
      upstream_dns = [ "https://dns10.quad9.net/dns-query" ];
      upstream_dns_file = "";
      upstream_timeout = "10s";
      use_private_ptr_resolvers = true;
    };

    inherit filters;

    http_proxy = "";
    language = "";
    log_compress = false;
    log_file = "";
    log_localtime = false;
    log_max_age = 3;
    log_max_backups = 0;
    log_max_size = 100;
    os = { group = ""; rlimit_nofile = 0; user = ""; };
    schema_version = 14;
    tls = {
      allow_unencrypted_doh = false;
      certificate_chain = "";
      certificate_path = "";
      dnscrypt_config_file = "";
      enabled = false;
      force_https = false;
      port_dns_over_quic = 853;
      port_dns_over_tls = 853;
      port_dnscrypt = 0;
      port_https = 443;
      private_key = "";
      private_key_path = "";
      server_name = "";
      strict_sni_check = false;
    };
    user_rules = [ "@@||web.whatsapp.com^$important" "@@||cache.nixos.org^$important" ];
    users = [{ name = "admin"; password = "$2y$05$n1jeESbnw1MsGKsqd9BiSO.GztmN5/RYO3jK.BHHhmdaoi5ZXhngW"; }];
    verbose = false;
    web_session_ttl = 720;
    whitelist_filters = [ ];
  };

}