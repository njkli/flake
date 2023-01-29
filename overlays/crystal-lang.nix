channels: final: prev: {
  # crystal = prev.crystal_1_5_0;
  icr = prev.icr.overrideAttrs (_: {
    inherit (final.sources.icr) src version;
    shardsFile = ../pkgs/icr-shards.nix;
  });

  # TODO:
  # crystal2nix = prev.crystal2nix.overrideAttrs (_: {
  #   inherit (final.sources.crystal2nix) src version;
  #   shardsFile = ../pkgs/crystal2nix-shards.nix;
  # });

}
