{
  model = "r5c";
  bootLoaderDownload = {
    url = "https://github.com/inindev/uboot-rockchip/releases/download/v2026.04/rk3568-nanopi-r5c.zip";
    hash = "sha256-Tt7bdxLrOSCBzUg8JxZvxepp1oeZo4SC2l3qRI1mpyQ=";
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
