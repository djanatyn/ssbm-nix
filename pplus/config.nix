{
  stdenv,
  fetchFromGitHub,
  tree,
}: let
  configTarName = "2.15-fppconfig.tar.gz";
in
  stdenv.mkDerivation {
    buildInputs = [tree];

    name = "projectplus-config";
    version = "2.15";

    src = fetchFromGitHub {
      owner = "Birdthulu";
      repo = "FPM-Installer";
      rev = "27f0aa0094d2f6b9ae36161875b611b3df4de1e5";
      sha256 = "RWF4/53NsgKXwaTXf4EPXN6Aq1BOVT0K6MNF1VeQqUk=";
    };

    sourceRoot = "source/config";

    buildPhase = ''
      mkdir configDir
      cd configDir
      tar xf ../${configTarName}
    '';

    installPhase = ''
      mkdir $out
      cp -rf Binaries $out/
    '';
  }
