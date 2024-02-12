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

Generally, this should be all you need.

1. Edit the `version` in `slippi-launcher/default.nix` to be the latest on https://github.com/project-slippi/slippi-launcher/releases
2. Edit the `version` in `slippi/default.nix` to be the latest on https://github.com/project-slippi/Ishiiruka/releases
3. Run `nix build .#slippi-launcher`. It will fail and you need to update the checksums as output.

For reasons unbeknownst to me, sometimes you need to try building a couple times
before it will succeed _even_ after updating checksums.

Once that's done, you should be able to submit a PR and update your flake/config
to use the PR's commit.

If this _doesn't_ work, there are likely upstream toolchain updates that need to
be accounted for. You can maybe get away with just a `nix flake update` (or the
non-flake equivalent?) to update the toolchain
