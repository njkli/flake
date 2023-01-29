final: prev: {
  # numix-solarized-gtk-theme-bin = prev.stdenv.mkDerivation rec {
  #   inherit (final.sources.numix-solarized-gtk-theme-bin) src version pname;
  #   nativeBuildInputs = [ prev.gnutar ];
  #   phases = [ "installPhase" ];
  #   installPhase = ''
  #     unpackDir="$TMPDIR/unpack"
  #     mkdir -p "$unpackDir" "$out/share/themes"
  #     cd "$unpackDir"
  #     tar xzf "$src"
  #     cp -r $unpackDir/NumixSolarized/* $out/share/themes
  #   '';
  # };

  numix-solarized-gtk-theme =
    prev.numix-solarized-gtk-theme.overrideAttrs (_: {
      inherit (final.sources.numix-solarized-gtk-theme-git)
        src
        version;
    });

}
