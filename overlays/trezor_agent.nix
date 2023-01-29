channels: final: _: {
  trezor-gpg-pinentry-tk = channels.master.python3Packages.callPackage
    ({ buildPythonPackage, setuptools, tkinter }: buildPythonPackage {
      inherit (final.sources.trezor-gpg-pinentry-tk) src pname version;
      propagatedBuildInputs = [ setuptools tkinter ];
      doCheck = false;
    })
    { };

  trezor_agent_recover_libagent = channels.master.python3Packages.callPackage
    ({ python3Packages
     , bech32
     , cryptography
     , ed25519
     , ecdsa
     , semver
     , mnemonic
     , unidecode
     , mock
     , pytest
     , backports-shutil-which
     , configargparse
     , python-daemon
     , pymsgbox
     , pynacl
     }:
      python3Packages.buildPythonPackage {
        inherit (final.sources.trezor-agent-subkeys) src version;

        pname = "libagent";

        propagatedBuildInputs = [
          unidecode
          backports-shutil-which
          configargparse
          python-daemon
          pymsgbox
          ecdsa
          ed25519
          mnemonic
          semver
          pynacl
          bech32
          cryptography
        ];

        checkInputs = [ mock pytest ];

        checkPhase = ''
          py.test libagent/tests
        '';

      })
    { };

  trezor_agent_recover = channels.master.python3Packages.callPackage
    ({ buildPythonPackage, python3Packages, gnupg, gnused }: buildPythonPackage {
      inherit (final.sources.trezor-agent-subkeys) src version;
      pname = "trezor_agent_recover";

      format = "other";
      doCheck = false;

      propagatedBuildInputs = with python3Packages; [
        setuptools
        typing-extensions
        ecdsa
        final.trezor_agent_recover_libagent
        # pycrypto
        gnupg
      ];

      buildPhase = ''
        echo DUMMY-BUILD-PHASE
      '';

      installPhase = ''
        mkdir -p $out/bin
        cat $src/contrib/trezor_agent_recover.py \
          | sed 's|/usr/bin/env python3|${python3Packages.python}/bin/python|g' > $out/bin/trezor_agent_recover
        chmod 0755 $out/bin/trezor_agent_recover
      '';
    })
    { };

  trezor_agent_fresh = channels.master.python3Packages.callPackage
    ({ lib
     , buildPythonPackage
     , trezor
     , libagent
     , ecdsa
     , ed25519
     , mnemonic
     , keepkey
     , semver
     , setuptools
     , wheel
     , pinentry

     , mock
     , pytest
     , onlykey
     , pycodestyle
     , coverage
     , pylint
     , pydocstyle
     , isort
     , ledgerblue

     , onlykey-solo-python
     }:

      buildPythonPackage rec {
        pname = "trezor_agent";

        inherit (final.sources.trezor-agent) src version;

        propagatedBuildInputs = [
          setuptools
          trezor
          libagent
          ecdsa
          ed25519
          mnemonic
          keepkey
          semver
          wheel
          pinentry

          mock
          pytest
          onlykey
          pycodestyle
          coverage
          pylint
          pydocstyle
          isort
          ledgerblue

          onlykey-solo-python
        ];

        #pipInstallFlags = [];

        # postPatch = ''
        #   substituteInPlace setup.py \
        #     --replace "trezor[hidapi]>=0.12.0,<0.13" "trezor[hidapi]>=0.12.0,<0.14"
        # '';

        # postInstall = ''
        #   mkdir -p $out/shit
        #   python3 setup.py sdist
        # '';

        doCheck = false;
        pythonImportsCheck = [ "libagent" ];
      }
    )
    { };
}
