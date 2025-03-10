{
  r5s = {
    model = "r5s";
    module = ./modules/r5s.nix;
    bootLoaderDownload = {
      url = "https://github.com/inindev/u-boot-build/releases/download/2025.01/rk3568-nanopi-r5s.zip";
      hash = "sha256-ZJYM1sjaS0wCQPqKuP8HxmqXpy+eaSyjvMnWakTvZ80=";
    };
  };
  r5c = {
    model = "r5c";
    module = ./modules/r5c.nix;
    bootLoaderDownload = {
      url = "https://github.com/inindev/u-boot-build/releases/download/2025.01/rk3568-nanopi-r5c.zip";
      hash = "sha256-ztwN1vA1i3/EIKewDxDUO8ZGsPbuN6DJlg0yk2Jjv6U=";
    };
  };
}
