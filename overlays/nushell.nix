final: prev: {
  nushell_gitrelease = prev.nushell.overrideAttrs (o: rec{
    inherit (final.sources.nushell) pname version src cargoSha256;
  });
}
