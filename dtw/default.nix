{
  stdenv,
  fetchFromGitHub,
  python27,
  cxfreeze,
}:
python27.pkgs.buildPythonApplication rec {
  pname = "dat-texture-wizard";
  version = "6.1.2";

  src = fetchFromGitHub {
    owner = "DRGN-DRC";
    repo = "DAT-Texture-Wizard";
    rev = "2d24da20bf833362a6bda0d51b6e1cd4ada92f3a";
    sha256 = "kYLrbmlx1HbWRm+Y+arTrWp4F2pIJaxhFjKTMTG7e1E=";
  };

  propagatedBuildInputs = with python27.pkgs; [pillow psutil cxfreeze cffi];

  meta.broken = true;
}
