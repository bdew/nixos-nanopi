# Description

This flake produces a bootable image for NanoPi [R5S](https://wiki.friendlyelec.com/wiki/index.php/NanoPi_R5S) and [R5C](https://wiki.friendlyelec.com/wiki/index.php/NanoPi_R5C) SBC.

The image can be flashed onto an SD card or the built in EMMC storage as is. It can also run from an NVMe drive, but you'll need to manually install a bootloader on EMMC.

Log in with username and password `nix`, the user is set up with paswordless sudo and ssh is enabled by default.

It uses uboot builds from https://github.com/inindev/u-boot-build - other than that everything else is stock NixOS with stock kernel.

On first boot the system will resize the filesystem to fit the whole drive and initialize the nix store.

Network interfaces are renamed to wan0/lan1/lan2. MAC addresses will be random. DHCP is enabled on all interfaces by default.

# Building

To build run `nix build .#nanopi-r5s-image` or `nix build .#nanopi-r5c-image`

Just running `nix build` will generate both images

For building on a x64 host you'll need to add this to your config:

```
  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
  ];

  nix.settings.extra-platforms = config.boot.binfmt.emulatedSystems;
```
