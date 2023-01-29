{ buildFirefoxXpiAddon, fetchurl, lib, stdenv }:
  {
    "absolute-enable-right-click" = buildFirefoxXpiAddon {
      pname = "absolute-enable-right-click";
      version = "1.3.8";
      addonId = "{9350bc42-47fb-4598-ae0f-825e3dd9ceba}";
      url = "https://addons.mozilla.org/firefox/downloads/file/1205179/absolute_enable_right_click-1.3.8.xpi";
      sha256 = "d1ca76d23234e6fd0f5d521caef62d20d071c8806887cda89914fd8325715a0a";
      meta = with lib;
      {
        description = "Force Enable Right Click &amp; Copy";
        license = licenses.bsd2;
        platforms = platforms.all;
        };
      };
    "browserpass-ce" = buildFirefoxXpiAddon {
      pname = "browserpass-ce";
      version = "3.7.2";
      addonId = "browserpass@maximbaz.com";
      url = "https://addons.mozilla.org/firefox/downloads/file/3711209/browserpass_ce-3.7.2.xpi";
      sha256 = "b1781405b46f3274697885b53139264dca2ab56ffc4435c093102ad5ebc59297";
      meta = with lib;
      {
        homepage = "https://github.com/browserpass/browserpass-extension";
        description = "Browserpass is a browser extension for Firefox and Chrome to retrieve login details from zx2c4's pass (<a href=\"https://prod.outgoing.prod.webservices.mozgcp.net/v1/fcd8dcb23434c51a78197a1c25d3e2277aa1bc764c827b4b4726ec5a5657eb64/http%3A//passwordstore.org\" rel=\"nofollow\">passwordstore.org</a>) straight from your browser. Tags: passwordstore, password store, password manager, passwordmanager, gpg";
        license = licenses.isc;
        platforms = platforms.all;
        };
      };
    "bukubrow" = buildFirefoxXpiAddon {
      pname = "bukubrow";
      version = "5.0.3.0";
      addonId = "bukubrow@samhh.com";
      url = "https://addons.mozilla.org/firefox/downloads/file/3769984/bukubrow-5.0.3.0.xpi";
      sha256 = "4c9424d0f13df8f1f6ac605302c42bb30f3c138eb76c8d4ced5d45a637942913";
      meta = with lib;
      {
        homepage = "https://github.com/samhh/bukubrow";
        description = "Synchronise your browser bookmarks with Buku";
        license = licenses.gpl3;
        platforms = platforms.all;
        };
      };
    "canvasblocker" = buildFirefoxXpiAddon {
      pname = "canvasblocker";
      version = "1.8";
      addonId = "CanvasBlocker@kkapsner.de";
      url = "https://addons.mozilla.org/firefox/downloads/file/3910598/canvasblocker-1.8.xpi";
      sha256 = "817a6181be877668eca1d0fef9ecf789c898e6d7d93dca7e29479d40f986c844";
      meta = with lib;
      {
        homepage = "https://github.com/kkapsner/CanvasBlocker/";
        description = "Alters some JS APIs to prevent fingerprinting.";
        license = licenses.mpl20;
        platforms = platforms.all;
        };
      };
    "clearurls" = buildFirefoxXpiAddon {
      pname = "clearurls";
      version = "1.26.0";
      addonId = "{74145f27-f039-47ce-a470-a662b129930a}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4032442/clearurls-1.26.0.xpi";
      sha256 = "222ce5056b79db8d3b574a98ce359902786a6cbb3939ddace254ed15688cee55";
      meta = with lib;
      {
        homepage = "https://clearurls.xyz/";
        description = "Removes tracking elements from URLs";
        license = licenses.lgpl3;
        platforms = platforms.all;
        };
      };
    "cookie-autodelete" = buildFirefoxXpiAddon {
      pname = "cookie-autodelete";
      version = "3.8.2";
      addonId = "CookieAutoDelete@kennydo.com";
      url = "https://addons.mozilla.org/firefox/downloads/file/4040738/cookie_autodelete-3.8.2.xpi";
      sha256 = "b02438aa5df2a79eb743da1b629b80d8c48114c9d030abb5538b591754e30f74";
      meta = with lib;
      {
        homepage = "https://github.com/Cookie-AutoDelete/Cookie-AutoDelete";
        description = "Control your cookies! This WebExtension is inspired by Self Destructing Cookies. When a tab closes, any cookies not being used are automatically deleted. Keep the ones you trust (forever/until restart) while deleting the rest. Containers Supported";
        license = licenses.mit;
        platforms = platforms.all;
        };
      };
    "decentraleyes" = buildFirefoxXpiAddon {
      pname = "decentraleyes";
      version = "2.0.17";
      addonId = "jid1-BoFifL9Vbdl2zQ@jetpack";
      url = "https://addons.mozilla.org/firefox/downloads/file/3902154/decentraleyes-2.0.17.xpi";
      sha256 = "e7f16ddc458eb2bc5bea75832305895553fca53c2565b6f1d07d5d9620edaff1";
      meta = with lib;
      {
        homepage = "https://decentraleyes.org";
        description = "Protects you against tracking through \"free\", centralized, content delivery. It prevents a lot of requests from reaching networks like Google Hosted Libraries, and serves local files to keep sites from breaking. Complements regular content blockers.";
        license = licenses.mpl20;
        platforms = platforms.all;
        };
      };
    "duckduckgo-for-firefox" = buildFirefoxXpiAddon {
      pname = "duckduckgo-for-firefox";
      version = "2023.1.12";
      addonId = "jid1-ZAdIEUB7XOzOJw@jetpack";
      url = "https://addons.mozilla.org/firefox/downloads/file/4055931/duckduckgo_for_firefox-2023.1.12.xpi";
      sha256 = "94605b42bd014cc724ed9beb25991bf7c0e7e3986f2d3863b92247e420cd5b88";
      meta = with lib;
      {
        homepage = "https://duckduckgo.com/app";
        description = "Simple and seamless privacy protection for your browser: tracker blocking, cookie protection, DuckDuckGo private search, email protection, HTTPS upgrading, and much more.";
        platforms = platforms.all;
        };
      };
    "enterprise-policy-generator" = buildFirefoxXpiAddon {
      pname = "enterprise-policy-generator";
      version = "5.1.0";
      addonId = "enterprise-policy-generator@agenedia.com";
      url = "https://addons.mozilla.org/firefox/downloads/file/3515849/enterprise_policy_generator-5.1.0.xpi";
      sha256 = "84eaf6e2f318619b5c76b5e65b3be0d4006b16323ddf7870417b0100674e2659";
      meta = with lib;
      {
        homepage = "https://www.soeren-hentzschel.at/firefox-webextensions/enterprise-policy-generator/";
        description = "The Enterprise Policy Engine allows administrators to configure Firefox via a configuration file. The Enterprise Policy Generator helps to create the configuration file.";
        license = licenses.mpl20;
        platforms = platforms.all;
        };
      };
    "ether-metamask" = buildFirefoxXpiAddon {
      pname = "ether-metamask";
      version = "10.22.2";
      addonId = "webextension@metamask.io";
      url = "https://addons.mozilla.org/firefox/downloads/file/4037096/ether_metamask-10.22.2.xpi";
      sha256 = "1be33024339cb1ac584945e36a11c99a45a78cb790d16bde9fc0d4fe519e3330";
      meta = with lib;
      {
        description = "Ethereum Browser Extension";
        platforms = platforms.all;
        };
      };
    "export-tabs-urls-and-titles" = buildFirefoxXpiAddon {
      pname = "export-tabs-urls-and-titles";
      version = "0.2.12";
      addonId = "{17165bd9-9b71-4323-99a5-3d4ce49f3d75}";
      url = "https://addons.mozilla.org/firefox/downloads/file/3398882/export_tabs_urls_and_titles-0.2.12.xpi";
      sha256 = "ff71ff6e300bf00e02ba79e127073f918aec79f951b749b2f06add006e773ac9";
      meta = with lib;
      {
        homepage = "https://github.com/alct/export-tabs-urls";
        description = "List the URLs of all the open tabs and copy that list to clipboard or export it to a file.\n\nFeatures:\n- include titles\n- custom format (e.g. markdown, html…)\n- filter tabs\n- limit to current window\n- list non-HTTP(s) URLs\n- ignore pinned tabs";
        license = licenses.gpl3;
        platforms = platforms.all;
        };
      };
    "grasp" = buildFirefoxXpiAddon {
      pname = "grasp";
      version = "0.7.1";
      addonId = "{37e42980-a7c9-473c-96d5-13f18e0efc74}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4049682/grasp-0.7.1.xpi";
      sha256 = "a1cbebda55072e2c98242387d86fc51e9c9a9e9b7e72cac23be4757556acc370";
      meta = with lib;
      {
        homepage = "https://github.com/karlicoss/grasp";
        description = "A reliable way of capturing and tagging web pages and content";
        license = licenses.mit;
        platforms = platforms.all;
        };
      };
    "languagetool" = buildFirefoxXpiAddon {
      pname = "languagetool";
      version = "6.0.1";
      addonId = "languagetool-webextension@languagetool.org";
      url = "https://addons.mozilla.org/firefox/downloads/file/4034972/languagetool-6.0.1.xpi";
      sha256 = "a72439258d7e937625b762ab4e35e27d80bddbb1bf9c57947e65ec94d8587e79";
      meta = with lib;
      {
        homepage = "https://languagetool.org";
        description = "With this extension you can check text with the free style and grammar checker LanguageTool. It finds many errors that a simple spell checker cannot detect, like mixing up there/their, a/an, or repeating a word.";
        platforms = platforms.all;
        };
      };
    "multi-account-containers" = buildFirefoxXpiAddon {
      pname = "multi-account-containers";
      version = "8.1.2";
      addonId = "@testpilot-containers";
      url = "https://addons.mozilla.org/firefox/downloads/file/4058426/multi_account_containers-8.1.2.xpi";
      sha256 = "0ab8f0222853fb68bc05fcf96401110910dfeb507aaea2cf88c5cd7084d167fc";
      meta = with lib;
      {
        homepage = "https://github.com/mozilla/multi-account-containers/#readme";
        description = "Firefox Multi-Account Containers lets you keep parts of your online life separated into color-coded tabs. Cookies are separated by container, allowing you to use the web with multiple accounts and integrate Mozilla VPN for an extra layer of privacy.";
        license = licenses.mpl20;
        platforms = platforms.all;
        };
      };
    "org-capture" = buildFirefoxXpiAddon {
      pname = "org-capture";
      version = "0.2.1";
      addonId = "{ddefd400-12ea-4264-8166-481f23abaa87}";
      url = "https://addons.mozilla.org/firefox/downloads/file/1127481/org_capture-0.2.1.xpi";
      sha256 = "5683ee1ebfafc24abc2d759c7180c4e839c24fa90764d8cf3285c5d72fc81f0a";
      meta = with lib;
      {
        homepage = "https://github.com/sprig/org-capture-extension";
        description = "A helper for capturing things via org-protocol in emacs: First, set up: <a rel=\"nofollow\" href=\"https://prod.outgoing.prod.webservices.mozgcp.net/v1/04ad17418f8d35ee0f3edf4599aed951b2a5ef88d4bc7e0e3237f6d86135e4fb/http%3A//orgmode.org/worg/org-contrib/org-protocol.html\">http://orgmode.org/worg/org-contrib/org-protocol.html</a> or <a rel=\"nofollow\" href=\"https://prod.outgoing.prod.webservices.mozgcp.net/v1/fb401af8127ccf82bc948b0a7af0543eec48d58100c0c46404f81aabeda442e6/https%3A//github.com/sprig/org-capture-extension\">https://github.com/sprig/org-capture-extension</a>\n\nSee <a rel=\"nofollow\" href=\"https://prod.outgoing.prod.webservices.mozgcp.net/v1/6aad51cc4e2f9476f9fff344e6554eade08347181aed05f8b61cda05073daecb/https%3A//youtu.be/zKDHto-4wsU\">https://youtu.be/zKDHto-4wsU</a> for example usage";
        license = licenses.mit;
        platforms = platforms.all;
        };
      };
    "passff" = buildFirefoxXpiAddon {
      pname = "passff";
      version = "1.14";
      addonId = "passff@invicem.pro";
      url = "https://addons.mozilla.org/firefox/downloads/file/3939178/passff-1.14.xpi";
      sha256 = "23ec6c09b499d35db1c028e5455c760dc4421d92365ce8a923080faf486b5e33";
      meta = with lib;
      {
        homepage = "https://github.com/passff/passff";
        description = "Add-on that allows users of the unix password manager 'pass' (see <a href=\"https://prod.outgoing.prod.webservices.mozgcp.net/v1/24f646fb865abe6edf9e3f626db62565bfdc2e7819ab33a5b4c30a9573787988/https%3A//www.passwordstore.org/\" rel=\"nofollow\">https://www.passwordstore.org/</a>) to access their password store from Firefox";
        license = licenses.gpl2;
        platforms = platforms.all;
        };
      };
    "privacy-badger17" = buildFirefoxXpiAddon {
      pname = "privacy-badger17";
      version = "2022.9.27";
      addonId = "jid1-MnnxcxisBPnSXQ@jetpack";
      url = "https://addons.mozilla.org/firefox/downloads/file/4008174/privacy_badger17-2022.9.27.xpi";
      sha256 = "8a0e456dfac801ea437164192f0a0659ee7227a519db97aceeb221f48f74d44a";
      meta = with lib;
      {
        homepage = "https://privacybadger.org/";
        description = "Automatically learns to block invisible trackers.";
        license = licenses.gpl3;
        platforms = platforms.all;
        };
      };
    "promnesia" = buildFirefoxXpiAddon {
      pname = "promnesia";
      version = "1.1.2";
      addonId = "{07c6b8e1-94f7-4bbf-8e91-26c0a8992ab5}";
      url = "https://addons.mozilla.org/firefox/downloads/file/3953419/promnesia-1.1.2.xpi";
      sha256 = "342a1025aa3a282c9dc088fe2b5225d316208d996f2164c81831f7efaed7058d";
      meta = with lib;
      {
        homepage = "https://github.com/karlicoss/promnesia";
        description = "Enhancement of your browsing history";
        license = licenses.mit;
        platforms = platforms.all;
        };
      };
    "reduxdevtools" = buildFirefoxXpiAddon {
      pname = "reduxdevtools";
      version = "2.17.1";
      addonId = "extension@redux.devtools";
      url = "https://addons.mozilla.org/firefox/downloads/file/1509811/reduxdevtools-2.17.1.xpi";
      sha256 = "649d780d19201b2607347c4f57b5b57b237624b2c0ed322af9575cf791cce326";
      meta = with lib;
      {
        homepage = "https://github.com/reduxjs/redux-devtools";
        description = "DevTools for Redux with actions history, undo and replay.";
        license = licenses.mit;
        platforms = platforms.all;
        };
      };
    "russian-spellchecking-dic-3703" = buildFirefoxXpiAddon {
      pname = "russian-spellchecking-dic-3703";
      version = "0.4.5.1webext";
      addonId = "ru@dictionaries.addons.mozilla.org";
      url = "https://addons.mozilla.org/firefox/downloads/file/1163927/russian_spellchecking_dic_3703-0.4.5.1webext.xpi";
      sha256 = "8681bfbc86a8aa2c211638b97792dca42e3599f79b6cf456b32aebea711c0f1a";
      meta = with lib;
      {
        homepage = "http://www.mozilla-russia.org";
        description = "Russian spellchecking dictionary";
        license = licenses.bsd2;
        platforms = platforms.all;
        };
      };
    "swisscows-search" = buildFirefoxXpiAddon {
      pname = "swisscows-search";
      version = "1.4";
      addonId = "swisscows@swisscows.ch";
      url = "https://addons.mozilla.org/firefox/downloads/file/3729573/swisscows_search-1.4.xpi";
      sha256 = "a7e104f230be11733e2cdda556ba2fe423cf6c883a7150c9c078c516b3b183db";
      meta = with lib;
      {
        description = "Adds Swisscows as the default search engine in your browser.";
        license = licenses.mit;
        platforms = platforms.all;
        };
      };
    "temporary-containers" = buildFirefoxXpiAddon {
      pname = "temporary-containers";
      version = "1.9.2";
      addonId = "{c607c8df-14a7-4f28-894f-29e8722976af}";
      url = "https://addons.mozilla.org/firefox/downloads/file/3723251/temporary_containers-1.9.2.xpi";
      sha256 = "3340a08c29be7c83bd0fea3fc27fde71e4608a4532d932114b439aa690e7edc0";
      meta = with lib;
      {
        homepage = "https://github.com/stoically/temporary-containers";
        description = "Open tabs, websites, and links in automatically managed disposable containers which isolate the data websites store (cookies, storage, and more) from each other, enhancing your privacy and security while you browse.";
        license = licenses.mit;
        platforms = platforms.all;
        };
      };
    "ublock-origin" = buildFirefoxXpiAddon {
      pname = "ublock-origin";
      version = "1.46.0";
      addonId = "uBlock0@raymondhill.net";
      url = "https://addons.mozilla.org/firefox/downloads/file/4047353/ublock_origin-1.46.0.xpi";
      sha256 = "6bf8af5266353fab5eabdc7476de026e01edfb7901b0430c5e539f6791f1edc8";
      meta = with lib;
      {
        homepage = "https://github.com/gorhill/uBlock#ublock-origin";
        description = "Finally, an efficient wide-spectrum content blocker. Easy on CPU and memory.";
        license = licenses.gpl3;
        platforms = platforms.all;
        };
      };
    "ugetintegration" = buildFirefoxXpiAddon {
      pname = "ugetintegration";
      version = "2.1.3.1";
      addonId = "uget-integration@slgobinath";
      url = "https://addons.mozilla.org/firefox/downloads/file/911315/ugetintegration-2.1.3.1.xpi";
      sha256 = "235f29ca5df79e4e5a338e29ef7cd721bb7873309b56364cc7a4bf4612e1ae85";
      meta = with lib;
      {
        homepage = "https://github.com/ugetdm/uget-integrator";
        description = "Integrate Mozilla Firefox with uGet download manager.\nPlease note that \"uget-chrome-wrapper\" has been renamed to \"uget-integrator\".\n<a rel=\"nofollow\" href=\"https://prod.outgoing.prod.webservices.mozgcp.net/v1/e231fe36249ab4182cf0474166b098eb0ac98e7813be8faff0618be919e234f3/https%3A//github.com/ugetdm/uget-integrator\">https://github.com/ugetdm/uget-integrator</a>";
        license = licenses.lgpl3;
        platforms = platforms.all;
        };
      };
    "umatrix" = buildFirefoxXpiAddon {
      pname = "umatrix";
      version = "1.4.4";
      addonId = "uMatrix@raymondhill.net";
      url = "https://addons.mozilla.org/firefox/downloads/file/3812704/umatrix-1.4.4.xpi";
      sha256 = "1de172b1d82de28c334834f7b0eaece0b503f59e62cfc0ccf23222b8f2cb88e5";
      meta = with lib;
      {
        homepage = "https://github.com/gorhill/uMatrix";
        description = "Point &amp; click to forbid/allow any class of requests made by your browser. Use it to block scripts, iframes, ads, facebook, etc.";
        license = licenses.gpl3;
        platforms = platforms.all;
        };
      };
    }