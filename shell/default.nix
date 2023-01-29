{ self, inputs, ... }:
{
  modules = with inputs; [
    bud.devshellModules.bud
  ];
  exportedModules = [
    ./devos.nix
    # ./vscode.nix
    ./sops.nix
    ./nodejs.nix
    ./terraform.nix
  ];
}
