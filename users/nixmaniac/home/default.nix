{ self, config, pkgs, profiles, suites, osConfig, lib, ... }:
with lib;

{
  imports =
    (self.lib.importFolder ./.) ++
    suites.desktop ++
    suites.office ++
    suites.base ++
    [
      profiles.messengers
      profiles.multimedia.players
      profiles.pentester.traffic
      profiles.security.keybase
    ] ++
    (with profiles.look-and-feel;
    [
      solarized-dark
      nerdfonts-ubuntu
      starship-prompt
      pointer-cursor
    ]) ++ (with profiles.developer; [
      vscode
      ruby
      nix
      direnv
      git
      javascript
      dbtools.postgresql
      dbtools.mysql
      tools
      kubernetes
      crystal

      ballerina # NOTE: currently only java support
    ]);

  # TODO: services.trezor-agent.enable = true;
  # FIXME: programs.activitywatch.enable = true;

  programs.rofi.enable = true;
  programs.rofi.location = "center";
  programs.rofi.plugins = with pkgs; [ rofi-systemd rofi-calc ];
  programs.rofi.cycle = true;
  programs.rofi.pass.enable = true;
  programs.rofi.pass.stores = [ config.programs.password-store.settings.PASSWORD_STORE_DIR ];

  # programs.password-store.settings.PASSWORD_STORE_KEY = "E3C4C12EDF24CA20F167CC7EE203A151BB3FD1AE";

}
