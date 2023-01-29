{ pkgs, lib, config, ... }:
let
  inherit (config.home.sessionVariables) HM_FONT_NAME HM_FONT_SIZE;
in
{
  services.emacs.enable = true;
  programs.emacs.enable = true;
  programs.emacs.package = pkgs.emacsPgtkNativeComp;
  programs.emacs.extraPackages = p: with p; [
    vterm
    vterm-toggle
    sly
    sly-asdf
    sly-macrostep
    sly-named-readtables
    sly-quicklisp
    sly-repl-ansi-color
  ];

  home.sessionVariables.SPACEMACSDIR = "$HOME/.config/spacemacs.d";
  xdg.configFile."spacemacs.d".source = ../dotfiles/spacemacs.d;
  xdg.configFile."spacemacs.d".recursive = true;

  home.file =
    with lib;
    let
      spacemacs = pkgs.sources.spacemacs.src;
      spacemacsDirs = builtins.readDir spacemacs;
      mapDir = name: _: nameValuePair ".emacs.d/${name}" {
        recursive = name == "private";
        source = "${spacemacs}/${name}";
      };
    in
    mapAttrs' mapDir spacemacsDirs;

  xresources.properties = {
    "Emacs.menuBar" = "off";
    "Emacs.verticalScrollBars" = "off";
    "Emacs.toolBar" = "off";
    "Emacs.fullscreen" = "maximized";
    "Emacs.FontBackend" = "xft";
    "Emacs.font" = "${HM_FONT_NAME} ${HM_FONT_SIZE}";
  };

  home.packages = with pkgs; [
    aspell
    aspellDicts.en-computers
    aspellDicts.en-science
    aspellDicts.en
    aspellDicts.de
    aspellDicts.ru

    # org-mode helpers
    pandoc
    plantuml
    bibtex2html
    ditaa

    #TODO: TeX
    # (texlive.combine {
    #   inherit (texlive)
    #     # scheme-basic
    #     scheme-full
    #     xcolor
    #     xcolor-solarized
    #     koma-script
    #     koma-script-examples
    #     koma-script-sfs;
    # })
  ];

  # programs.doom-emacs.enable = true;
  # programs.doom-emacs.doomPrivateDir = ../doom.d;
  # programs.doom-emacs.emacsPackage = pkgs.emacsPgtkGcc;
  # programs.doom-emacs.extraPackages = with pkgs; with (emacsPackagesFor emacsPgtkGcc).melpaPackages; [
  #   vterm
  #   vterm-toggle
  #   sly
  #   sly-asdf
  #   sly-macrostep
  #   sly-named-readtables
  #   sly-quicklisp
  #   sly-repl-ansi-color
  # ];

}
