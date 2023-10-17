{
  stdenv,
  lib,
  fetchFromGitHub,
  coreutils,
  zlib,
  ncurses,
  fuse,
}:
stdenv.mkDerivation rec {
  name = "wiimms-iso-tools";
  version = "3.03b";

  src = fetchFromGitHub {
    owner = "Wiimm";
    repo = name;
    rev = "7f41a7f1edf2bd1698482cafe1b10f6b87b73da7";
    sha256 = "1vhsi87vwjnmvnwjw8gnqqh9wishzcx885kwxm5j51zizl1mhqi9";
  };

  buildInputs = [zlib ncurses fuse];

  sourceRoot = "source/project";

  patches = [./fix-paths.diff];
  postPatch = ''
    sed -ie 's|/usr/bin/env|${coreutils}/bin/env|' gen-template.sh
    sed -ie 's|/usr/bin/env|${coreutils}/bin/env|' gen-text-file.sh
  '';

  NIX_CFLAGS_COMPILE = "-Wno-error=format-security";
  INSTALL_PATH = "$out";

  installPhase = ''
    mkdir "$out"
    patchShebangs install.sh
    ./install.sh --no-sudo
  '';
}
