{ profiles, ... }:

{
  imports = with profiles; [
    hardware.chuwi
    desktop.remote-display-client
  ];

  deploy.enable = true;
  deploy.params.hiDpi = true;
  deploy.params.lan.mac = "16:07:77:0a:aa:ff";
  deploy.params.lan.ipv4 = "10.11.1.43/24";
  deploy.node.hostname = "10.11.1.43";
  deploy.node.fastConnection = true;
  deploy.node.sshUser = "admin";

  deploy.params.lan.dhcpClient = false;
  systemd.network.networks.lan = {
    addresses = [{ addressConfig.Address = "10.11.1.43/24"; }];
    networkConfig.Gateway = "10.11.1.254";
    dns = [ "8.8.8.8" ];
  };

  networking.hostName = "folfanga-3";
  networking.hostId = "d6a42d2a";

  services.xserver.remote-display.client.screens = [
    {
      id.vnc = "FOLFANGA3UP";
      id.xrandr = "HDMI2";
      port = 65511;
      size.x = "1920";
      size.y = 1080;
      pos.x = 0;
      pos.y = "0";
      xrandrExtraOpts = "--primary";
    }

    {
      id.vnc = "FOLFANGA3DOWN";
      id.xrandr = "DSI1";
      xrandrExtraOpts = "--rotate right";
      port = "65512";
      size.x = "1920";
      size.y = "1200";
      pos.x = "0";
      pos.y = "1080";
    }
  ];
}
