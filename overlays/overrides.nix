channels: final: prev: {

  __dontExport = true; # overrides clutter up actual creations

  # inherit (channels.stable)
  #   libreoffice; # FIXME: libreoffice from nixos-22.05 fails to build!

  inherit (channels.master)
    nix-tree

    trezor_agent
    trezorctl

    terraform
    # Broken? ventoy-bin
    ventoy-bin-full

    # nix-prefetch
    # FIXME: [marked broken] nix-linter

    opensnitch
    opensnitch-ui

    yaml-language-server
    texlab

    cloud-hypervisor

    droidcam
    # ruby
    # rubyPackages

    bisq-desktop# decentralized bitcoin exchange
    passff-host
    # nyxt
    # bundlerEnv
    # buildRubyGem
    # defaultGemConfig

    vscode
    vscode-utils
    vscode-extensions
    vscode-with-extensions;

  inherit (channels.master.nodePackages)
    bash-language-server
    dockerfile-language-server-nodejs
    vscode-json-languageserver-bin
    vscode-css-languageserver-bin
    graphql-language-service-cli
    vscode-html-languageserver-bin;

  inherit (channels.latest.plasma5Packages) kdeconnect-kde;
  inherit (channels.latest)
    # rust-bin# NOTE: from rust-overlay.overlays.default
    deploy-rs# NOTE: from deploy.overlay
    # nvfetcher-bin# NOTE: from nvfetcher.overlay

    dhall
    discord
    element-desktop
    signal-desktop
    tilix
    qtox
    utox

    rage
    age
    ssh-to-age
    step-ca step-cli


    keybase
    keybase-gui
    kbfs

    starship
    xml2
    xmlformat
    oq
    arcan
    stumpwm
    ipfs-cluster

    #
    nushell
    # bunch of nix tools

    cachix
    # lorri
    any-nix-shell
    zsh-nix-shell
    # cached-nix-shell
    nixpkgs-fmt
    # nixpkgs-review
    # nix-linter

    niv
    dconf2nix

    # nix-top
    # nix-du
    # nix-tree
    # nix-bundle
    # nix-diff
    # nix-index
    # nix-prefetch-scripts
    # nix-info
    # nix-update
    # nix-update-source
    # nix-plugins
    # nix-universal-prefetch
    # nix-prefetch-github
    # nix-prefetch-docker

    nix-script
    # nix-template
    # nix-template-rpm
    nixbang
    # nixos-shell

    dpkg

    # nixfmt # NOTE: This is a dubious haskell pkgs, maybe just remove this comment and the ref to pkg?
    rnix-lsp

    # printer stuff
    cups-kyocera-ecosys-m552x-p502x
    #

    ### TERMINAL MUX
    abduco
    dvtm

    ### cli-tools
    nnn
    ix

    # Networking stuff
    nebula

    # NOTE: https://github.com/NixOS/nixpkgs/issues/148538#issuecomment-1009887524
    # pcsclite
    # pcsctools
    # gnupg
    # gpgme
    kdeconnect

    udisks
    volume_key
    gvfs

    ### Go tooling
    # buildGo117Package
    # buildGo117Module
    # go2nix/dep2nix are for older style of go pkgs, use gomod2nix for newer style
    # go2nix
    # dep2nix

    # Kubernetes

    k9s
    kubectl
    kubernetes-helm
    kubernetes-helmPlugins
    k3s;

  # inherit (channels.latest.buildPackages) go_1_17;

  haskellPackages = prev.haskellPackages.override
    (old: {
      overrides = prev.lib.composeExtensions (old.overrides or (_: _: { })) (hfinal: hprev:
        let version = prev.lib.replaceChars [ "." ] [ "" ] prev.ghc.version;
        in
        {
          # same for haskell packages, matching ghc versions
          inherit (channels.latest.haskell.packages."ghc${version}")
            haskell-language-server;
        });
    });

  # vgo2nix = prev.vgo2nix.overrideAttrs (o: {
  #   inherit (final.sources.vgo2nix) src version;
  #   vendorSha256 = null;
  # });

  makeDesktopItem = final.make-desktopitem;

  # zerotierone = prev.zerotierone.overrideAttrs (o: {
  #   inherit (final.sources.zerotierone-github) src version;
  # });

  # gitea-legacy = prev.gitea.overrideAttrs (o: rec {
  #   inherit (final.sources.gitea-legacy) src version;
  #   preBuild =
  #     let
  #       tagsString = "pam sqlite sqlite_unlock_notify";
  #     in
  #     ''
  #       export buildFlagsArray=(
  #         -tags="${tagsString}"
  #         -ldflags='-X "main.Version=${version}" -X "main.Tags=${tagsString}"'
  #       )
  #     '';
  # });

  # gitea = prev.gitea.overrideAttrs (o: rec {
  #   inherit (final.sources.gitea-latest) src version;
  #   preBuild =
  #     let
  #       tagsString = "pam sqlite sqlite_unlock_notify";
  #     in
  #     ''
  #       export buildFlagsArray=(
  #         -tags="${tagsString}"
  #         -ldflags='-X "main.Version=${version}" -X "main.Tags=${tagsString}"'
  #       )
  #     '';
  # });

}
