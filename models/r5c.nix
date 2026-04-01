{
  model = "r5c";
  bootLoaderDownload = {
    url = "https://github.com/inindev/uboot-rockchip/releases/download/v2026.01/rk3568-nanopi-r5c.zip";
    hash = "sha256-ExKHl3pakf0eAjeOJC2CcTj0h+Ay60RJQMLnoVB8EH4=";
  };
  dtb = "rockchip/rk3568-nanopi-r5c.dtb";
  nics = [
    {
      name = "wan0";
      path = "platform-3c0800000.pcie-*";
    }
    {
      name = "lan1";
      path = "platform-3c0400000.pcie-*";
    }
  ];
}
