{ profiles, ... }:

{
  imports = with profiles; [
    hardware.chuwi
    desktop.remote-display-client
  ];

  deploy.enable = true;
  deploy.params.hiDpi = true;
  deploy.params.lan.mac = "16:07:77:07:aa:ff";
  deploy.params.lan.ipv4 = "10.11.1.42/24";
  deploy.node.hostname = "10.11.1.42";
  deploy.node.fastConnection = true;
  deploy.node.sshUser = "admin";

  deploy.params.lan.dhcpClient = false;
  systemd.network.networks.lan = {
    addresses = [{ addressConfig.Address = "10.11.1.42/24"; }];
    networkConfig.Gateway = "10.11.1.254";
    dns = [ "8.8.8.8" ];
  };

  networking.hostName = "folfanga-2";
  networking.hostId = "90c16bf3";

  services.xserver.remote-display.client.screens = [
    {
      id.vnc = "FOLFANGA2";
      id.xrandr = "DSI1";
      xrandrExtraOpts = "--rotate right";
      port = "65512";
      size.x = "1920";
      size.y = "1200";
      pos.x = "0";
      pos.y = "0";
    }
  ];
}
