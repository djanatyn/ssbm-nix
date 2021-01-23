# ssbm-nix
Nix expressions for Super Smash Bros. Melee players.

Goals:
* Support Slippi Netplay + Playback on NixOS
* Patch character skins and level textures, declaratively and reproducibly
* Build common training mods (UnclePunch, 20XX Hack Pack)

# Playing Slippi Online!
Either run `slippi-netplay -u $favoredConfigDirectory` where `$favoredConfigDirectory` is a folder you are happy keeping game settings (such as your authentication token for slippi) in, or run the 'Slippi Netplay' desktop entry, which will locate your config directory in `~/.config/slippi-playback`. Then locate your melee iso, and play.

# Setup
This toolkit expects a GALE01 NTSC v1.02 ISO:
```
$ wit llll ssbm.iso

ID6      m-date    MiB Reg.  1 discs (1392 MiB)
  n(p) p-info       type     source
---------------------------------------------------
GALE01 2020-07-24 1392 USA   Super Smash Bros Melee
     1 ---?         ISO/GC   ssbm.iso
---------------------------------------------------
Total: 1 disc, 1392 MiB used.
       
$ md5sum ssbm.iso
0e63d4223b01d9aba596259dc155a174  ssbm.iso
```

Import it into the nix store:
```
$ nix-store --add ssbm.iso
warning: dumping very large path (> 256 MiB); this may run out of memory
/nix/store/cv5av2yy96n4g44vn6b4q1alx4y3bq69-ssbm.iso
```

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

### Building Complete Mods
* [ ] Build UnclePunch Training Pack
