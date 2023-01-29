{
  description = "A highly structured configuration database.";

  # nixConfig.sandbox = false;
  nixConfig.experimental-features = "nix-command flakes recursive-nix impure-derivations";
  nixConfig.substituters = [
    "https://nrdxp.cachix.org"
    "https://njk.cachix.org"
    "https://nix-community.cachix.org"
  ];
  nixConfig.trusted-substituters = [
    "https://nrdxp.cachix.org"
    "https://njk.cachix.org"
    "https://nix-community.cachix.org"
  ];
  nixConfig.trusted-public-keys = [
    "nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4="
    "njk.cachix.org-1:ON4lemYq096ZfK5MtL1NU3afFk9ILAsEnXdy5lDDgKs="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];

  inputs =
    {
      # TODO: stylix.url = "github:danth/stylix";

      stable.url = "github:nixos/nixpkgs/release-21.05";
      nixos.url = "github:nixos/nixpkgs/release-22.11";
      latest.url = "github:nixos/nixpkgs/nixos-unstable";
      master.url = "github:nixos/nixpkgs/master";
      nur.url = "github:nix-community/NUR";

      # nixLatest.url = "github:NixOS/nix/2.8.1";
      # nixLatest.inputs.nixpkgs.follows = "nixos";

      # FIXME: switch back to releases (likely 2.12 when it's out), after https://github.com/NixOS/nix/pull/7130 is merged
      # nixLatest.url = "github:NixOS/nix/ed87f34420bf9c1657c8e494f3e58bf450d12f3a";

      # nixLatest.url = "github:NixOS/nix/2.12.0";
      # nixLatest.inputs.nixpkgs.follows = "master";

      qnr.url = "github:divnix/quick-nix-registry";

      devshell.url = "github:numtide/devshell";
      devshell.inputs.nixpkgs.follows = "latest";

      # TODO: inputs.devenv.url = "github:cachix/devenv/v0.5";

      # https://github.com/divnix/digga/pull/469
      digga.url = "github:divnix/digga";
      # digga.inputs.devshell.inputs.nixpkgs.follows = "nixos";
      # digga.inputs.devshell.inputs.nixpkgs.follows = "nixos";
      digga.inputs.nixpkgs.follows = "nixos";
      digga.inputs.nixlib.follows = "nixos";
      digga.inputs.home-manager.follows = "home";
      digga.inputs.deploy.follows = "deploy";
      digga.inputs.flake-utils-plus.follows = "flake-utils-plus";
      digga.inputs.devshell.follows = "devshell";

      bud.url = "github:divnix/bud";
      bud.inputs.nixpkgs.follows = "nixos";
      # bud.inputs.devshell.follows = "digga/devshell";

      nvfetcher.url = "github:berberman/nvfetcher";
      # nvfetcher.inputs.nixpkgs.follows = "nixos";

      mozilla-addons-to-nix.url = "sourcehut:~rycee/mozilla-addons-to-nix";

      devos-ext-lib.url = "github:divnix/devos-ext-lib";
      devos-ext-lib.inputs.nixpkgs.follows = "nixos";

      home.url = "github:nix-community/home-manager/release-22.11";
      # home.url = "github:nix-community/home-manager/d07df8d9a80a4a34ea881bee7860ae437c5d44a5";
      # FIXME: home.url = "github:nix-community/home-manager";
      home.inputs.nixpkgs.follows = "nixos";

      # darwin.url = "github:LnL7/nix-darwin";
      # darwin.inputs.nixpkgs.follows = "nixos";

      deploy.url = "github:serokell/deploy-rs"; # input-output-hk/deploy-rs
      # deploy.inputs.nixpkgs.follows = "latest";

      # TODO: https://github.com/cleverca22/not-os
      netboot-nix.url = "github:grahamc/netboot.nix";
      # netboot-nix.inputs.nixpkgs.follows = "nixos";

      microvm-nix.url = "github:astro/microvm.nix";
      microvm-nix.inputs.nixpkgs.follows = "nixos";

      flake-utils-plus.url = "github:gytis-ivaskevicius/flake-utils-plus";
      #flake-utils-plus.url = "github:GTrunSec/flake-utils-plus/6271cf3842ff9c8a9af9e3508c547f86bc77d199";

      nixos-generators.url = "github:nix-community/nixos-generators";
      # nixos-generators.inputs.nixpkgs.follows = "nixos";
      nix-environments.url = "github:nix-community/nix-environments"; # TODO: nix-environments
      nix-script.url = "github:BrianHicks/nix-script";

      # dns-dsl.url = "github:kirelagin/dns.nix";
      # dns-dsl.inputs.nixpkgs.follows = "nixos";

      # NOTE: Investigate why this is needed for deploy-rs?
      fenix.url = "github:nix-community/fenix";
      fenix.inputs.nixpkgs.follows = "nixos";

      # nixpkgs-mozilla.url = "github:mozilla/nixpkgs-mozilla";

      ### FIXME: ASAP - this is temporary, so that the rebuild isn't happening too much on laptop only
      # terraform-providers-bin.url = "github:numtide/nixpkgs-terraform-providers-bin/d360439a57ccb4efc5e083614eae7e584b6a1a84";
      terraform-providers-bin.url = "github:numtide/nixpkgs-terraform-providers-bin";
      terraform-providers-bin.inputs.nixpkgs.follows = "nixos";

      terranix.url = "github:mrVanDalo/terranix/2.5.5";
      impermanence.url = "github:nix-community/impermanence";

      # lisp.url = "github:nix-lisp/lisp-overlay"; # Lisp-overlay defunct, probably obsolete as well!

      ### doom-emacs
      #       https://github.com/hlissner/doom-emacs/pull/5862
      # NOTE: https://github.com/0x450x6c/nix-doom-emacs-example/blob/master/flake.nix
      # TODO: Fix nix-doom-emacs for literate config - https://github.com/nix-community/nix-doom-emacs/issues/60

      # nix-doom-emacs.url = "github:nix-community/nix-doom-emacs/269a09020521c35f4cc47bba0871fec79224a508";
      nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
      # Last known working: 7b8c1c53537840f2656cacce267697eca7032727
      ###

      # FIXME: https://github.com/divnix/digga/issues/464
      # emacs.url = "github:nix-community/emacs-overlay/334ba8c610cf5e41dfe130507030e5587e3551b4";

      # emacs.url = "github:nix-community/emacs-overlay";
      # emacs.inputs.nixpkgs.follows = "nixos";

      # emacs.inputs.flake-utils-plus.follows = "flake-utils-plus";

      # emacs-ng.url = "github:emacs-ng/emacs-ng";

      agenix.url = "github:ryantm/agenix";
      # agenix.inputs.nixpkgs.follows = "nixos";

      # ragenix.inputs.nixpkgs.follows = "latest";
      # ragenix.inputs.agenix.inputs.nixpkgs.follows = "latest";
      # ragenix.inputs.nixpkgs.follows = "nixos";

      # ragenix.url = "github:yaxitech/ragenix";
      # ragenix.inputs.rust-overlay.follows = "rust-overlay";
      # ragenix.inputs.nixpkgs.follows = "latest";

      homeage.url = "github:jordanisaacs/homeage"; # TODO: age secrets for home-manager
      homeage.inputs.nixpkgs.follows = "nixos";

      sops-nix.url = "github:Mic92/sops-nix";
      sops-nix.inputs.nixpkgs.follows = "nixos";

      naersk.url = "github:nmattia/naersk";
      naersk.inputs.nixpkgs.follows = "nixos";

      nixos-hardware.url = "github:nixos/nixos-hardware";

      ### Build toolchains
      gomod2nix.url = "github:tweag/gomod2nix";
      # rust-overlay.url = "github:oxalica/rust-overlay";

      # https://ww.telent.net/2017/5/10/building_maven_packages_with_nix
      # mvn2nix.url = "github:fzakaria/mvn2nix";

      ### Kewl stuff from the net
      photoprism2nix.url = "github:GTrunSec/photoprism2nix";
      photoprism2nix.inputs.nixpkgs.follows = "nixos";
    };

  outputs =
    { self
    , digga
    , bud
      # , nixLatest
    , nixos
    , home
    , impermanence
    , nix-doom-emacs
      # , emacs
    , devos-ext-lib
    , nixos-hardware
    , nur
    , agenix
    , nixos-generators
      # , ragenix
    , gomod2nix
      # , mvn2nix
      # , rust-overlay
    , sops-nix
    , nvfetcher
    , qnr
    , deploy
    , netboot-nix
      # , fenix
      # , nixpkgs-mozilla
    , ...
    } @ inputs':
    let

      inputs = inputs';

      # inputs = inputs' // {
      #   emacs = inputs'.emacs // { overlay = lib.overlayNullProtector inputs'.emacs.overlay; };
      # };

      lib = import ./lib { lib = digga.lib // nixos.lib // { deploy = deploy.lib; }; };

      netModule = { ... }: {
        networks."njk.local" = {
          macvlanName = "lan";

        };
      };

      # namespacedModule = let ns = baseNameOf (nixos.lib.removeSuffix ".nix" (__curPos.file)); in
      #   { lib, ... }: {
      #     options.${ns} = with lib; { enable = mkEnableOption "NS testing"; };
      #     config = { lan."njk.local".nicName = "lan"; };
      #   };

      hostDefaultsModules = [
        # namespacedModule
        # FIXME: 2. where and how is lib being passed and what is it
        { lib.our = self.lib // { inherit (digga.lib) flattenTree rakeLeaves; }; }
        ({ lib, config, pkgs, ... }:
          with lib;
          mkIf config.powerManagement.enable { powerManagement.powerDownCommands = "${pkgs.systemd}/bin/loginctl lock-sessions"; })
        { system.stateVersion = "22.11"; }
        { disabledModules = lib.disableModulesFrom ./modules; }
        # ({ self, pkgs, ... }: { _module.args.credentials = self.lib.importCredentials { inherit pkgs; }; })
        ({ lib, ... }: { networking.domain = "0.njk.li"; })
        digga.nixosModules.bootstrapIso
        digga.nixosModules.nixConfig
        home.nixosModules.home-manager
        agenix.nixosModules.age
        sops-nix.nixosModules.sops
        bud.nixosModules.bud
        impermanence.nixosModules.impermanence
        # "${netboot-nix}/quickly.nix"
        # FIXME: enable only on certain systems qnr.nixosModules.local-registry
        # {
        #   nix.localRegistry.enable = true;
        #   nix.localRegistry.cacheGlobalRegistry = true;
        #   nix.localRegistry.noGlobalRegistry = false;
        # }
      ];

      mkFlakeArgs = {
        inherit self inputs lib;

        supportedSystems = [ "x86_64-linux" ];

        channelsConfig = { allowUnfree = true; };
        channels = {
          stable = { };
          master = { };
          latest = {
            overlays = [
              deploy.overlay
              # rust-overlay.overlays.default
            ];
          };
          nixos = {
            imports = [ (digga.lib.importOverlays ./overlays) ];
            overlays = [

              nvfetcher.overlays.default

              # digga.overlay
              # agenix.overlay
              # deploy.overlay
              # mvn2nix.overlay
              gomod2nix.overlays.default
              nur.overlay
              # (lib.overlayNullProtector inputs'.emacs.overlay)
              # emacs-ng.overlay
              ./pkgs/default.nix
            ];
          };
        };

        sharedOverlays = devos-ext-lib.overlays.vscode-extensions ++ [
          # nixLatest.overlays.default

          (final: prev: { nixUnstable = final.nix; })

          (final: prev: {
            __dontExport = true;
            lib = prev.lib.extend (lfinal: lprev: {
              # FIXME: 1. where and how is lib being passed and what is it?
              our = self.lib // { inherit (digga.lib) flattenTree rakeLeaves; };
            });
          })

          # fenix.overlay
          # deploy.overlay

          # nixpkgs-mozilla.overlays.firefox # NOTE: <nixpkgs>.latest.firefox-*

          sops-nix.overlay
          agenix.overlay
        ];

        nixos = {
          hostDefaults = {
            system = "x86_64-linux";
            channelName = "nixos";
            imports = [ (digga.lib.importExportableModules ./modules) ];
            # disabledModules = [""];
            modules = hostDefaultsModules;
            # modules = [
            #   # FIXME: 2. where and how is lib being passed and what is it
            #   { lib.our = self.lib // { inherit (digga.lib) flattenTree rakeLeaves; }; }
            #   { disabledModules = lib.disableModulesFrom ./modules; }
            #   ({ self, pkgs, ... }: { _module.args.credentials = self.lib.importCredentials { inherit pkgs; }; })
            #   ({ lib, ... }: { networking.domain = "0.njk.li"; })
            #   digga.nixosModules.bootstrapIso
            #   digga.nixosModules.nixConfig
            #   home.nixosModules.home-manager
            #   ragenix.nixosModules.age
            #   sops-nix.nixosModules.sops
            #   bud.nixosModules.bud
            #   impermanence.nixosModules.impermanence
            #   # "${netboot-nix}/quickly.nix"
            #   # FIXME: enable only on certain systems qnr.nixosModules.local-registry
            #   # {
            #   #   nix.localRegistry.enable = true;
            #   #   nix.localRegistry.cacheGlobalRegistry = true;
            #   #   nix.localRegistry.noGlobalRegistry = false;
            #   # }
            # ];
          };

          imports = [ (digga.lib.importHosts ./hosts) ];

          # hosts = {
          #   /* set host specific properties here */
          #   NixOS = {
          #     # modules = [ ];
          #   };
          # };

          importables = rec {
            profiles = digga.lib.rakeLeaves ./profiles // {
              users = digga.lib.rakeLeaves ./users;
            };
            ### TODO: move to profiles/containers/systemd.nix
            containers = {
              systemd = suites.networking ++ [
                self.nixosModules.zerotierone
                self.nixosModules.deploy
                self.inputs.agenix.nixosModules.age
                self.inputs.home.nixosModules.home-manager
                {
                  nixpkgs.config.allowUnfree = true;
                  # nixpkgs.overlays = [ nixLatest.overlay ];
                  nix.extraOptions = ''
                    extra-experimental-features = nix-command flakes
                  '';
                }
                { services.openssh.enable = false; }
                ({ lib, ... }: { deploy.params.lan.dhcpClient = lib.mkDefault true; })
                ({ pkgs, ... }: { environment.systemPackages = with pkgs; [ tcpdump vim ]; })
              ];
            };
            suites = with profiles; rec {
              base = (with core; [
                boot-config
                console-solarized
                locale
                nix-config
                packages
                shell-defaults
                # sops-secrets
                kernel.kconfig
              ]) ++ [
                cachix
                users.admin
                users.root
              ];
              networking = [
                profiles.networking.networkd
                profiles.networking.firewall
                profiles.networking.openssh.server
              ];
            };
          };
        };

        home = {
          imports = [ (digga.lib.importExportableModules ./users/modules) ];

          modules = [
            { disabledModules = lib.disableModulesFrom ./users/modules; }
            # "${impermanence}/home-manager.nix"
            # FIXME:
            nix-doom-emacs.hmModule
          ];

          importables = rec {
            profiles = digga.lib.rakeLeaves ./users/profiles;
            suites = with profiles; rec {
              base = [ shell.screen shell.cli-tools shell.zsh security.password-store ];
              desktop = [ profiles.emacs terminals.tilix terminals.kitty conky xdg qt ];
              office = with profiles.office; [ pdf viewers printing graphics libreoffice nyxt-browser ];
            };
          };

          users = {
            # NOTE: homeConfigurationsPortable only!
            root = { ... }: { };
            admin = { ... }: { };
            nixos = { ... }: { };
            vod = { ... }: { };
            nixmaniac = { ... }: { };
          };
        };

        devshell = ./shell;
        homeConfigurations = digga.lib.mkHomeConfigurations self.nixosConfigurations;

        deploy.nodes =
          with nixos.lib;
          let
            enabled = filterAttrs (n: v: v.config.deploy.enable) self.nixosConfigurations;
            overrides = mapAttrs (n: v: v.config.deploy.node) enabled;
          in
          digga.lib.mkDeployNodes enabled overrides;

        defaultTemplate = self.templates.bud;
        templates.bud.path = ./.;
        templates.bud.description = "bud template";

        outputsBuilder = channels: {
          #nix develop .#sops-shell --impure
          packages.sops-shell = with channels.nixos;
            mkShell {
              # SOPS_AGE_KEY_FILE
              shellHook = ''
                export PATH=/run/current-system/sw/bin:$PATH
              '';

              nativeBuildInputs = [ (sops-import-keys-hook.overrideAttrs (_: { gpg = "/run/current-system/sw/bin/gpg"; })) ];
              # sopsPGPKeyDirs = [
              #   "./secrets/keys/users"
              #"./secrets/keys/hosts"
              # ];
            };
        };
      };

      diggaFlake = digga.lib.mkFlake
        (lib.recursiveMerge [
          mkFlakeArgs
          {
            nixos.hostDefaults.modules = [
              ({ config, self, pkgs, lib, ... }: {
                system.build.qcow2 = self.inputs.nixos-generators.nixosGenerate {
                  inherit pkgs;
                  modules =
                    [ config { fileSystems."/".fsType = lib.mkForce "ext4"; } ]
                      ++ [ self.inputs.flake-utils-plus.nixosModules.autoGenFromInputs ]
                      ++ hostDefaultsModules
                      ++ (lib.attrValues self.nixosModules);
                  format = "qcow";
                };
                # system.build.qcow2 = builtins.mapAttrs (_: v: v { inherit mkFlakeArgs config; }) lib.build;
                # system.build.njk = builtins.mapAttrs (_: v: v { inherit mkFlakeArgs config; }) lib.build;
                #system.build.myShit = lib.build.libvirtVm { inherit mkFlakeArgs config; };
              })
            ];
          }
        ])

      //
      { budModules = { devos = import ./shell/bud; }; };
    in
    # https://infogalactic.com/info/Places_in_The_Hitchhiker%27s_Guide_to_the_Galaxy
    diggaFlake;
}
