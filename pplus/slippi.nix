{ stdenv, gcc, fetchFromGitHub
, mesa_drivers, mesa_glu, mesa, pkgconfig, cmake, bluez, ffmpeg, libao, libGLU
, gtk2, gtk3, glib, gettext, xorg, readline, openal, libevdev, portaudio, libusb
, libpulseaudio, udev, gnumake, wxGTK30, gdk-pixbuf, soundtouch, miniupnpc
, mbedtls, curl, lzo, sfml, enet, xdg_utils, hidapi, webkitgtk
, projectplus-sdcard, projectplus-config, tree }:
stdenv.mkDerivation rec {

## TODO
# - fix hash for netplay??
# - maybe include discextractor patch?

  name = "projectplus-slippi";
  version = "2.15";
  rev = "d6800a124dbba118e297188900d07adfea661b87";

  src = fetchFromGitHub {
    inherit rev;
    owner = "Birdthulu";
    repo = "Ishiiruka";
    sha256 = "sO3AMbKk1SaZapPeZzAa8DjePTRbfYzE7MiFQ5st3mY=";
  };

  patchPhase = ''
    sed -i 's|\$\\{GIT_EXECUTABLE} rev-parse HEAD|echo ${rev}|g' CMakeLists.txt
    sed -i 's|\$\\{GIT_EXECUTABLE} describe --always --long --dirty|echo FM v${version}|g' CMakeLists.txt
    sed -i 's|\$\\{GIT_EXECUTABLE} rev-parse --abbrev-ref HEAD|echo HEAD|g' CMakeLists.txt
    sed -i 's|#include <optional>|#include <optional>\n#include <string>|g' Source/Core/DiscIO/DiscExtractor.h
    cp Externals/wxWidgets3/include/wx Source/Core/ -r
    cp Externals/wxWidgets3/wx/* Source/Core/wx/
  '';

  installPhase = ''
    cp -rf ${projectplus-config}/Binaries/* Binaries/
    mkdir -p Binaries/User/Wii
#   tee < ${projectplus-sdcard}/sd.raw > Binaries/User/Wii/sd.raw
    install -D -m 755 ${projectplus-sdcard}/sd.raw Binaries/User/Wii
    mkdir -p $out
    cp Binaries/ $out/ -r
    tree > $out/files.txt
    tree $out > $out/outtree.txt
  '';
#   sed -i -e "s|LauncherDir|${LauncherDir}|" $ConfigPath
#   sed -i -e "s|GamesPath|${GamesDir}|" $ConfigPath
#   sed -i -e "s|SDPath|${SDPath}|" $ConfigPath
#   sed -i -e "s|ISODirPath|${IsoPath}|" $ConfigPath

  cmakeFlags = [
    "-DLINUX_LOCAL_DEV=true"
    "-DGTK3_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-3.0/include"
    "-DGTK3_GDKCONFIG_INCLUDE_DIR=${gtk3.out}/lib/gtk-3.0/include"
    "-DGTK3_INCLUDE_DIRS=${gtk3.out}/lib/gtk-3.0"
    "-DENABLE_LTO=True"
    "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
    "-DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk2.out}/lib/gtk-2.0/include"
    "-DGTK2_INCLUDE_DIRS=${gtk2}/lib/gtk-2.0"
  ];

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [
    mesa_drivers
    mesa_glu
    mesa
    pkgconfig
    bluez
    ffmpeg
    libao
    libGLU
    glib
    gettext
    xorg.libpthreadstubs
    xorg.libXrandr
    xorg.libXext
    xorg.libX11
    xorg.libSM
    readline
    openal
    libevdev
    xorg.libXdmcp
    portaudio
    libusb
    libpulseaudio
    udev
    gnumake
    wxGTK30
    gtk2
    gtk3
    gdk-pixbuf
    soundtouch
    miniupnpc
    mbedtls
    curl
    lzo
    sfml
    enet
    xdg_utils
    hidapi
    webkitgtk
    projectplus-sdcard
    projectplus-config
    tree
  ];

}
