final: prev: {
  system-config-printer = prev.system-config-printer.overrideAttrs (o:
    {
      postInstall = o.postInstall + "\nrm -rf $out/etc/systemd";
    });
}
