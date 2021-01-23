{ stdenv, gcc, slippiDesktopApp ? false, playbackSlippi, fetchFromGitHub
, mesa_drivers, mesa_glu, mesa, pkgconfig, cmake, bluez, ffmpeg, libao, libGLU
, gtk2, gtk3, glib, gettext, xorg, readline, openal, libevdev, portaudio, libusb
, libpulseaudio, libudev, gnumake, wxGTK30, gdk-pixbuf, soundtouch, miniupnpc
, mbedtls, curl, lzo, sfml, enet, xdg_utils, hidapi, webkit }:
stdenv.mkDerivation rec {
  pname = "slippi-ishiiruka";
  version = "2.2.5-gitpatch";
  name =
    "${pname}-${version}-${if playbackSlippi then "playback" else "netplay"}";
  src = fetchFromGitHub {
    owner = "project-slippi";
    repo = "Ishiiruka";
    rev = "026a376cb762880da693531c2de048a678a0b392";
    sha256 = "d3eb539a556352f3f47881d71fb0e5777b2f3e9a4251d283c18c67ce996774b7";
  };

  outputs = [ "out" ];
  makeFlags = [ "VERSION=us" "-s" "VERBOSE=1" ];
  hardeningDisable = [ "format" ];

  cmakeFlags = [
    "-DLINUX_LOCAL_DEV=true"
    "-DGTK3_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-3.0/include"
    "-DGTK3_GDKCONFIG_INCLUDE_DIR=${gtk3.out}/lib/gtk-3.0/include"
    "-DGTK3_INCLUDE_DIRS=${gtk3.out}/lib/gtk-3.0"
    "-DENABLE_LTO=True"
    "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
    "-DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk2.out}/lib/gtk-2.0/include"
    "-DGTK2_INCLUDE_DIRS=${gtk2}/lib/gtk-2.0"
  ] ++ stdenv.lib.optional (playbackSlippi) "-DIS_PLAYBACK=true";

  postBuild = with stdenv.lib;
    optionalString playbackSlippi ''
      rm -rf ../Data/Sys/GameSettings
      cp -r "${slippiDesktopApp}/app/dolphin-dev/overwrite/Sys/GameSettings" ../Data/Sys
    '' + ''
      touch Binaries/portable.txt
      cp -r -n ../Data/Sys/ Binaries/
      cp -r Binaries/ $out
      mkdir -p $out/bin
    '';

  installPhase = if playbackSlippi then ''
    ln -s $out/dolphin-emu $out/bin/slippi-playback
  '' else ''
    ln -s $out/dolphin-emu $out/bin/slippi-netplay
  '';

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
    libudev
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
    webkit
  ];
}
