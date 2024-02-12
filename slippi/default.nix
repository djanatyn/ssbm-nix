{
  stdenv,
  lib,
  makeDesktopItem,
  slippi-desktop,
  playbackSlippi,
  fetchFromGitHub,
  makeWrapper,
  mesa,
  pkg-config,
  cmake,
  bluez,
  ffmpeg,
  libao,
  libGLU,
  gtk2,
  gtk3,
  wrapGAppsHook,
  glib,
  glib-networking,
  gettext,
  xorg,
  readline,
  openal,
  libevdev,
  portaudio,
  libusb1,
  libpulseaudio,
  udev,
  gnumake,
  wxGTK32,
  gdk-pixbuf,
  soundtouch,
  miniupnpc,
  mbedtls_2,
  curl,
  lzo,
  sfml,
  enet,
  xdg-utils,
  hidapi,
  webkitgtk,
  vulkan-loader,
  rustc,
  cargo,
  rustPlatform,
  alsa-lib,
}: let
  netplay-desktop = makeDesktopItem {
    name = "Slippi Online";
    exec = "slippi-netplay";
    comment = "Play Melee Online!";
    desktopName = "Slippi-Netplay";
    genericName = "Wii/GameCube Emulator";
    categories = ["Game" "Emulator"];
    startupNotify = false;
  };

  playback-desktop = makeDesktopItem {
    name = "Slippi Playback";
    exec = "slippi-playback";
    comment = "Watch Your Slippi Replays";
    desktopName = "Slippi-Playback";
    genericName = "Wii/GameCube Emulator";
    categories = ["Game" "Emulator"];
    startupNotify = false;
  };
in
  stdenv.mkDerivation rec {
    pname = "slippi-ishiiruka";
    version = "3.4.0";
    name = "${pname}-${version}-${
      if playbackSlippi
      then "playback"
      else "netplay"
    }";
    src = fetchFromGitHub {
      owner = "project-slippi";
      repo = "Ishiiruka";
      rev = "v${version}";
      hash = "sha256-qYPrAPAPOoCqfidLsT+ycQd2dXtsjo1PRt4TznVZf6U=";
      fetchSubmodules = true;
    };

    cargoRoot = "Externals/SlippiRustExtensions";

    cargoDeps = rustPlatform.importCargoLock {
      lockFile = "${src}/${cargoRoot}/Cargo.lock";
      outputHashes = {
        "cpal-0.15.2" = "sha256-4C7YWUx6SZnZy6pwy0CCL3yPgaMflN1atN3cUNMbcmU=";
      };
    };

    outputs = ["out"];
    makeFlags = ["VERSION=us" "-s" "VERBOSE=1"];
    hardeningDisable = ["format"];

    cmakeFlags =
      [
        "-DLINUX_LOCAL_DEV=true"
        "-DGTK3_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
        "-DENABLE_LTO=True"
        "-DCMAKE_SKIP_BUILD_RPATH=ON"
      ]
      ++ lib.optional playbackSlippi "-DIS_PLAYBACK=true";

    postBuild = with lib;
      optionalString playbackSlippi ''
        rm -rf ../Data/Sys/GameSettings
        mkdir -p ../Data
        cp -r "${slippi-desktop}/app/dolphin-dev/overwrite/Sys/GameSettings" ../Data/Sys
      ''
      + ''
        cp -r -n ../Data/Sys/ Binaries/
        cp -r Binaries/ $out
        mkdir -p $out/lib
        cp $build/build/source/build/Source/Core/DolphinWX/libslippi_rust_extensions.so $out/lib
        mkdir -p $out/bin
      '';

    installPhase =
      if playbackSlippi
      then ''
        wrapProgram "$out/dolphin-emu" \
          --set "GDK_BACKEND" "x11" \
          --prefix GIO_EXTRA_MODULES : "${glib-networking}/lib/gio/modules" \
          --prefix LD_LIBRARY_PATH : "${vulkan-loader}/lib" \
          --prefix PATH : "${xdg-utils}/bin"
        ln -s $out/dolphin-emu $out/bin/slippi-playback
        ln -s ${playback-desktop}/share/applications $out/share
      ''
      else ''
        wrapProgram "$out/dolphin-emu" \
          --set "GDK_BACKEND" "x11" \
          --prefix GIO_EXTRA_MODULES : "${glib-networking}/lib/gio/modules" \
          --prefix LD_LIBRARY_PATH : "${vulkan-loader}/lib" \
          --prefix PATH : "${xdg-utils}/bin"
        ln -s $out/dolphin-emu $out/bin/slippi-netplay
        ln -s ${netplay-desktop}/share/applications $out/share
      '';

    nativeBuildInputs = [
      pkg-config
      cmake
      wrapGAppsHook
      rustc
      cargo
      rustPlatform.cargoSetupHook
    ];

    buildInputs = [
      vulkan-loader
      makeWrapper
      mesa.drivers
      mesa
      pkg-config
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
      libusb1
      libpulseaudio
      udev
      gnumake
      wxGTK32
      gtk2
      gtk3
      gdk-pixbuf
      soundtouch
      miniupnpc
      mbedtls_2
      curl
      lzo
      sfml
      enet
      xdg-utils
      hidapi
      webkitgtk
      alsa-lib
    ];
  }
