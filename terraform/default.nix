let
  inherit (with builtins; getFlake (toPath ../.)) lib inputs;
  inherit (lib) importFolder;
  localLib = lib.extend (_: _: {
    inherit (inputs.digga.lib)
      flattenTree
      mergeAny
      rakeLeaves;
  });
in
{ imports = [{ _module.args = { inherit localLib; }; }] ++ importFolder ./modules; }
