{
  model = "r5s";
  bootLoaderDownload = {
    url = "https://github.com/inindev/uboot-rockchip/releases/download/v2026.01/rk3568-nanopi-r5s.zip";
    hash = "sha256-uAqpO4ZniaaDCQ/hTCchUV7i49Yy1qQh8h+nuZtMcoM=";
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
