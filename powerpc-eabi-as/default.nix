{
  stdenv,
  fetchFromGitHub,
  zlib,
  autoPatchelfHook,
}:
stdenv.mkDerivation rec {
  name = "powerpc-eabi-assembling";
  pname = "${name}-unstable";
  version = "2017-01-26";

  src = fetchFromGitHub {
    owner = "BullyWiiPlaza";
    repo = "power-pc-eabi-assembling";
    rev = "440b3d359aa00c73828577ef0c4cbdcd62ba0672";
    sha256 = "0b20qirmkbjp78v1jkmsw7ly7w9r93c2ydc8xgv8fcli12d2ppsq";
  };

  sourceRoot = "source/Linux";

  nativeBuildInputs = [zlib autoPatchelfHook];
  installPhase = ''
    install -Dm755 powerpc-eabi-as -t $out/bin
    install -Dm755 powerpc-eabi-objcopy -t $out/bin
  '';
}
