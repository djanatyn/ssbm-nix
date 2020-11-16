{ stdenv, fetchFromGitHub, xdelta, wiimms-iso-tools, gecko
, powerpc-eabi-assembling, ssbm }:

stdenv.mkDerivation rec {
  pname = "uncle-punch-unstable";
  version = "2020-11-16";

  src = fetchFromGitHub {
    owner = "UnclePunch";
    repo = "Training-Mode";
    rev = "0b65c5581d18b847ac2465c91b4a1b1532a02738";
    sha256 = "120z6wq728ga1my32jsmq5rd699xjldas2f8pkvsa5grqym4kcxn";
  };

  buildInputs = [ ssbm wiimms-iso-tools gecko xdelta powerpc-eabi-assembling ];

  buildPhase = ''
    cd Build\ TM\ Codeset/mac
    gecko build
  '';

  installPhase = null;
}
