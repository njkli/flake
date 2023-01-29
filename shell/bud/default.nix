{ pkgs, lib, budUtils, ... }:
{
  bud.cmds = with pkgs; {
    vm = lib.mkForce {
      writer = budUtils.writeBashWithPaths [ nixUnstable git mercurial coreutils ];
      synopsis = "vm HOST";
      help = "Generate & run a one-shot vm for HOST";
      script = ./scripts/vmLocalQemu.bash;
    };

    get = {
      writer = budUtils.writeBashWithPaths [ nixUnstable git coreutils ];
      synopsis = "get [DEST]";
      help = "Copy the desired template to DEST";
      script = ./scripts/get.bash;
    };

    # whatever comes with bud is basically an example
    repl = lib.mkForce {
      writer = budUtils.writeBashWithPaths [ nixUnstable gnused git mercurial ];
      synopsis = "repl [FLAKE]";
      help = "Enter a repl with the flake's outputs";
      script = (import ./scripts/utils-repl pkgs).outPath;
    };

    vscode-ext-prefetch = {
      writer = budUtils.writeBashWithPaths [ curl jq ];
      synopsis = "vscode-ext-prefetch |(publisher/name)";
      help = "Prefetch meta for vscode extensions";
      script = ./scripts/vscode-ext-prefetch.bash;
    };

    install-to-qcow = {
      writer = budUtils.writeBashWithPaths [ curl jq ];
      synopsis = "install-to-qcow /dev/nbd[X] configName";
      help = "Attach qemu-nbd and install a config";
      script = ./scripts/mkQcow.bash;
    };

    # age-edit-secret = {
    #   writer = budUtils.writeBashWithPaths [ ragenix age-plugin-yubikey ];
    #   synopsis = "age-edit-secret path/to/secret.age";
    #   help = "Edit age keys with ragenix";
    #   script = ./scripts/edit_secrets.bash;
    # };

  };
}
