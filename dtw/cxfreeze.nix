{
  stdenv,
  lib,
  python2,
  ncurses,
}:
python2.pkgs.buildPythonPackage rec {
  pname = "cx_Freeze";
  version = "6.4.1";

  src = python2.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "2eadddde670f5c5f6cf88638a0ac4e5d5fe181292a31063275fa56c7bf22426b";
  };

  propagatedBuildInputs = [
    python2.pkgs.importlib-metadata
    ncurses
  ];

  # timestamp need to come after 1980 for zipfiles and nix store is set to epoch
  prePatch = ''
    substituteInPlace cx_Freeze/freezer.py --replace "os.stat(module.file).st_mtime" "time.time()"
  '';

  # fails to find Console even though it exists on python 3.x
  doCheck = false;

  meta = with lib; {
    description = "A set of scripts and modules for freezing Python scripts into executables";
    homepage = "http://cx-freeze.sourceforge.net/";
    license = licenses.psfl;
  };
}
