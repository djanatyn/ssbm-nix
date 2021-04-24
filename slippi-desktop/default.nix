{ appimageTools, gsettings-desktop-schemas, gtk3, fetchurl }:
let version = "1.6.8";
in appimageTools.wrapType2 rec {
  name = "slippi-desktop";
  src = fetchurl {
    url =
      "https://github.com/project-slippi/slippi-desktop-app/releases/download/v1.6.8/Slippi-Launcher-${version}-x86_64.AppImage";
    sha256 = "0phwiwhl0pzxw3hs4bmi1zfi8vq2agnaba9jfmznycvjvsh73wiy";
  };

  # magic I found at https://discourse.nixos.org/t/failure-appimage-run-with-gsetting/4403/2
  # to get the popups for selecting files to work
  profile = ''
    export LC_ALL=C.UTF-8
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
  '';
}
