![](https://img.shields.io/github/workflow/status/6AA4FD/ssbm-nix/builds)

# ssbm-nix
Nix expressions for Super Smash Bros. Melee players.

Goals:
* Support Slippi Netplay + Playback on NixOS
* Patch character skins and level textures, declaratively and reproducibly
* Build common training mods (UnclePunch, 20XX Hack Pack)

# Playing Slippi Online!
## With `slippi-netplay` directly
Run `slippi-netplay` or the desktop entry.

## With `slippi-launcher`
Add the following to your Home Manager config:
```nix
ssbm.slippi-launcher= {
  enable = true;
  # Replace with the path to your Melee ISO
  isoPath = "Path/To/SSBM.ciso";
};
```

# FAQ
## How do I enable the GCC overclock adapter?
Enable the configuration option:
``` nix
ssbm.gcc.oc-kmod.enable = true;
```

After building that configuration and switching to it, load the module:
``` sh
sudo modprobe gcadapter_oc
```

The kernel module will be reloaded automatically on subsequent boots, since the flake updates `boot.kernelModules`.

## How do I update Slippi?

1. Edit the `version` in `slippi-launcher/default.nix` to be the latest on https://github.com/project-slippi/slippi-launcher/releases
2. Edit the `version` in `slippi/default.nix` to be the latest on https://github.com/project-slippi/Ishiiruka/releases
3. Run `nix build .#slippi-launcher`
