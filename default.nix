{ ssbm ? /nix/store/irl5lmx3igzl00kalhk8igj3mjb3p1g1-melee
, sources ? import ./nix/sources.nix }:
let
  packages = import sources.nixpkgs { overlays = [ (import ./overlay.nix) ]; };

  inherit (packages) pkgs;
in with pkgs; rec {
  inherit sources pkgs;

  gecko = callPackage ./gecko { };

  powerpc-eabi-assembling = callPackage ./powerpc-eabi-as { };

  uncle-punch =
    callPackage ./uncle-punch { inherit ssbm gecko powerpc-eabi-assembling; };

  slippi-playback = callPackage ./slippi {
    playbackSlippi = true;
    inherit slippiDesktopApp;
  };

  slippi-netplay = callPackage ./slippi { playbackSlippi = false; };

  slippi-netplay-chat-edition = slippi-netplay.overrideAttrs (oldAttrs: rec {
    pname = "slippi-ishiiruka-chat";
    version = "release/2.3.0";
    name = pname;

    src = fetchFromGitHub {
      owner = "project-slippi";
      repo = "Ishiiruka";
      rev = version;
      sha256 = "1rd449s00dqmngp3mrapg91k4hhg2kyc0kizc37vb4l2zswpkqah";
    };
  });

  gcmtool = callPackage ./gcmtool { };
}
