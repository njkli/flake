{ pkgs, profiles, name, ... }:
let
  emacsPkg = pkgs.emacs;
  emacsExtraPkgs =
    let
      emacsPackages = pkgs.emacsPackagesFor emacsPkg;

      customSetts = emacsPackages.trivialBuild rec {
        pname = "custom-setts";
        ename = pname;
        version = "1.0";
        src = pkgs.writeText "custom-setts.el" ''
          (defvar custom-setts-custom-from-nix "${pkgs.nodejs}/bin/node")
          (provide 'custom-setts)
        '';
      };

    in
    with emacsPackages; [
      customSetts

      s
      sqlite
      sqlite3
      # vterm
      # vterm-toggle
      grab-x-link
      sly
      sly-asdf
      sly-macrostep
      sly-named-readtables
      sly-quicklisp
      sly-repl-ansi-color
    ];
in

{
  imports = [ profiles.emacs ];

  programs.promnesia.enable = true;

  programs.doom-emacs.enable = true;
  programs.doom-emacs.emacsPackage = emacsPkg;
  programs.doom-emacs.extraPackages = emacsExtraPkgs;
  programs.doom-emacs.doomPrivateDir = pkgs.callPackage ../dotfiles/doom.d { };
  programs.doom-emacs.emacsPackagesOverlay = self: super: {
    org-pretty-table = self.trivialBuild {
      inherit (pkgs.sources.org-pretty-table) pname version src;
      ename = "org-pretty-table";
      packageRequires = with self; [ org ];
    };

    org-protocol-capture-html = self.trivialBuild {
      inherit (pkgs.sources.org-protocol-capture-html) pname version src;
      ename = "org-protocol-capture-html";
      buildInputs = with pkgs; [ pandoc curl ];
      packageRequires = with self; [ org s ];
    };

    activity-watch-mode = self.trivialBuild {
      inherit (pkgs.sources.activity-watch-mode) pname version src;
      ename = "activity-watch-mode";
      packageRequires = with self; [ request cl-lib ];
    };

    copilot = self.trivialBuild {
      inherit (pkgs.sources.copilot-el) pname version src;
      ename = "copilot";
      buildInputs = with pkgs; [ nodejs ];
      packageRequires = with self; [ s dash editorconfig ];
    };

    color-rg = self.trivialBuild rec {
      inherit (pkgs.sources.color-rg) pname version src;
      ename = pname;
      buildInputs = with pkgs; [ ripgrep ];
    };

    nix-mode = self.trivialBuild {
      inherit (pkgs.sources.nix-mode) src pname ename version;
      packageRequires = with self; [ emacs magit-section transient mmm-mode company ];
    };
  };

  home.sessionVariables.EMACS_PATH_COPILOT = "${pkgs.sources.copilot-el.src}";
  # ("voobscout^forge" for "api.github.com")

  # TODO: home.file.".authinfo.gpg".source = ./authinfo.gpg;

  ### FIXME: doomemacs doesn't recognize installed language servers.
  home.file."bin/json-ls".source = "${pkgs.vscode-json-languageserver-bin}/bin/json-languageserver";
  home.file."bin/html-ls".source = "${pkgs.vscode-html-languageserver-bin}/bin/html-languageserver";
  home.file."bin/css-ls".source = "${pkgs.vscode-css-languageserver-bin}/bin/css-languageserver";

  home.packages = with pkgs; [
    python39Packages.grip
    python39Full # treemacs seems to want that
    gnuplot

    openjdk11 # plantuml preview and friends
    nodejs # copilot seems to need it

    # Language servers
    yaml-language-server
    bash-language-server
    texlab # TeX language-server
    dockerfile-language-server-nodejs
    vscode-json-languageserver-bin
    vscode-css-languageserver-bin
    vscode-html-languageserver-bin
    ocamlPackages.digestif

    nodePackages.js-beautify
    nodePackages.stylelint
    tidyp
    html-tidy

    (texlive.combine {
      inherit (texlive)
        scheme-full
        xcolor
        xcolor-solarized
        koma-script
        koma-script-examples
        koma-script-sfs;
    })
  ];
}
