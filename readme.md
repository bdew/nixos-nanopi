# Description

This flake produces a bootable image for [NanoPi R5S](https://wiki.friendlyelec.com/wiki/index.php/NanoPi_R5S) SBC.

The image can be flashed onto an SD card or the built in EMMC storage as is. It could (in theory - currently untested) also run from an NVMe drive, but you'll need to manually install a bootloader on EMMC.

It uses uboot builds from https://github.com/inindev/nanopi-r5 - other than that everything else is stock NixOS with stock kernel.

On first boot the system will resize the filesystem to fit the whole drive and initialize the nix store.

Network interfaces are renamed to wan0/lan1/lan2. MAC addresses will be random. DHCP is enabled on all interfaces by default.

# Building

Can be built with just `nix build` - the image will be linked in result/nanopi-r5s-nixos.img.zst

For building on a x64 host you'll need to add this to your config:

```
  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
  ];

  nix.settings.extra-platforms = config.boot.binfmt.emulatedSystems;
```
