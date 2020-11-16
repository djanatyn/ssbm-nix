{ ssbm ? /nix/store/irl5lmx3igzl00kalhk8igj3mjb3p1g1-melee
, sources ? import ./nix/sources.nix }:
let
  packages = import sources.nixpkgs { };
  inherit (packages) pkgs;
in with pkgs; rec {
  gecko = callPackage ./gecko { };

  powerpc-eabi-assembling = callPackage ./powerpc-eabi-as { };

  uncle-punch =
    callPackage ./uncle-punch { inherit ssbm gecko powerpc-eabi-assembling; };
}
