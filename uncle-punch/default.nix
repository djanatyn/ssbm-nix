{ stdenv, fetchFromGitHub, xdelta, wiimms-iso-tools, gecko
, powerpc-eabi-assembling, ssbm }:

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

  buildInputs = [ ssbm wiimms-iso-tools gecko xdelta powerpc-eabi-assembling ];

  buildPhase = ''
    cd Build\ TM\ Codeset && gecko build
  '';

  installPhase = ''
    install -Dm755 ../Additional\ ISO\ Files/codes.gct -t $out
  '';
}
