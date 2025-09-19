# Description

This flake provides modules and bootable images for NanoPi [R5S](https://wiki.friendlyelec.com/wiki/index.php/NanoPi_R5S) and [R5C](https://wiki.friendlyelec.com/wiki/index.php/NanoPi_R5C) SBC.

# Using the modules

Add the flake as an input in your config 

```nix
    nanopi = {
      url = "github:bdew/nixos-nanopi";
      inputs.nixpkgs.follows = "nixpkgs";
    };
```

Then add `nanopi.nixosModules.r5s` (or `r5c`) to your modules.

## Available options:

#### `nanopi.network.intefaces.<name>.name = "...";`
  
Changes network interface names (default is wan0/lan1/lan2)

#### `nanopi.network.intefaces.<name>.mac = "12:34:56:78:90:AB";`

Sets the mac address for the interface - if unset a random address is generated on every boot

#### `nanopi.network.r8125 = true;`

Replaces the mainline r8169 driver for the network interfaces with [r8125](https://salsa.debian.org/debian/r8125) driver. This should in theory provide better network performance.

# Using the image

The image can be flashed onto an SD card or the built in EMMC storage as is. It can also run from an NVMe drive, but you'll need to manually install a bootloader on EMMC.

Log in with username and password `nix`, the user is set up with paswordless sudo and ssh is enabled by default.

It uses uboot builds from https://github.com/inindev/u-boot-build - other than that everything else is stock NixOS with stock kernel.

On first boot the system will resize the filesystem to fit the whole drive and initialize the nix store.

Network interfaces are renamed to wan0/lan1/lan2. MAC addresses will be random. DHCP is enabled on all interfaces by default.

# Building the image

To build run `nix build .#nanopi-r5s-image` or `nix build .#nanopi-r5c-image`

Just running `nix build` will generate both images

For building on a x64 host you'll need to add this to your config:

```
  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
  ];

  nix.settings.extra-platforms = config.boot.binfmt.emulatedSystems;
```
