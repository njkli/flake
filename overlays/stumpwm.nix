final: prev:
let
  build-with-compile-into-pwd = attrs:
    with final.lib;
    let
      args = attrs // { lisp = "${prev.sbcl}/bin/sbcl --script"; pname = args.baseName; };

      build = (prev.lispPackages_new.build-asdf-system (args // { version = args.version + "-build"; })).overrideAttrs (o: {
        buildPhase = with builtins; ''
          mkdir __fasls
          export LD_LIBRARY_PATH=${makeLibraryPath o.nativeLibs}:$LD_LIBRARY_PATH
          export CLASSPATH=${makeSearchPath "share/java/*" o.javaLibs}:$CLASSPATH
          export CL_SOURCE_REGISTRY=$CL_SOURCE_REGISTRY:$(pwd)//
          export ASDF_OUTPUT_TRANSLATIONS="$(pwd):$(pwd)/__fasls:${storeDir}:${storeDir}"
          ${o.lisp} ${o.buildScript}
        '';
        installPhase = ''
          mkdir -pv $out
          rm -rf __fasls
          cp -r * $out
        '';
      });
    in
    prev.lispPackages_new.build-asdf-system (args // {
      # Patches are already applied in `build`
      patches = [ ];
      src = build;
    });

  trivialBuild = args@{ baseName, ... }: prev.lispPackages.buildLispPackage ({
    inherit baseName;
    description = baseName;
    packageName = baseName;
    buildSystems = [ baseName ];
    asdFilesToKeep = [ "${baseName}.asd" ];
  } // (builtins.removeAttrs args [ "pname" ]));

  clPkgs = [ "cl-hash-util" ];
  allClPkgs =
    with final.lib;
    with builtins; listToAttrs
      (p:
        nameValuePair p (trivialBuild { inherit (final.sources.${p}) src pname version; baseName = pname; deps = [ ]; }))
      clPkgs;

  cl-hash-util = trivialBuild rec {
    inherit (final.sources.cl-hash-util) src pname version;
    baseName = pname;
    deps = [ ];
  };

  cl-strings = trivialBuild rec {
    inherit (final.sources.cl-strings) src pname version;
    baseName = pname;
    deps = [ ];
  };

  cl-shellwords = trivialBuild rec {
    inherit (final.sources.cl-shellwords) src pname version;
    baseName = pname;
    deps = [ prev.lispPackages.cl-ppcre ];
    parasites = [ "cl-shellwords-test" ];
  };

  listopia = trivialBuild rec {
    inherit (final.sources.listopia) src pname version;
    baseName = pname;
    deps = [ ];
    parasites = [ "listopia-test" ];
  };

  acl-compat = trivialBuild rec {
    inherit (final.sources.acl-compat) src pname version;
    baseName = pname;
    deps = with prev.lispPackages; [ puri cl-ppcre ironclad cl-fad ];
    overrides = p: { postUnpack = "src=$src/acl-compat"; };
  };

  cl-syslog' = trivialBuild rec {
    inherit (final.sources.cl-syslog) src pname version;
    baseName = pname;
    deps = [ prev.lispPackages.cffi ];
  };

  log4cl' = prev.lispPackages.log4cl.overrideAttrs (drv: {
    nativeBuildInputs = [ cl-syslog' ];
  });

  slynk = trivialBuild rec {
    inherit (final.emacsPgtkNativeComp.pkgs.sly) version src;
    baseName = "slynk";
    deps = with prev.lispPackages; [ bordeaux-threads ];
    overrides = p: { postUnpack = "src=$src/slynk"; };
    buildSystems = [
      "slynk"
      "slynk/mrepl"
      "slynk/arglists"
      "slynk/package-fu"
      "slynk/stickers"
      "slynk/indentation"
      "slynk/retro"
      "slynk/fancy-inspector"
      "slynk/trace-dialog"
      "slynk/profiler"
    ];
  };

  slynk-quicklisp = trivialBuild rec {
    pname = baseName;
    baseName = "slynk-quicklisp";
    deps = [
      slynk
      prev.lispPackages.quicklisp
    ];
    inherit (final.emacsPgtkNativeComp.pkgs.sly-quicklisp) src version;
  };

  slynk-asdf = trivialBuild rec {
    baseName = "slynk-asdf";
    deps = [ slynk ];
    inherit (final.emacsPgtkNativeComp.pkgs.sly-asdf) src version;
  };

  slynk-named-readtables = trivialBuild rec {
    baseName = "slynk-named-readtables";
    deps = [ slynk ];
    inherit (final.emacsPgtkNativeComp.pkgs.sly-named-readtables) src version;
  };

  slynk-macrostep = trivialBuild rec {
    baseName = "slynk-macrostep";
    deps = [ slynk ];
    inherit (final.emacsPgtkNativeComp.pkgs.sly-macrostep) src version;
  };

  stumpwmCustomBuild =
    let
      inherit (prev.lib) filterAttrs attrNames flatten makeBinPath;
      inherit (builtins) readDir readFile match split elemAt head replaceStrings filter;

      depsRegex = s: flatten (split " " (replaceStrings [ "#" ":" ] [ "" "" ] (head (elemAt (split "[[:space:]]+:depends-on[[:space:]]+\\((.[^\\)]*)" s) 1))));

      contrib = final.sources.stumpwm-contrib.src;

      allUtils = attrNames (filterAttrs (_: v: v == "directory") (readDir "${contrib}/util"));
      asdf2nix = baseName: trivialBuild rec {
        inherit baseName;
        src = contrib;
        deps = map (p: prev.lispPackages."${p}") (depsRegex (readFile "${contrib}/util/${baseName}/${baseName}.asd"));
        overrides = p: { postUnpack = "src=$src/util/${baseName}"; };
      };

      contribPkgs = map asdf2nix (filter (f: f != "debian") allUtils);

      ttf-fonts = trivialBuild rec {
        src = "${contrib}/util/ttf-fonts";
        deps = with prev.lispPackages; [ cffi stumpwm clx-truetype ];
        baseName = "ttf-fonts";
      };
      # overrides = p: { postUnpack = "src=$src/util/ttf-fonts"; };

    in
    trivialBuild rec {
      inherit (final.sources.stumpwm) src version pname;
      baseName = pname;
      deps = [ ttf-fonts ] ++ (with prev.lispPackages; [
        slynk
        # slynk-quicklisp
        # slynk-named-readtables
        # slynk-macrostep
        # slynk-asdf

        acl-compat
        str
        quri
        drakma
        yason
        listopia
        log4cl'
        cl-syslog'
        alexandria
        cl-ppcre
        cl-ppcre-unicode
        cl-shellwords
        cl-hash-util
        cl-strings
        clx
        clx-truetype
        anaphora
        xembed
        dbus
      ]);

      overrides = x: {
        linkedSystems = [ ];
        buildInputs = (x.buildInputs or [ ]) ++ (with prev; [
          texinfo4
          makeWrapper
          autoconf
          xorg.xdpyinfo
        ]);
        propagatedBuildInputs = (x.propagatedBuildInputs or [ ]) ++ (with prev; [ libfixposix ]);

        preConfigure = ''
          export configureFlags="$configureFlags --with-$NIX_LISP=common-lisp.sh --with-module-dir=$out/share/stumpwm/modules";
        '';

        passthru = { inherit contrib; };

        preBuild = ''
          cp -r --no-preserve=mode ${contrib} modules
          substituteInPlace head.lisp \
            --replace 'run-shell-command "xdpyinfo' 'run-shell-command "${prev.xorg.xdpyinfo}/bin/xdpyinfo'
        '';

        postInstall = ''
          export NIX_LISP_PRELAUNCH_HOOK="nix_lisp_build_system stumpwm \
                  '(function stumpwm:stumpwm)' '$linkedSystems'"
          "$out/bin/stumpwm-lisp-launcher.sh"

          mkdir -p $out/share/stumpwm/modules
          cp -r --no-preserve=mode ${contrib}/* $out/share/stumpwm/modules

          # Copy stumpish;
          cp $out/share/stumpwm/modules/util/stumpish/stumpish $out/bin/
          chmod +x $out/bin/stumpish
          wrapProgram $out/bin/stumpish \
            --prefix PATH ":" "${with prev; makeBinPath [ rlwrap gnused gnugrep coreutils xorg.xprop ]}"

          # Paths in the compressed image $out/bin/stumpwm are not
          # recognized by Nix. Add explicit reference here.

          mkdir $out/nix-support
          echo ${prev.xorg.xdpyinfo} > $out/nix-support/xdpyinfo

          # cp "$out/lib/common-lisp/stumpwm/stumpwm" "$out/bin"
        '';
      };
    };

in
{
  inherit stumpwmCustomBuild;
}
