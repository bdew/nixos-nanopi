{
  pkgs,
  nixpkgs,
  modelDef,
}:
let
  bootLoader = import ./loader.nix {
    inherit pkgs;
    inherit (modelDef) model bootLoaderDownload;
  };
  image = nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    modules = [
      ./modules/common.nix
      ./modules/boot.nix
      modelDef.module
    ];
  };
in
pkgs.stdenv.mkDerivation {
  name = "nanopi-${modelDef.model}-nixos";

  nativeBuildInputs = with pkgs; [
    e2fsprogs
    util-linux
    xz
  ];

  inherit bootLoader;

  rootfsImage = pkgs.callPackage "${toString nixpkgs}/nixos/lib/make-ext4-fs.nix" ({
    storePaths = image.config.system.build.toplevel;
    populateImageCommands = ''
      mkdir -p ./files/boot
      mkdir -p ./files/etc/nixos
      ${image.config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${image.config.system.build.toplevel} -d ./files/boot
    '';
    volumeLabel = "NIXOS";
  });

  buildCommand = ''
    mkdir $out

    img=tmp.img

    # Gap in front of the root partition, in MiB
    gap=16

    # Create the image file sized to fit bootloader and /, plus slack for the gap.
    rootSizeBlocks=$(du -B 512 --apparent-size $rootfsImage | awk '{ print $1 }')
    imageSize=$((rootSizeBlocks * 512 + gap * 1024 * 1024))
    truncate -s $imageSize $img

    sfdisk --no-reread --no-tell-kernel $img <<EOF
        label: dos

        start=''${gap}M, type=83, bootable
    EOF

    eval $(partx $img -o START,SECTORS --nr 1 --pairs)
    dd conv=notrunc if=$rootfsImage of=$img seek=$START count=$SECTORS

    dd bs=4K seek=8 if=$bootLoader/idbloader.img of=$img conv=notrunc
    dd bs=4K seek=2048 if=$bootLoader/u-boot.itb of=$img conv=notrunc

    xz -vc $img > $out/nanopi-${modelDef.model}-nixos.img.xz
  '';

}
