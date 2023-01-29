# https://download.brother.com/welcome/dlf103934/mfcl3750cdwpdrv-1.0.2-0.i386.deb

{ lib
, stdenv
, fetchurl
, dpkg
, autoPatchelfHook
, makeWrapper
, perl
, gnused
, ghostscript
, file
, coreutils
, gnugrep
, which
}:

let
  runtimeDeps = [
    ghostscript
    file
    gnused
    gnugrep
    coreutils
    which
  ];
in

stdenv.mkDerivation rec {
  pname = "cups-brother-mfcl3750cdw";
  version = "1.0.2-0";

  nativeBuildInputs = [ dpkg makeWrapper autoPatchelfHook ];
  buildInputs = [ perl ];

  dontUnpack = true;

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf103934/mfcl3750cdwpdrv-${version}.i386.deb";
    sha256 = "02srx2myyh8ix1xk5ymylk3r9hkf50vfyrl23gfqy835l84my39s";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    dpkg-deb -x $src $out

    # Fix global references and replace auto discovery mechanism with hardcoded values
    substituteInPlace $out/opt/brother/Printers/mfcl3750cdw/lpd/filter_mfcl3750cdw \
      --replace /opt "$out/opt" \
      --replace "my \$BR_PRT_PATH =" "my \$BR_PRT_PATH = \"$out/opt/brother/Printers/mfcl3750cdw\"; #" \
      --replace "PRINTER =~" "PRINTER = \"mfcl3750cdw\"; #"

    # Make sure all executables have the necessary runtime dependencies available
    find "$out" -executable -and -type f | while read file; do
      wrapProgram "$file" --prefix PATH : "${lib.makeBinPath runtimeDeps}"
    done

    # Symlink filter and ppd into a location where CUPS will discover it
    mkdir -p $out/lib/cups/filter
    mkdir -p $out/share/cups/model

    ln -s \
      $out/opt/brother/Printers/mfcl3750cdw/lpd/filter_mfcl3750cdw \
      $out/lib/cups/filter/brother_lpdwrapper_mfcl3750cdw

    ln -s \
      $out/opt/brother/Printers/mfcl3750cdw/cupswrapper/brother_mfcl3750cdw_printer_en.ppd \
      $out/share/cups/model/

    runHook postInstall
  '';
}
