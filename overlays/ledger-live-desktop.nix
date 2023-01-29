final: prev: {
  ledger-live-desktop = prev.callPackage
    ({ appimageTools, imagemagick, systemd }:
      let
        inherit (final.sources.ledger-live-desktop) pname version src;
        appimageContents = appimageTools.extractType2 {
          inherit pname version src;
        };
        systemdPatched = systemd.overrideAttrs ({ patches ? [ ], ... }: {
          patches = patches ++ [ ./ledger-live-desktop-systemd.patch ];
        });
      in
      appimageTools.wrapType2 rec {
        inherit pname version src;

        extraPkgs = pkgs: [ systemdPatched ];

        extraInstallCommands = ''
          mv $out/bin/${pname}-${version} $out/bin/${pname}
          install -m 444 -D ${appimageContents}/ledger-live-desktop.desktop $out/share/applications/ledger-live-desktop.desktop
          install -m 444 -D ${appimageContents}/ledger-live-desktop.png $out/share/icons/hicolor/1024x1024/apps/ledger-live-desktop.png
          ${imagemagick}/bin/convert ${appimageContents}/ledger-live-desktop.png -resize 512x512 ledger-live-desktop_512.png
          install -m 444 -D ledger-live-desktop_512.png $out/share/icons/hicolor/512x512/apps/ledger-live-desktop.png
          substituteInPlace $out/share/applications/ledger-live-desktop.desktop \
            --replace 'Exec=AppRun' 'Exec=${pname}'
        '';
      }

    )
    { };
}
