{
  model = "r5c";
  bootLoaderDownload = {
    url = "https://github.com/inindev/u-boot-build/releases/download/2025.01/rk3568-nanopi-r5c.zip";
    hash = "sha256-ztwN1vA1i3/EIKewDxDUO8ZGsPbuN6DJlg0yk2Jjv6U=";
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
