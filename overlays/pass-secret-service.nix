channels: final: prev: {
  pass-secret-service = channels.master.pass-secret-service;
  # FIXME: https://github.com/NixOS/nixpkgs/issues/197408#issuecomment-1291157324
  # pass-secret-service = prev.pass-secret-service.overridePythonAttrs (o: {
  #   inherit (final.sources.pass-secret-service) src version;
  #   postPatch = o.postPatch + "substituteInPlace Makefile --replace pytest-3 pytest";
  # });
}
