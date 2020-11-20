{ stdenv, fetchFromGitHub, xdelta, wiimms-iso-tools, gecko
, powerpc-eabi-assembling, ssbm, xxd }:

stdenv.mkDerivation rec {
  pname = "uncle-punch";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "UnclePunch";
    repo = "Training-Mode";
    rev = "v${version}";
    sha256 = "1ma5m3h1q70v0h9rm3ad69j0dwvk625iy0cvzzw0q4qw8nvw6c0i";
  };

  patchPhase = ''
    patch -u -p1 'Build TM Codeset/codes.json' < ${./fix-codes.patch}
  '';

  buildInputs =
    [ ssbm wiimms-iso-tools gecko xdelta powerpc-eabi-assembling xxd ];

  buildPhase = ''
    (cd 'Build TM Codeset' && gecko build)

    wit extract ${ssbm}/ssbm.iso ssbm-unpacked

    # main.dol (wit) -> Start.dol (GC-Rebuilder)
    xxd ssbm-unpacked/P-GALE/sys/main.dol > wit.hex
    patch -p0 < ${./fix-start-dol.patch}
    xxd -r wit.hex > Start.dol

    xdelta3 -d -f \
      -s Start.dol \
      'Build TM Start.dol/StartdolTMPatch.xdelta' \
      ssbm-unpacked/P-GALE/sys/Start.dol

    cp -rv 'Additional ISO Files/' ssbm-unpacked/P-GALE/files

    wit copy ssbm-unpacked uncle-punch.iso
  '';

  installPhase = ''
    install -Dm755 uncle-punch.iso -t $out/game
  '';
}
