final: prev:
{
  vscode-extensions =
    prev.vscode-extensions // (final.vscode-extensions-builder
      final.sources
      { prefix = "vscode-extensions-"; });
}
