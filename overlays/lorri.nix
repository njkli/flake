final: prev: {
  lorri = prev.callPackage (builtins.toString final.sources.lorri.src) { pkgs = prev; };
}
