final: prev: {
  pam_u2f =
    if final.lib.versionAtLeast prev.pam_u2f.version "1.2.1"
    then builtins.trace "pkgs.pam_u2f: overlay expired" prev.pam_u2f
    else
      (prev.pam_u2f.overrideAttrs (_: { inherit (final.sources.pam_u2f) src version; }));
}
