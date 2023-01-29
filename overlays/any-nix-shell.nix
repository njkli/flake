final: prev: {
  any-nix-shell = prev.any-nix-shell.overrideAttrs
    (_: {
      inherit (final.sources.any-nix-shell) src version;
    });
}
