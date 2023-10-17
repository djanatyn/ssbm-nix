{
  stdenv,
  fetchFromGitHub,
  fetchpatch,
}:
stdenv.mkDerivation {
  pname = "gcmtool";
  version = "unstable-2020-11-24";

  src = fetchFromGitHub {
    owner = "djanatyn";
    repo = "gcmtool";
    rev = "a22076cb69518301c3562a6f81b5c29765f2418a";
    sha256 = "1nfqj6bg390jk3fphvp4bh6kj6xnx29vr6dh6gqv96180i2fddcz";
  };
}
