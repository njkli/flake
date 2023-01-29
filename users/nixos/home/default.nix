{ name, profiles, pkgs, config, ... }:
let
  inherit (config.home.sessionVariables) HM_FONT_NAME HM_FONT_SIZE;
in
{
  programs.doom-emacs.enable = true;

  imports = with profiles.look-and-feel;
    [
      solarized-dark
      nerdfonts-ubuntu
      starship-prompt
      pointer-cursor
    ] ++ (with profiles.developer; [
      # vscode
      ruby
      nix
      direnv
      git
    ]);

  gtk.enable = true;
  gtk.gtk2.extraConfig = ''
    gtk-key-theme-name = "Emacs"
    binding "gtk-emacs-text-entry"
    {
      bind "<alt>BackSpace" { "delete-from-cursor" (word-ends, -1) }
    }
  '';

  dconf.enable = true;
  dconf.settings = {
    "org/mate/desktop/session".idle-delay = 30;
    "org/mate/screensaver".mode = "blank-only";
    "org/gtk/settings/file-chooser".sort-directories-first = true;

    "org/mate/desktop/peripherals/keyboard/kbd" = {
      layouts = [ "us" "ru\tphonetic_YAZHERTY" ];
      options = [ "grp\tgrp:shifts_toggle" ];
    };

    # TODO: key remap should be in window manager lisp module, once it's home-manager based!
    "org/mate/settings-daemon/plugins/media-keys".power = "<Primary><Alt>End";
    "org/mate/desktop/interface".window-scaling-factor = 1;
  };

  programs.rofi.enable = true;
  # programs.rofi.width = 800;
  # programs.rofi.lines = 10;
  # programs.rofi.borderWidth = 1;
  programs.rofi.location = "center";

  # NOTE: nushell sucks, except in scripts, but why use it if there's ruby?
  programs.nushell.enable = false;
  # programs.nushell.settings = {
  #   startup = [
  #     "alias docker-ps = 'docker ps --format \"{{ .Names }}\" | xargs docker stats'"
  #   ];
  #   complete_from_path = true;
  #   filesize_format = "mib";
  #   nonzero_exit_errors = true;
  #   # plugin_dirs = [];
  #   skip_welcome_message = true;
  #   # table_mode = "";
  #   line_editor.auto_add_history = true;
  #   line_editor.color_mode = "enabled";
  #   # line_editor.completion_type = "";
  #   line_editor.edit_mode = "emacs";
  #   line_editor.history_duplicates = "ignoreconsecutive";
  #   line_editor.history_ignore_space = true;
  #   line_editor.tab_stop = 2;
  #   line_editor.completion_match_method = "case-insensitive";
  #   # color_config = {};
  #   textview.colored_output = true;
  #   textview.true_color = true;
  #   env = {
  #     SHELL = "${pkgs.nushell}/bin/nu";
  #   };
  # };

  home.file."bin/ldapsearch-test" = {
    executable = true;
    text = ''
      #!/bin/sh
      ${pkgs.openldap}/bin/ldapsearch -H ldap://ldap.jumpcloud.com:389 \
        -ZZ -x -b "ou=Users,o=5fa952a8ab71a75cdb7fcf63,dc=jumpcloud,dc=com" \
        -D "uid=gadmin,ou=Users,o=5fa952a8ab71a75cdb7fcf63,dc=jumpcloud,dc=com" \
        -W "(objectClass=inetOrgPerson)"
    '';
  };

  programs.git.userName = name;
  programs.git.userEmail = name + "@0.njk.li";
  programs.git.extraConfig.credential.helper = "cache";

  # home.activation.createTestFiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  #   echo ${modulesPath} > $HOME/NEWSHIT
  #   echo ${self.inputs.impermanence} > $HOME/OTHERSHIT
  # '';

}
