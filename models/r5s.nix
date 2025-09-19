{
  model = "r5s";
  bootLoaderDownload = {
    url = "https://github.com/inindev/u-boot-build/releases/download/2025.01/rk3568-nanopi-r5s.zip";
    hash = "sha256-ZJYM1sjaS0wCQPqKuP8HxmqXpy+eaSyjvMnWakTvZ80=";
  };
  dtb = "rockchip/rk3568-nanopi-r5s.dtb";
  nics = [
    {
      name = "wan0";
      path = "platform-fe2a0000.ethernet";
    }
    {
      name = "lan1";
      path = "platform-3c0000000.pcie-*";
    }
    {
      name = "lan2";
      path = "platform-3c0400000.pcie-*";
    }
  ];
}
