{ lib }:
let
  inherit (lib) rakeLeaves mapAttrs;
  importLibs = mapAttrs (_: v: import v { inherit lib; });
in
(lib.makeExtensible (self: { })).extend (
  self: super:
    importLibs (rakeLeaves ./njk) //
    { build = importLibs (rakeLeaves ./build); }
)
