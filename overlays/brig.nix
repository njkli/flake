final: prev: {
  # brig =
  #   if final.lib.versionAtLeast prev.brig.version "0.5.0"
  #   then builtins.trace "pkgs.brig: overlay expired" prev.brig
  #   else
  #     (final.buildGoModule {
  #       name = "brig-${final.sources.brig.version}";
  #       inherit (prev.brig) doCheck meta;
  #       inherit (final.sources.brig) pname src version vendorSha256;
  #     });
}
