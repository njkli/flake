{ stdenv
, callPackage
, fetchFromGitHub
, fetchurl
, lib
, libffi
  # Dependencies
, boehmgc
, coreutils
, git
, gmp
, hostname
, libatomic_ops
, libevent
, libiconv
, libxml2
, libyaml
, llvmPackages_10
, lld_10
, lldb_10
, makeWrapper
, openssl
, pcre
, pkg-config
, readline
, tzdata
, which
, zlib
}:

# We need to keep around at least the latest version released with a stable
# NixOS
let
  # nLibYaml = libyaml.overrideAttrs (_: {
  #   buildFlags = [ "BUILD_STATIC_LIBS" ];
  # });

  archs = {
    x86_64-linux = "linux-x86_64";
    i686-linux = "linux-i686";
    x86_64-darwin = "darwin-x86_64";
    aarch64-darwin = "darwin-universal";
  };

  arch = archs.${stdenv.system} or (throw "system ${stdenv.system} not supported");
  isAarch64Darwin = stdenv.system == "aarch64-darwin";

  checkInputs = [
    git
    gmp
    openssl
    readline
    libxml2
    libyaml
    zlib
    boehmgc
    libatomic_ops
    pcre
    libevent
    libffi
    lld_10
    lldb_10
    llvmPackages_10.llvm
    stdenv.cc.cc.lib
  ];

  genericBinary = { version, sha256s, rel ? 1 }:
    stdenv.mkDerivation rec {
      pname = "crystal-binary";
      inherit version;

      src = fetchurl {
        url = "https://github.com/crystal-lang/crystal/releases/download/${version}/crystal-${version}-${toString rel}-${arch}.tar.gz";
        sha256 = sha256s.${stdenv.system};
      };

      buildCommand = ''
        mkdir -p $out
        tar --strip-components=1 -C $out -xf ${src}
        patchShebangs $out/bin/crystal
      '';

      meta.broken = lib.versionOlder version "1.2.0" && isAarch64Darwin;
    };

  commonBuildInputs = extraBuildInputs: [
    boehmgc
    libatomic_ops
    pcre
    libevent
    libyaml
    zlib
    libxml2
    openssl
    libffi
    lld_10
    lldb_10
  ] ++ extraBuildInputs
  ++ lib.optionals stdenv.isDarwin [ libiconv ];

  generic = (
    { version
    , sha256
    , binary
    , doCheck ? true
    , extraBuildInputs ? [ ]
    , buildFlags ? [ "all" "docs" ]
    }:
    lib.fix (compiler: stdenv.mkDerivation {
      pname = "crystal";
      inherit buildFlags doCheck version;

      src = fetchFromGitHub {
        owner = "crystal-lang";
        repo = "crystal";
        rev = version;
        inherit sha256;
      };

      outputs = [ "out" "lib" "bin" ];

      postPatch = ''
        export TMP=$(mktemp -d)
        export HOME=$TMP
        mkdir -p $HOME/test

        # Add dependency of crystal to docs to avoid issue on flag changes between releases
        # https://github.com/crystal-lang/crystal/pull/8792#issuecomment-614004782
        substituteInPlace Makefile \
          --replace 'docs: ## Generate standard library documentation' 'docs: crystal ## Generate standard library documentation'

        substituteInPlace src/crystal/system/unix/time.cr \
          --replace /usr/share/zoneinfo ${tzdata}/share/zoneinfo

        ln -sf spec/compiler spec/std

        mkdir -p $TMP/crystal

        substituteInPlace spec/std/file_spec.cr \
          --replace '/bin/ls' '${coreutils}/bin/ls' \
          --replace '/usr/share' "$TMP/crystal" \
          --replace '/usr' "$TMP" \
          --replace '/tmp' "$TMP"

        substituteInPlace spec/std/process_spec.cr \
          --replace '/bin/cat' '${coreutils}/bin/cat' \
          --replace '/bin/ls' '${coreutils}/bin/ls' \
          --replace '/usr/bin/env' '${coreutils}/bin/env' \
          --replace '"env"' '"${coreutils}/bin/env"' \
          --replace '/usr' "$TMP" \
          --replace '/tmp' "$TMP"

        substituteInPlace spec/std/system_spec.cr \
          --replace '`hostname`' '`${hostname}/bin/hostname`'

        # See https://github.com/crystal-lang/crystal/issues/8629
        substituteInPlace spec/std/socket/udp_socket_spec.cr \
          --replace 'it "joins and transmits to multicast groups"' 'pending "joins and transmits to multicast groups"'
      '';

      # Defaults are 4
      preBuild = ''
        export CRYSTAL_WORKERS=$NIX_BUILD_CORES
        export threads=$NIX_BUILD_CORES
        export CRYSTAL_CACHE_DIR=$TMP
      '';

      buildInputs = commonBuildInputs extraBuildInputs;

      nativeBuildInputs = [ binary makeWrapper which boehmgc pkg-config llvmPackages_10.llvm libffi lld_10 lldb_10 libyaml ];

      makeFlags = [
        "interpreter=1"
        "CRYSTAL_CONFIG_VERSION=${version}"
      ];

      LLVM_CONFIG = "${llvmPackages_10.llvm.dev}/bin/llvm-config";

      FLAGS = [
        # --threads
        "--release"
        "--single-module" # needed for deterministic builds
      ];

      # This makes sure we don't keep depending on the previous version of
      # crystal used to build this one.
      CRYSTAL_LIBRARY_PATH = "${placeholder "lib"}/crystal";

      # We *have* to add `which` to the PATH or crystal is unable to build
      # stuff later if which is not available.
      installPhase = ''
        runHook preInstall

        install -Dm755 .build/crystal $bin/bin/crystal
        wrapProgram $bin/bin/crystal \
          --suffix PATH : ${lib.makeBinPath [ pkg-config llvmPackages_10.clang which ]} \
          --suffix CRYSTAL_PATH : lib:$lib/crystal \
          --suffix CRYSTAL_LIBRARY_PATH : ${
            lib.makeLibraryPath (commonBuildInputs extraBuildInputs)
          }
        install -dm755 $lib/crystal
        cp -r src/* $lib/crystal/

        install -dm755 $out/share/doc/crystal/api
        cp -r docs/* $out/share/doc/crystal/api/
        cp -r samples $out/share/doc/crystal/

        install -Dm644 etc/completion.bash $out/share/bash-completion/completions/crystal
        install -Dm644 etc/completion.zsh $out/share/zsh/site-functions/_crystal

        install -Dm644 man/crystal.1 $out/share/man/man1/crystal.1

        install -Dm644 -t $out/share/licenses/crystal LICENSE README.md

        mkdir -p $out
        ln -s $bin/bin $out/bin
        ln -s $lib $out/lib

        runHook postInstall
      '';

      enableParallelBuilding = true;

      dontStrip = true;

      # checkTarget = "compiler_spec";

      # preCheck = ''
      #   export LIBRARY_PATH=${lib.makeLibraryPath checkInputs}:$LIBRARY_PATH
      #   export LD_LIBRARY_PATH=${lib.makeLibraryPath checkInputs}:$LD_LIBRARY_PATH
      #   export SPEC_CRYSTAL_LOADER_LIB_PATH=${lib.makeLibraryPath checkInputs}:$SPEC_CRYSTAL_LOADER_LIB_PATH
      #   export PATH=${lib.makeBinPath checkInputs}:$PATH
      # '';

      passthru.buildCrystalPackage = callPackage ./build-package.nix {
        crystal = compiler;
      };

      meta = with lib; {
        description = "A compiled language with Ruby like syntax and type inference";
        homepage = "https://crystal-lang.org/";
        license = licenses.asl20;
        platforms = let archNames = builtins.attrNames archs; in
          if (lib.versionOlder version "1.2.0") then remove "aarch64-darwin" archNames else archNames;
        broken = lib.versionOlder version "0.36.1" && stdenv.isDarwin;
      };
    })
  );

  allCrystal = rec {
    binaryCrystal_1_0 = genericBinary {
      version = "1.0.0";
      sha256s = {
        x86_64-linux = "1949argajiyqyq09824yj3wjyv88gd8wbf20xh895saqfykiq880";
        i686-linux = "0w0f4fwr2ijhx59i7ppicbh05hfmq7vffmgl7lal6im945m29vch";
        x86_64-darwin = "01n0rf8zh551vv8wq3h0ifnsai0fz9a77yq87xx81y9dscl9h099";
      };
    };

    binaryCrystal_1_2 = genericBinary {
      version = "1.2.2";
      sha256s = {
        x86_64-linux = "18dk38h41q2nqphyi1jh5ga87kas9prdwqnymgja1zsn5236fvmi";
        aarch64-darwin = "1hrs8cpjxdkcf8mr9qgzilwbg6bakq87sd4yydfsk2f4pqd6g7nf";
      };
    };

    binaryCrystal_1_5 = genericBinary {
      version = "1.5.0";
      sha256s = {
        x86_64-linux = "0is3k6d4xxfp6waj3chxbdsc0bvs7i87s00h0gc04ll0zkq60wv2";
      };
    };

    crystal_1_0 = generic {
      version = "1.0.0";
      sha256 = "sha256-RI+a3w6Rr+uc5jRf7xw0tOenR+q6qii/ewWfID6dbQ8=";
      binary = binaryCrystal_1_0;
    };

    crystal_1_1 = generic {
      version = "1.1.1";
      sha256 = "sha256-hhhT3reia8acZiPsflwfuD638Ll2JiXwMfES1TyGyNQ=";
      binary = crystal_1_0;
    };

    crystal_1_2 = generic {
      version = "1.2.2";
      sha256 = "sha256-nyOXhsutVBRdtJlJHe2dALl//BUXD1JeeQPgHU4SwiU=";
      binary = if isAarch64Darwin then binaryCrystal_1_2 else crystal_1_1;
    };

    crystal_1_3 = generic {
      version = "1.3.2";
      sha256 = "dX7WPrtVs4emGUP4Vixl4U20pKfZm2CEnSd/t/iKxxw=";
      binary = binaryCrystal_1_2;
    };

    crystal_1_5 = generic {
      version = "1.5.0";
      sha256 = "twDWnJBLc5tvkg3HvbxXJsCPTMJr9vGvvHvfukMXGyA=";
      binary = binaryCrystal_1_5;
    };

    crystal_1_5_1 = generic {
      version = "1.5.1";
      sha256 = "3YQRa9VsU7phq9Cu3EVcNsK1XcOAxGqj5yLNbMqG31o=";
      binary = binaryCrystal_1_5;
    };

    crystal_1_6_2 = generic {
      version = "1.6.2";
      sha256 = "sha256-WgU6Y8ww1IYyB0vd5tXwmWBEL5RiPjHA7YzPd21jlsY=";
      binary = binaryCrystal_1_5;
    };

    # crystal = crystal_1_3;
    # crystal = crystal_1_5;
    # crystal = crystal_1_5_1;
    crystal = crystal_1_6_2; # FIXME: Crystal 1.6.2 no longer compiles!
  };

in
allCrystal.crystal
