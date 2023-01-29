{ ruby, bundlerEnv, stdenv }:
let
  env = bundlerEnv {
    # ignoreCollisions = true;

    inherit ruby;
    name = "nixos-install-rb-bundler-env";
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };

  binDrv = stdenv.mkDerivation {
    name = "nixos-install-rb";
    src = ./.;
    buildInputs = [ env.wrappedRuby ];
    installPhase = ''
      mkdir -p $out/bin
      echo '#!${env.wrappedRuby}/bin/ruby' > $out/bin/nixos-install-rb
      cat $src/nixos-install.rb >> $out/bin/nixos-install-rb
      chmod +x $out/bin/nixos-install-rb
    '';
  };
in
binDrv
