{ lib, stdenv, fetchFromGitLab, libevdev, keyb0xxconfig ? builtins.readFile ./config.h }:

stdenv.mkDerivation rec {

  config_h = builtins.toFile "config.h" keyb0xxconfig;

  pname = "keyb0xx";
  version = "git";
  src = fetchFromGitLab {

    owner = "liamjen";
    repo = "keyb0xx";
    rev = "b2e53a2c5bca808c08b235327ffd76494ad23b32";
    sha256 = "bWHddDxUPDMU+Y9c+RYZxCPnPruU1Cx86ASYBVDrulM=";

  };

  buildInputs = [ libevdev ];

  NIX_CFLAGS_COMPILE = [ "-I${libevdev}/include/libevdev-1.0" ];

  patchPhase = ''
    cp $config_h config.h
  '';

  installPhase = ''
    mkdir -p $out
    cp -rf * $out/
  '';

}
