# final: prev: {
#   nix-linter = prev.nix-linter.overrideAttrs (_: {
#     inherit (final.sources.nix-linter) pname version src;
#   });
# }
_: _: { }
