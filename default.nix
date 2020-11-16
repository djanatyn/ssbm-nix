{ ssbm ? /nix/store/cv5av2yy96n4g44vn6b4q1alx4y3bq69-ssbm.iso
, sources ? import ./nix/sources.nix }:
let
  packages = import sources.nixpkgs { };
  inherit (packages) pkgs;
in with pkgs; { gecko = callPackage ./gecko { }; }
