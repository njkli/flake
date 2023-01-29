final: prev: {
  nix-zsh-completions = prev.nix-zsh-completions.overrideAttrs (_: rec {
    inherit (final.sources.nix-zsh-completions) src version;
  });
}
