{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkDefault;
in
{
  # NOTE: need to manually source hmSessionVars if not using shells from home-manager!
  # https://github.com/nix-community/home-manager/blob/15ae861e1bfad90e0d14106551544e9e07cbcb10/modules/home-environment.nix#L173
  # environment.shellInit = ''
  #   hmSessionVars=/etc/profiles/per-user/''${USER}/etc/profile.d/hm-session-vars.sh
  #   [[ -r  $hmSessionVars ]] && . $hmSessionVars || true
  # '';

  # NOTE: https://github.com/NixOS/nixpkgs/issues/5200 & https://github.com/rycee/home-manager/issues/1011
  environment.loginShellInit = ''
    [ -r $HOME/.profile ] && . $HOME/.profile || true
  '';

  programs.fuse.userAllowOther = true; # NOTE: needed for impermanence in home-manager
  programs.command-not-found.enable = true; # to use the home-manager version

  users.defaultUserShell = pkgs.zsh;

  security.sudo.enable = true;
  security.sudo.execWheelOnly = true;
  security.sudo.wheelNeedsPassword = false;

  environment.homeBinInPath = true;
  users.mutableUsers = false;

  # FIXME/TODO/HACK: for lowmem systems -
  services.earlyoom.enable = true;
  # NOTE: osConfig already provided by hm itself
  # home-manager.extraSpecialArgs = { hostConfig = config; };
  home-manager.verbose = false; # DEBUG disabled!
  home-manager.sharedModules = [
    # ({ suites, profiles, ... }: { imports = with profiles.look-and-feel; suites.base ++ [ solarized-dark starship-prompt ]; })

    {
      # NOTE: home.stateVersion == config.system.stateVersion || FAIL!
      home.stateVersion = config.system.stateVersion;

      # programs.bat.enable = true;
      programs.zsh.enable = true;
      programs.bash.enable = true;
      programs.starship.enable = true;

      programs.command-not-found.enable = !config.programs.command-not-found.enable;

      # systemd.user.sessionVariables = {
      #   inherit (config.environment.sessionVariables) NIX_PATH;
      #   HM_FONT_NAME = mkDefault "UbuntuMono Nerd Font Mono";
      #   HM_FONT_SIZE = mkDefault "16";
      # };

      home.sessionVariables = {
        # inherit (config.environment.sessionVariables) NIX_PATH;
        HM_FONT_NAME = "UbuntuMono Nerd Font Mono";
        HM_FONT_SIZE = "15";
      };

      xdg.configFile."nix/registry.json".text = config.environment.etc."nix/registry.json".text;

      # # NOTE: https://wiki.archlinux.org/index.php/XDG_user_directories
      # home.persistence."/persist/nixos" = {
      #   allowOther = true;
      #   # files = [ ".screenrc" ];
      #   directories = [
      #     "Desktop"
      #     "Documents"
      #     "Downloads"
      #     "Music"
      #     "Pictures"
      #     "Public"
      #     "Templates"
      #     "Video"
      #   ];
      # };

    }

  ];
}
