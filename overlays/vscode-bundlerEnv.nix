final: prev: {
  vscode-bundlerEnv = prev.bundlerEnv rec {
    ruby = prev.ruby_3_0;
    name = "vscode-bundlerEnv";
    gemdir = ../shell/rubyEnv;
    gemConfig.nokogiri = _: prev.defaultGemConfig.nokogiri { } // {
      gemName = "nokogiri";
      version = "1.13.0";
      dependencies = [ "racc" "mini_portile2" ];
      source.type = "gem";
      source.sha256 = "sha256-jb1pHUONwS2tw9i1t+0KbmTYSi1ls5K1Lc6Gj9oQfbM=";
    };
  };
}
