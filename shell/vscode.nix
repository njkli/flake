{ pkgs, lib, ... }:
let
  vscode_with_extensions = pkgs.vscode-with-extensions.override {
    vscode = pkgs.vscode; #NOTE: not all plugins work with pkgs.vscodium;
    # customExtensions = pkgs.vscode-extensions-builder pkgs.sources { prefix = "vscode-extensions-"; };
    vscodeExtensions = with pkgs.vscode-extensions; [
      remote-ssh-edit
      vscode-docker
      vscode-ruby
      solargraph
      copilot
      rails-snippets
      ruby-rubocop
      ruby
      haml
      simple-ruby-erb
      ruby-linter
      ruby-symbols
      emacs-mcx
      vscode-emacs-tab
      cucumberautocomplete
      gherkintablealign
      vscode-direnv
      nix-extension-pack
      nix-ide
      even-better-toml
      multi-cursor-case-preserve
      readable-indent
      vscode-markdownlint
      markdown-preview-enhanced
    ];
  };
in
{
  packages = with pkgs; [
    vscode_with_extensions
    vscode-bundlerEnv
    (lib.lowPrio vscode-bundlerEnv.wrappedRuby)
    bundix
  ];
}
