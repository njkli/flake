# NOTE: This works for now, let's see how much needs to get customized.
# FIXME: nyxt
channels: final: prev:
let
  nyxtLisp = channels.master.lispPackages.nyxt.overrideAttrs (o: {
    inherit (final.sources.nyxt) src version;
    meta = o.meta // { inherit (final.sources.nyxt) version; };
  });

  gstBuildInputs = with channels.master.gst_all_1; [
    gstreamer
    gst-libav
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
  ];

  GST_PLUGIN_SYSTEM_PATH_1_0 = prev.lib.concatMapStringsSep ":" (p: "${p}/lib/gstreamer-1.0") gstBuildInputs;
in

{
  # nyxt = channels.master.nyxt.overrideAttrs (_: {
  #   src = nyxtLisp;
  #   inherit (nyxtLisp.meta) version;

  #   # BUG: https://github.com/atlas-engineer/nyxt/issues/1781
  #   # FIXME/ISSUE: https://github.com/NixOS/nixpkgs/issues/158005

  #   installPhase = ''
  #     mkdir -p $out/share/applications/
  #     sed "s/VERSION/$version/" $src/lib/common-lisp/nyxt/assets/nyxt.desktop > $out/share/applications/nyxt.desktop
  #     for i in 16 32 128 256 512; do
  #       mkdir -p "$out/share/icons/hicolor/''${i}x''${i}/apps/"
  #       cp -f $src/lib/common-lisp/nyxt/assets/nyxt_''${i}x''${i}.png "$out/share/icons/hicolor/''${i}x''${i}/apps/nyxt.png"
  #     done

  #     mkdir -p $out/bin && makeWrapper $src/bin/nyxt $out/bin/nyxt \
  #       --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "${GST_PLUGIN_SYSTEM_PATH_1_0}" \
  #       --set WEBKIT_FORCE_SANDBOX 0 \
  #       --argv0 nyxt "''${gappsWrapperArgs[@]}"
  #   '';
  # });
}
