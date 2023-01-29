# https://autrilla.gitbooks.io/sops/content/uage.html
{ pkgs, ... }:

{
  commands = [
    {
      category = "secrets";
      command = ''
        nix develop $PRJ_ROOT#sops-shell --impure --command sops updatekeys -y $@ \
        && echo Now_to_sops \
        && nix develop $PRJ_ROOT#sops-shell --impure --command sops $@
      '';
      help = "launch sops with sops-shell";
      name = "sops";
    }

    {
      category = "secrets";
      command = "sops-init-gpg-key --hostname $@ --gpghome /tmp/$@-sops-gpg-key &>> $@.asc";
      help = "sops-new <hostName> | Generate a new gpg-key with sops-nix /tmp/<hostName>-sops-gpg-key";
      name = "sops-new";
    }
    {
      category = "secrets";
      command = "scp -r /tmp/$1-sops-gpg-key $2:/var/lib/sops";
      help = "sops-copy <hostName> <user@hostName> | Copy the host's GPG(sops-init-gpg-key) key to target host.";
      name = "sops-copy";
    }
    {
      category = "secrets";
      command = "ssh $@ 'ssh-keygen -o -a 256 -t ed25519 -C \"$(hostname)-$(date +'%d-%m-%Y')\"'";
      help = "ssh-new-ed25519 <user@hostName> Generate a new SSH ed25519 key to target host";
      name = "ssh-new-ed25519";
    }
    {
      category = "secrets";
      command = "scp -r $1:/etc/nixos/ hosts/$2";
      help = "copy-newHost <root@hostname> <machine-name>";
      name = "copy-newHost";
    }
  ];

  env = [
    # NOTE: otherwise yubikey doesn't work encryption!
    { name = "SOPS_GPG_EXEC"; value = "/run/current-system/sw/bin/gpg"; }
  ];

  packages = with pkgs; [
    # sops
    # sops-install-secrets
    # sops-import-keys-hook

    # FIXME: sops-init-gpg-key

    ssh-to-pgp
    ssh-to-age
  ];
}
