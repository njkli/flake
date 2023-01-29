{
  awesome_print = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vkq6c8y2jvaw03ynds5vjzl1v9wg608cimkd3bidzxc0jvk56z9";
      type = "gem";
    };
    version = "1.9.2";
  };
  clamp = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08m0syh06bhx8dqn560ivjg96l5cs5s3l9jh2szsnlcdcyl9jsjg";
      type = "gem";
    };
    version = "1.3.2";
  };
  climate_control = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0q11v0iabvr6rif0d025xh078ili5frrihlj0m04zfg7lgvagxji";
      type = "gem";
    };
    version = "0.2.0";
  };
  coderay = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jvxqxzply1lwp7ysn94zjhh57vc14mcshw1ygw14ib8lhc00lyw";
      type = "gem";
    };
    version = "1.1.3";
  };
  concurrent-ruby = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nwad3211p7yv9sda31jmbyw6sdafzmdi2i2niaz6f0wk5nq9h0f";
      type = "gem";
    };
    version = "1.1.9";
  };
  diff-lcs = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18w22bjz424gzafv6nzv98h0aqkwz3d9xhm7cbr1wfbyas8zayza";
      type = "gem";
    };
    version = "1.3";
  };
  dry-configurable = {
    dependencies = ["concurrent-ruby" "dry-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qzq7aaw020qq06d2lpjq03a3gqnkyya040fjgyfp5q3dlr9c44v";
      type = "gem";
    };
    version = "0.13.0";
  };
  dry-container = {
    dependencies = ["concurrent-ruby" "dry-configurable"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "059wgyhdaga895n8zkibksqyzcmkyg8n3lzy9dcmrl517r1n7in7";
      type = "gem";
    };
    version = "0.9.0";
  };
  dry-core = {
    dependencies = ["concurrent-ruby"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cf1y6vcxg20s6lrwndvbbq7wdpr4fj18f1875ni16sbx4crv3x8";
      type = "gem";
    };
    version = "0.7.1";
  };
  dry-inflector = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mhzq07hi4v8g3b90z9sqv41vb9hqalbqrnpvxjln7djq8gr4n5l";
      type = "gem";
    };
    version = "0.2.1";
  };
  dry-logic = {
    dependencies = ["concurrent-ruby" "dry-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vmijrag99mq9s1zgrp2ndd6mzf2flwa072z2bim4v18jmpj8wlm";
      type = "gem";
    };
    version = "1.2.0";
  };
  dry-struct = {
    dependencies = ["dry-core" "dry-types" "ice_nine"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wsc1wm5mnyxwnxrph00px1qjn37s52zv11d469shw7f25narhb3";
      type = "gem";
    };
    version = "1.4.0";
  };
  dry-types = {
    dependencies = ["concurrent-ruby" "dry-container" "dry-core" "dry-inflector" "dry-logic"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gv0s396lzxlr882qgwi90462wn6f99wq6g0y204r94i3yfh1lvd";
      type = "gem";
    };
    version = "1.5.1";
  };
  equatable = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sjm9zjakyixyvsqziikdrsqfzis6j3fq23crgjkp6fwkfgndj7x";
      type = "gem";
    };
    version = "0.5.0";
  };
  filesize = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17p7rf1x7h3ivaznb4n4kmxnnzj25zaviryqgn2n12v2kmibhp8g";
      type = "gem";
    };
    version = "0.2.0";
  };
  ice_nine = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nv35qg1rps9fsis28hz2cq2fx1i96795f91q4nmkm934xynll2x";
      type = "gem";
    };
    version = "0.11.2";
  };
  method_source = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pnyh44qycnf9mzi1j6fywd5fkskv3x7nmsqrrws0rjn5dd4ayfp";
      type = "gem";
    };
    version = "1.0.0";
  };
  necromancer = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0v9nhdkv6zrp7cn48xv7n2vjhsbslpvs0ha36mfkcd56cp27pavz";
      type = "gem";
    };
    version = "0.4.0";
  };
  pastel = {
    dependencies = ["equatable" "tty-color"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yf30d9kzpm96gw9kwbv31p0qigwfykn8qdis5950plnzgc1vlp1";
      type = "gem";
    };
    version = "0.7.2";
  };
  pry = {
    dependencies = ["coderay" "method_source"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m445x8fwcjdyv2bc0glzss2nbm1ll51bq45knixapc7cl3dzdlr";
      type = "gem";
    };
    version = "0.14.1";
  };
  terrapin = {
    dependencies = ["climate_control"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0p18f05r0c5s70571gqig3z2ym74wx79s6rd45sprp207bqskzn9";
      type = "gem";
    };
    version = "0.6.0";
  };
  tty = {
    dependencies = ["equatable" "pastel" "tty-color" "tty-command" "tty-cursor" "tty-editor" "tty-file" "tty-pager" "tty-platform" "tty-progressbar" "tty-prompt" "tty-screen" "tty-spinner" "tty-table" "tty-which"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cdkbli0yywqcyrws5flmk09ngdcyl6i8amrvpkzr280g02fqcmw";
      type = "gem";
    };
    version = "0.7.0";
  };
  tty-color = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zz5xa6xbrj69h334d8nx7z732fz80s1a0b02b53mim95p80s7bk";
      type = "gem";
    };
    version = "0.4.3";
  };
  tty-command = {
    dependencies = ["pastel"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yghcs11kcdz371jymks6hvqa8gj39i397ysiblhz03gs17k8gfd";
      type = "gem";
    };
    version = "0.4.0";
  };
  tty-cursor = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07whfm8mnp7l49s2cm2qy1snhsqq3a90sqwb71gvym4hm2kx822a";
      type = "gem";
    };
    version = "0.4.0";
  };
  tty-editor = {
    dependencies = ["tty-prompt" "tty-which"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0da28h5pdz2cah2hnrbgv5jb17dhh5ph4grwvdgbkzvcrqc7d35g";
      type = "gem";
    };
    version = "0.2.0";
  };
  tty-file = {
    dependencies = ["diff-lcs" "pastel" "tty-prompt"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gf9xs4jgpiwdwsi4k3kgdpqfr2vzr26q5b623l1kklxf46bd33s";
      type = "gem";
    };
    version = "0.3.0";
  };
  tty-pager = {
    dependencies = ["tty-screen" "tty-which" "verse"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1l44hnzscbw74as61qkhvzs9xwsj9jwdg90bydgjiz922ab7rir4";
      type = "gem";
    };
    version = "0.7.1";
  };
  tty-platform = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05vw1riaic99jsxjcgvsbmlijw6zaxyf5v6w3rb84id3rklhbdhn";
      type = "gem";
    };
    version = "0.1.0";
  };
  tty-progressbar = {
    dependencies = ["tty-screen"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1687a4dmfqynpq6j3pg6yq71537k2q37ih3dvial6ww6yk23xnk2";
      type = "gem";
    };
    version = "0.10.1";
  };
  tty-prompt = {
    dependencies = ["necromancer" "pastel" "tty-cursor" "wisper"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1026nyqhgmgxi2nmk8xk3hca07gy5rpisjs8y6w00wnw4f01kpv0";
      type = "gem";
    };
    version = "0.12.0";
  };
  tty-screen = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12qkjwpkgznvhwbywq2y7l5mcq2f4z404b0ip7xm4byg3827lh4h";
      type = "gem";
    };
    version = "0.5.1";
  };
  tty-spinner = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10bi0w01i11y18gs77yc3w7qibl6v0c5anixgnx03wbk3hi5ypm8";
      type = "gem";
    };
    version = "0.4.1";
  };
  tty-table = {
    dependencies = ["equatable" "necromancer" "pastel" "tty-screen" "unicode-display_width" "verse"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1j1nrwn06kqcvspnlxkx83xwgpnwgl18p115ikmmppl02wnivn47";
      type = "gem";
    };
    version = "0.8.0";
  };
  tty-which = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1a38al0v6nxnflqkjdn3pk8fbza3raj3yyx4fp16z6385vbngdbg";
      type = "gem";
    };
    version = "0.3.0";
  };
  unicode-display_width = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1r28mxyi0zwby24wyn1szj5hcnv67066wkv14wyzsc94bf04fqhx";
      type = "gem";
    };
    version = "1.1.3";
  };
  unicode_utils = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h1a5yvrxzlf0lxxa1ya31jcizslf774arnsd89vgdhk4g7x08mr";
      type = "gem";
    };
    version = "1.4.0";
  };
  verse = {
    dependencies = ["unicode-display_width" "unicode_utils"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1q7j993jvr8i9rkpf1c92jnr3qsjk7wws6mgfakibqci5crgd2jc";
      type = "gem";
    };
    version = "0.5.0";
  };
  wisper = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19bw0z1qw1dhv7gn9lad25hgbgpb1bkw8d599744xdfam158ms2s";
      type = "gem";
    };
    version = "1.6.1";
  };
}
