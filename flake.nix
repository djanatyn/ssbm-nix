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
        uncle-punch = pkgs.uncle-punch;
        slippi-netplay-chat-edition = pkgs.slippi-netplay-chat-edition;
        gcmtool = pkgs.gcmtool;
        projectplus-sdcard = pkgs.projectplus-sdcard;
        projectplus-config = pkgs.projectplus-config;
    });

    nixosModule = { config, ... }:
    let
      cfg = config.gc;
    in with nixpkgs.lib; {

      options = {
        gc.controller.rules.enable = mkEnableOption "Turn on rules for your gamecube controller adapter.";
        gc.controller.rules.rules = mkOption {
          default = readFile ./gcc.rules;
          type = types.lines;
          description = "To be appended to services.udev.extraRules if gc.controller.rules.enable is set.";
        };
      };
      config = {
        services.udev.extraRules = mkIf cfg.controller.rules.enable cfg.controller.rules.rules;
      };

    };

  };

}

