{ inputs, pkgs, extraModulesPath, ... }:
let
  hooks = import ./hooks;

  pkgWithCategory = category: package: { inherit package category; };
  linter = pkgWithCategory "linter";
  docs = pkgWithCategory "docs";
  devos = pkgWithCategory "devos";
  bootstrapTools = pkgWithCategory "bootstrap";

  credentials = pkgs.lib.our.importCredentials { inherit pkgs; };
  devshell_credentials = credentials [ "njk" "credentials" "export_devShell_new" ] [{ name = "GITHUB_TOKEN"; value = "fake_ci_value"; }];
in
{
  _file = toString ./.;

  imports = [ "${extraModulesPath}/git/hooks.nix" ];
  git = { inherit hooks; };

  devshell.load_profiles = true;

  # TODO: https://github.com/numtide/devshell/issues/171
  # devshell.startup.compinit_local.text = ''

  #   echo '********************************************************************************'

  #   if test -n $ZSH_VERSION
  #   then
  #     fpath+=$DEVSHELL_DIR/share/zsh/vendor-completions
  #     fpath+=$DEVSHELL_DIR/share/zsh/site-functions
  #     compinit -u
  #   fi
  # '';


  packages = with pkgs; [
    ####
    gptfdisk
    ####
    nix
    # masterpdfeditor
    ###
    ntfsprogs
    ntfs3g
    ### Cluster management
    okteto

    ###
    remarshal
    kea-ma
    tftp-hpa
    #

    ### GO packaging
    go2nix
    dep2nix
    # vgo2nix
    gomod2nix
    # go_1_17

    ### Java packaging
    # mvn2nix

    # pre-commit
    shellcheck

    # shellspec
    # shflags
    # getoptions

    # nushell

    rage
    agenix
    # age-plugin-yubikey
    nebula
    step-ca
    step-cli
    # openssh

    # pdnsutil is here
    powerdns

    #
    ipfs-cluster

    #pup # jq for html
    httpie
    http-prompt
    httplab
    jq
    oq

    github-release
    gist
    git-lfs
    # git-get
    # git-crypt
    gitless

    efibootmgr
    mercurialFull
  ] ++ (with gitAndTools; [ git-hub hub gitflow gh ghq ]);

  commands =
    with pkgs;
    (map bootstrapTools [
      nixos-install-tools
    ]) ++
    (map devos [
      nix-index
      nix-prefetch
    ]) ++

    (map linter [
      rnix-lsp
      xml2
      xmlformat
      yamllint
      nixpkgs-fmt
      nix-linter
      editorconfig-checker
    ]) ++

    [
      # {
      #   name = "nix-linter";
      #   command = ''
      #     ${pkgs.nix-linter}/bin/nix-linter -W  $@
      #   '';
      # }

      {
        name = "age-edit-secret";
        category = "secrets";
        help = "age-edit-secret path/to/secret.age";
        command = ''
          WORKINGDIR=$PRJ_ROOT/secrets
          MASTERKEY=$WORKINGDIR/master_key_id.txt
          ragenix -i $MASTERKEY --rules $WORKINGDIR/secrets.nix -r
          ragenix -i $MASTERKEY --rules $WORKINGDIR/secrets.nix --edit $1
        '';
      }
      {
        category = "devos";
        name = "nvfetcher-firefox-addons";
        help = pkgs.nur.repos.rycee.mozilla-addons-to-nix.meta.description;
        # TODO: nvfetcher-firefox-addons: refactor with nix eval --expr > generated for fetchFirefoxAddon format
        command = ''
          src_dir=$PRJ_ROOT/pkgs/_sources_firefox-addons
          tmpdir=$(mktemp -d fetcher-ff-addons.XXXXXXXX --tmpdir)
          in_file=$PRJ_ROOT/pkgs/sources-firefox-addons.toml
          out_file=$tmpdir/sources-firefox-addons.json
          pkgs_file=$tmpdir/generated-home-manager.nix
          final_nix=$src_dir/generated-nixpkgs.nix

          ! [[ -d $src_dir ]] && mkdir -p $src_dir || true

          remarshal -i $in_file -o $out_file --unwrap addons
          ${pkgs.nur.repos.rycee.mozilla-addons-to-nix}/bin/mozilla-addons-to-nix $out_file $pkgs_file
          cp $pkgs_file $src_dir

          sed -i 's/buildFirefoxXpiAddon /rec /g' $pkgs_file
          sed -i '1d' $pkgs_file
          echo '{ lib, ... }:' > $final_nix
          cat $pkgs_file | nixpkgs-fmt >> $final_nix

          rm -rf $tmpdir
        '';
      }

      {
        category = "devos";
        name = pkgs.nvfetcher-bin.pname + "-vscode";
        help = pkgs.nvfetcher-bin.meta.description + " to vscode";
        command = "cd $PRJ_ROOT/pkgs; ${pkgs.nvfetcher-bin}/bin/nvfetcher -c ./sources-vscode.toml -o ./_sources_vscode $@";
      }

      {
        category = "devos";
        name = pkgs.nvfetcher-bin.pname;
        help = pkgs.nvfetcher-bin.meta.description;
        command = ''
          tmpdir=$(mktemp -d nvfetcher-bin-keys.XXXXXXXX --tmpdir)
          keyfile=$tmpdir/keyfile.toml

          nix eval --impure --raw --expr 'builtins.toJSON {keys = {github = with builtins; if getEnv "GITHUB_ACTIONS" != "" then getEnv "secrets.GITHUB_TOKEN" else getEnv "GITHUB_TOKEN";};}' \
            | ${pkgs.remarshal}/bin/remarshal --input-format json --output-format toml --output $keyfile
          cd $PRJ_ROOT/pkgs; ${pkgs.nvfetcher-bin}/bin/nvfetcher -k $keyfile -c ./sources.toml $@

          rm -rf $tmpdir
        '';
      }

      # (docs python3Packages.grip) too many deps
      (docs mdbook)
      (docs manix)
      #(inputs.deploy.packages.${pkgs.system}.deploy-rs)
    ]

    ++ lib.optional
      (pkgs ? deploy-rs)
      (devos deploy-rs.deploy-rs)

    ++ lib.optional
      (system != "i686-linux")
      (devos cachix);

  env = [
    #{ name = "RULES"; value = "${self}/secrets/agenix-rules.nix"; }
    # https://github.com/NixOS/nix/issues/4178
    # https://github.com/divnix/devos/issues/316#issuecomment-860348356
    { name = "GC_DONT_GC"; value = "1"; }
  ] ++ devshell_credentials;
}
