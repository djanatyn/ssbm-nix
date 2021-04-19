![](https://img.shields.io/github/workflow/status/6AA4FD/ssbm-nix/builds)

# ssbm-nix
Nix expressions for Super Smash Bros. Melee players.

Goals:
* Support Slippi Netplay + Playback on NixOS
* Patch character skins and level textures, declaratively and reproducibly
* Build common training mods (UnclePunch, 20XX Hack Pack)

# Playing Slippi Online!
Run `slippi-netplay` or the desktop entry.

# FAQ
## How do I enable the GCC overclock adapter?
Enable the configuration option:
``` nix
ssbm.gcc.oc-kmod.enable = true;
```

After building that configuration and switching to it, load the module:
``` sh
sudo modprobe gcadpter_oc
```

The kernel module will be reloaded automatically on subsequent boots, since the flake updates `boot.kernelModules`.

## TODO
### Playing Melee
* [X] [slippi-netplay](https://github.com/project-slippi/Ishiiruka/pull/164)
* [X] [slippi-playback](https://github.com/project-slippi/Ishiiruka/pull/164)

### Tooling
* [X] Package JLaferri/gecko

### Skin Support
* [ ] Support patching `*.dat` files using `wit`
* [ ] Player Skin Module
* [ ] Level Skin Module

### Building Codesets
* [X] Build TM Codeset with `gecko build`

### Applying Codesets
* [X] Extract main.dol with `wit`
* [ ] Patch main.dol with TM Codeset output
