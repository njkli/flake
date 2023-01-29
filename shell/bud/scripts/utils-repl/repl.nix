{ flakePath, host }:
let
  Flake =
    if builtins.pathExists flakePath
    then builtins.getFlake (toString flakePath)
    else { };

  Me = Flake.nixosConfigurations.${host} or { };
  NixOS = Flake.nixosConfigurations.NixOS;
  Channels = Flake.pkgs.${builtins.currentSystem} or { };
  Machines = Flake.nixosConfigurations;
  LoadFlake = path: builtins.getFlake (toString path);
  Lib =
    with Channels.nixos.lib;
    let
      inputsWithLibs = filterAttrs (n: v: v ? lib && !elem n (attrNames Channels)) Flake.inputs;
    in
    mapAttrs (_: v: v.lib) (Channels // inputsWithLibs);
  Module = fName:
    let
      channelPath = "${Flake.inputs.nixos}";
      modulesPath = channelPath + "/nixos/modules/";
      modEval = import (modulesPath + fName) { inherit (NixOS) config options pkgs; inherit (NixOS.pkgs) lib; };
    in
    modEval;
  stdLib = Lib.nixos // Flake.lib // { diggaFlake = Lib.digga; };
  Legacy = with builtins; let path = toPath ((getEnv "PRJ_ROOT") + "/../legacy/systems"); in
  if pathExists path then getFlake path else null;
  dumpConfig = { flake, machine }:
    with stdLib;
    with builtins;
    let
      filters = [
        "passthru"
        "fileSystems"
      ];
      cfg = filterAttrs (n: v: !elem n filters) (getFlake (toPath flake)).nixosConfigurations.${machine}.config;
    in
    cfg;

in
{
  inherit
    # TODO: dumpConfig
    Legacy
    Channels
    Machines
    Lib
    stdLib
    Flake
    LoadFlake
    Me
    NixOS
    Module;
  inherit (Lib.nixos.modules) evalModules;
  inherit (NixOS.pkgs) writeText;
} // builtins
