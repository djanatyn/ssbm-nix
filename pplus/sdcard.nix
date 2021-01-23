{ stdenv, fetchzip }:
stdenv.mkDerivation {
  name = "pplus-sdcard";
  version = "2.15";

  # mirror of mediafire link
  src = fetchzip (let
    sdCardFileName = "ProjectPlusSdCard215.tar.gz";
  in {
    url = "https://archive.org/download/project-plus-sd-card-215/${sdCardFileName}";
    sha256 = "G7lomc2YGohEMpuh6XFuhW+YHEbBh3Hc9G+/c9xu9JY=";
  });

  buildPhase = "";

  installPhase = ''
    mkdir -p $out
    cp sd.raw $out
  '';

}
