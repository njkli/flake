final: prev:
let
  inherit (prev) callPackage;
  inherit (prev.nur.repos.rycee.firefox-addons) buildFirefoxXpiAddon;
  inherit (final.lib.our) rakeLeaves flattenTree;
  inherit (final.lib) filterAttrs last splitString mapAttrs' nameValuePair;
  inherit (builtins) elem;

  # vscode-extensions-mod = with final.lib; with builtins;
  #   let
  #     ary = splitString ".";
  #     name = s: elemAt (ary s) 1;
  #     publisher = s: elemAt (ary s) 0;
  #   in
  #   mapAttrs'
  #     (k: v: nameValuePair k (recursiveUpdate v {
  #       passthru.publisher = (publisher v.src.vsmarketplace);
  #       passthru.name = (name v.src.vsmarketplace);
  #     }))
  #     (fromTOML (readFile ./sources-vscode.toml));

  sources = callPackage (import ./_sources/generated.nix) { } // (callPackage ./_sources_vscode/generated.nix { });
  # then, call packages with `final.callPackage`

  firefox-addons = {
    home-manager = final.callPackage ./_sources_firefox-addons/generated-home-manager.nix { };
    nixpkgs =
      mapAttrs'
        (k: v:
          nameValuePair k (final.fetchFirefoxAddon { inherit (v) url sha256; name = v.pname; }))
        (callPackage ./_sources_firefox-addons/generated-nixpkgs.nix { });
  };

  filtered = [
    "_sources"
    "_sources_vscode"
    "_sources_firefox-addons"
    "default"
  ];

  ourPkgs = mapAttrs'
    (k: v:
      nameValuePair (last (splitString "." k)) (final.callPackage v { }))
    (flattenTree (filterAttrs (k: v: !(elem k filtered)) (rakeLeaves ./.)));

in
{
  inherit sources buildFirefoxXpiAddon firefox-addons;
  inherit (ourPkgs)
    # git-get
    shflags
    shellspec
    getoptions
    rainbowsh
    # git-remote-ipfs
    # git-pr-mirror
    nixos-install-rb
    okteto
    pbkdf2-sha512
    paper-store
    # age-plugin-yubikey
    all-the-icons
    uhk-agent
    kea-ma
    zeronsd
    gitea-tea
    windows-fonts
    make-desktopitem
    xxhash2mac
    huginn
    # activitywatch
    dbus-listen
    gpg-hd
    ;

  # TODO: Finish cups-brother-mfcl3750cdw
  cups-brother-mfcl3750cdw = ourPkgs.mfcl3750cdw;
  ipxe-git = ourPkgs.ipxe;
  crystal_1_6_2 = ourPkgs.crystal;

  promnesia = prev.pythonPackages.callPackage ./tools/python/promnesia {
    orgparse = final.orgparse;
    hpi = final.hpi;
  };
  orgparse = prev.pythonPackages.callPackage ./tools/python/orgparse { };
  hpi = prev.pythonPackages.callPackage ./tools/python/HPI { };
}
