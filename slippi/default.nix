{ stdenv, lib, makeDesktopItem, gcc, slippi-desktop, playbackSlippi, fetchFromGitHub, makeWrapper
, mesa_drivers, mesa_glu, mesa, pkgconfig, cmake, bluez, ffmpeg, libao, libGLU
, gtk2, gtk3, wrapGAppsHook, glib, glib-networking, gettext, xorg, readline, openal, libevdev, portaudio, libusb
, libpulseaudio, udev, gnumake, wxGTK30, gdk-pixbuf, soundtouch, miniupnpc
, mbedtls, curl, lzo, sfml, enet, xdg_utils, hidapi, webkitgtk, vulkan-loader }:
let

  netplay-desktop = makeDesktopItem {
    name = "Slippi Online";
    exec = "slippi-netplay";
    comment = "Play Melee Online!";
    desktopName = "Slippi-Netplay";
    genericName = "Wii/GameCube Emulator";
    categories = [ "Game" "Emulator" ];
    startupNotify = false;
  };

  playback-desktop = makeDesktopItem {
    name = "Slippi Playback";
    exec = "slippi-playback";
    comment = "Watch Your Slippi Replays";
    desktopName = "Slippi-Playback";
    genericName = "Wii/GameCube Emulator";
    categories = [ "Game" "Emulator" ];
    startupNotify = false;
  };

in stdenv.mkDerivation rec {
  pname = "slippi-ishiiruka";
  version = "2.5.1";
  name =
    "${pname}-${version}-${if playbackSlippi then "playback" else "netplay"}";
  src = fetchFromGitHub {
    owner = "project-slippi";
    repo = "Ishiiruka";
    rev = "v${version}";
    sha256 = "1ha3hv2lnmjhqn3vhbca6vm3l2p2v0mp94n1lgrvjfrn827g2kbx";
  };

  outputs = [ "out" ];
  makeFlags = [ "VERSION=us" "-s" "VERBOSE=1" ];
  hardeningDisable = [ "format" ];

  cmakeFlags = [
    "-DLINUX_LOCAL_DEV=true"
    "-DGTK3_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-3.0/include"
    "-DGTK3_GLIBCONFIG_INCLUDE_DIR=${glib-networking.out}/lib/glib-3.0/include"
    "-DGTK3_GDKCONFIG_INCLUDE_DIR=${gtk3.out}/lib/gtk-3.0/include"
    "-DGTK3_INCLUDE_DIRS=${gtk3.out}/lib/gtk-3.0"
    "-DENABLE_LTO=True"
    "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
    "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib-networking.out}/lib/glib-2.0/include"
    "-DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk2.out}/lib/gtk-2.0/include"
    "-DGTK2_INCLUDE_DIRS=${gtk2}/lib/gtk-2.0"
  ] ++ lib.optional (playbackSlippi) "-DIS_PLAYBACK=true";

  postBuild = with lib;
    optionalString playbackSlippi ''
      rm -rf ../Data/Sys/GameSettings
      cp -r "${slippi-desktop}/app/dolphin-dev/overwrite/Sys/GameSettings" ../Data/Sys
    '' + ''
      cp -r -n ../Data/Sys/ Binaries/
      cp -r Binaries/ $out
      mkdir -p $out/bin
    '';

  installPhase = if playbackSlippi then ''
    wrapProgram "$out/dolphin-emu" \
      --set "GDK_BACKEND" "x11" \
      --prefix GIO_EXTRA_MODULES : "${glib-networking}/lib/gio/modules" \
      --prefix LD_LIBRARY_PATH : "${vulkan-loader}/lib" \
      --prefix PATH : "${xdg_utils}/bin"
    ln -s $out/dolphin-emu $out/bin/slippi-playback
    ln -s ${playback-desktop}/share/applications $out/share
  '' else ''
    wrapProgram "$out/dolphin-emu" \
      --set "GDK_BACKEND" "x11" \
      --prefix GIO_EXTRA_MODULES : "${glib-networking}/lib/gio/modules" \
      --prefix LD_LIBRARY_PATH : "${vulkan-loader}/lib" \
      --prefix PATH : "${xdg_utils}/bin"
    ln -s $out/dolphin-emu $out/bin/slippi-netplay
    ln -s ${netplay-desktop}/share/applications $out/share
  '';

  nativeBuildInputs = [ pkgconfig cmake wrapGAppsHook ];
  buildInputs = [
    vulkan-loader
    makeWrapper
    mesa_drivers
    mesa_glu
    mesa
    pkgconfig
    bluez
    ffmpeg
    libao
    libGLU
    glib
    glib-networking
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
  ];
}
