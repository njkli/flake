{ lib, ... }:
{
  nix.settings.system-features = [ "nixos-test" "benchmark" "big-parallel" "kvm" "recursive-nix" ];
  nix.settings.auto-optimise-store = true;
  nix.gc.automatic = lib.mkDefault true;
  nix.optimise.automatic = true;
  nix.settings.sandbox = true;
  nix.settings.allowed-users = [ "@wheel" ];
  nix.settings.trusted-users = [ "root" "@wheel" ];
  nix.extraOptions = ''
    min-free = 536870912
    keep-outputs = true
    keep-derivations = true
    fallback = true
    experimental-features = recursive-nix
  '';
}
