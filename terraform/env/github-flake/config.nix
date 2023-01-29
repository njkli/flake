{ lib, ... }:

with lib; with builtins;
let
  gh_repo = getEnv "GITHUB_FLAKE_REPOSITORY";
  repository = last (splitString "/" gh_repo);
  project_root = getEnv "PRJ_ROOT";

  secrets = mapAttrs'
    (secret_name: plaintext_value:
      nameValuePair
        (toLower secret_name)
        { inherit repository secret_name plaintext_value; })
    (import "${project_root}/secrets/credentials.nix" { }).njk.credentials.gh_actions;
in

{
  imports = [ ../../. ];

  terraform.cloud.organization = "njk";
  terraform.cloud.workspaces.name = "github-actions";

  github.enable = true;
  github.token = getEnv "GITHUB_ORG_TOKEN";
  github.owner = head (splitString "/" gh_repo);

  resource.github_actions_secret = secrets;
}
