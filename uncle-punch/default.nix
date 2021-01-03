{ stdenv, fetchFromGitHub, xdelta, wiimms-iso-tools, gecko
, powerpc-eabi-assembling, ssbm, xxd }:

stdenv.mkDerivation rec {
  pname = "uncle-punch";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "UnclePunch";
    repo = "Training-Mode";
    rev = "v${version}";
    sha256 = "Ck8AAsxSIl/qLKzf2CtiHdmcSZIouHHEBywVhWd1KRQ="; # 2.0
#   sha256 = "ETDDt0UcEwz4/5sBH4swc/MGZDJNjZoTBBscHOCoRdU="; # 1.1
  };

  patchPhase = ''
    sed -ie 's|\\\\|/|g' Build\ TM\ Codeset/codes.json
  '';

  buildInputs =
    [ ssbm wiimms-iso-tools gecko xdelta powerpc-eabi-assembling xxd ];

  buildPhase = ''
    (cd 'Build TM Codeset' && gecko build)

    wit extract ${ssbm}/ssbm.iso ssbm-unpacked

    # main.dol (wit) -> Start.dol (GC-Rebuilder)
    echo 'converting main.dol to Start.dol'
    xxd ssbm-unpacked/P-GALE/sys/main.dol > wit.hex
    patch -p0 < ${./fix-start-dol.patch}
    xxd -r wit.hex > Start.dol
    echo 'Converted main.dol to Start.dol!'

    xdelta3 -d -f \
      -s Start.dol \
      'Build TM Start.dol/StartdolTMPatch.xdelta' \
      ssbm-unpacked/P-GALE/sys/Start.dol

    mv Additional\ ISO\ Files ssbm-unpacked/P-GALE/files

    wit copy ssbm-unpacked uncle-punch.iso
  '';

  installPhase = ''
    install -Dm755 uncle-punch.iso -t $out/game
  '';
}
