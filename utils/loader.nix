{
  pkgs,
  model,
  bootLoaderDownload,
}:
pkgs.stdenvNoCC.mkDerivation {
  name = "nanopi-${model}-loader";

  src = pkgs.fetchurl {
    inherit (bootLoaderDownload) url hash;
  };

  nativeBuildInputs = [ pkgs.unzip ];

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  unpackPhase = ''
    unzip $src -d src
  '';

  installPhase = ''
    mkdir -p $out

    cp src/base-files/idbloader.img $out/idbloader.img
    cp src/base-files/u-boot.itb $out/u-boot.itb
  '';
}
