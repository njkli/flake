{ hmUsers, ... }:
{
  home-manager.users.root.imports = [
    hmUsers.root
    ({ profiles, name, ... }: {
      programs.git.userName = name;
      programs.git.userEmail = name + "@0.njk.li";
      programs.git.extraConfig.credential.helper = "cache";
      imports = with profiles; with developer; with look-and-feel; [
        direnv
        nix
        git
      ];
    })
  ];
  users.users.root.hashedPassword = "$6$KSKezdF73TXL$IM6t1ohC4b81iMo0cQyaFv9YBN7c8w0ASBgDkBjlVkKuf/oIvGSKecwlklkUCgFJVTVNhxofr0kRX0jJHvV0w.";
}
