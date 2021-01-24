{

  inputs = {
    slippi-desktop.url = "github:project-slippi/slippi-desktop-app";
    slippi-desktop.flake = false;
  };

  description = "Nix expressions for Super Smash Bros. Melee players.";

  outputs = { self, nixpkgs, nix, slippi-desktop, ... }@inputs:
  let

    supportedSystems = [ "x86_64-linux" ];
    forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);

  in {

    overlay = final: prev: import ./overlay.nix { inherit slippi-desktop final prev; };

    apps = forAllSystems (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ self.overlay ];
      };
    in {
      slippi-netplay = {
        type = "app";
        program = "${pkgs.slippi-netplay}/bin/slippi-netplay";
      };
      slippi-playback = {
        type = "app";
        program = "${pkgs.slippi-playback}/bin/slippi-playback";
      };
    });

    packages = forAllSystems (system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlay ];
        };
      in {
        wiimms-iso-tools = pkgs.wiimms-iso-tools;
        slippi-netplay = pkgs.slippi-netplay;
        slippi-playback = pkgs.slippi-playback;
        gecko = pkgs.gecko;
        powerpc-eabi-assembling = pkgs.powerpc-eabi-assembling;
        slippi-netplay-chat-edition = pkgs.slippi-netplay-chat-edition;
        gcmtool = pkgs.gcmtool;
        projectplus-sdcard = pkgs.projectplus-sdcard;
        projectplus-config = pkgs.projectplus-config;
    });

    nixosModule = { config, ... }:
    let
      cfg = config.ssbm;
    in with nixpkgs.lib; {

      options = {
        ssbm.cache.enable = mkEnableOption "Turn on cache.";
        ssbm.gcc.oc-kmod.enable = mkEnableOption "Turn on overclocking kernel module.";
        ssbm.gcc.rules.enable = mkEnableOption "Turn on rules for your gamecube controller adapter.";
        ssbm.gcc.rules.rules = mkOption {
          default = readFile ./gcc.rules;
          type = types.lines;
          description = "To be appended to services.udev.extraRules if gcc.rules.enable is set.";
        };
      };
      config = {
        services.udev.extraRules = mkIf cfg.gcc.rules.enable cfg.controller.rules.rules;
        boot.extraModulePackages = mkIf cfg.gcc.oc-kmod.enable [
          pkgs.linuxPackages.gcadapter-oc-kmod
        ];
        nix = mkIf cfg.cache.enable {
          binaryCaches = [ "https://ssbm-nix.cachix.org" ];
          binaryCachePublicKeys = [ "ssbm-nix.cachix.org-1:YN104LKAWaKQIecOphkftXgXlYZVK/IRHM1UD7WAIew=" ];
        };
      };

    };

  };

}

