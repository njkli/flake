{ inputs
, pkgs
, lib
, ...
}:
with lib;
let
  inherit (pkgs.stdenv.hostPlatform) system;
  tfProviders = inputs.terraform-providers-bin.legacyPackages.${system}.providers;
  pkgTerranix = inputs.terranix.defaultPackage.${system};

  github = pkgs.terraform-providers.mkProvider {
    owner = "integrations";
    provider-source-address = "registry.terraform.io/integrations/github";
    repo = "terraform-provider-github";
    rev = "v5.13.0";
    hash = "sha256-foPj/zLJJx3mI1PpDwcThptT5EprEDfakUWRsjaa0nc=";
    vendorHash = null;
    version = "5.13.0";
  };


  vultr = pkgs.terraform-providers.mkProvider {
    owner = "vultr";
    provider-source-address = "registry.terraform.io/hashicorp/vultr";
    repo = "terraform-provider-vultr";
    rev = "v2.11.4";
    hash = "sha256-6NiVW6kqUCeit6Dc9GbP4mV03UJkqo+UwHsDE4xMwzQ=";
    vendorHash = null;
    version = "2.11.4";
  };

  pkgTerraform = pkgs.terraform.withPlugins (p: with tfProviders; [
    github
    vultr
    oracle.oci
    digitalocean.digitalocean
  ]);
in
{
  packages = [ pkgTerraform pkgTerranix ];

  commands = [{
    name = "deploy-terranix";
    category = "terraform";
    help = "deploy-terranix path/to/some_terranix_file.nix";
    command = ''
      WORKINGDIR=$(dirname $1)
      output_json="$(dirname $1)/config.tf.json"
      echo "Writing $output_json"
      ${pkgTerranix}/bin/terranix "$1" > "$output_json"
      cd $WORKINGDIR
      terraform init && terraform apply -auto-approve
      echo "Removing $output_json"
      rm -rf config.tf.json
    '';
  }];
}
