{ lib, pkgs, ... }:

{
  packages = with pkgs; [ nodejs-16_x nodePackages.node2nix ];
}
