{
  pkgs,
  ...
}:

pkgs.stdenvNoCC.mkDerivation {
  name = "nanopi-r5s-loader";

  idbLoader = pkgs.fetchurl {
    url = "https://github.com/inindev/nanopi-r5/releases/download/v12.0.3/idbloader-r5s.img";
    hash = "sha256-TzVl3V8lv5h6NvNioRHD7m5ob/S6L6LYhejmEZnYUSY=";
  };

  uBoot = pkgs.fetchurl {
    url = "https://github.com/inindev/nanopi-r5/releases/download/v12.0.3/u-boot-r5s.itb";
    hash = "sha256-6ZP0yl4f7vTFHxV+iF9HTDD4l1SOiT8kvUZuvCuc1Lo=";
  };

  dontUnpack = true;
  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    mkdir -p $out
    cp $idbLoader $out/idbloader.img
    cp $uBoot $out/u-boot.itb
  '';
}
