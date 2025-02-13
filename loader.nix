{
  pkgs,
  ...
}:

pkgs.stdenvNoCC.mkDerivation {
  name = "nanopi-r5s-loader";

  src = pkgs.fetchurl {
    url = "https://github.com/inindev/u-boot-build/releases/download/2025.01/rk3568-nanopi-r5s.zip";
    hash = "sha256-ZJYM1sjaS0wCQPqKuP8HxmqXpy+eaSyjvMnWakTvZ80=";
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
    
    cp src/idbloader.img $out/idbloader.img
    cp src/u-boot.itb $out/u-boot.itb
  '';
}
