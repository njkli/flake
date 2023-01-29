{ self, ... }:
{
  imports = self.lib.importFolder ./.;
  nix.settings.substituters = [ "https://cache.nixos.org/" ];
}
