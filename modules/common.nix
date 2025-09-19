{
  config,
  pkgs,
  modulesPath,
  lib,
  system,
  ...
}:
{
  config = {
    hardware.firmware = [
      pkgs.linux-firmware
    ];
   
    boot.loader = {
      grub.enable = false;
      generic-extlinux-compatible = {
        enable = true;
        useGenerationDeviceTree = true;
      };
      timeout = 1;
    };

    boot.kernelParams = [
      "console=tty0"
      "earlycon=uart8250,mmio32,0xfe660000"
    ];

    boot.initrd.availableKernelModules = [
      "sdhci_of_dwcmshc"
      "dw_mmc_rockchip"
      "analogix_dp"
      "io-domain"
      "rockchip_saradc"
      "rockchip_thermal"
      "rockchipdrm"
      "rockchip-rga"
      "pcie_rockchip_host"
      "phy-rockchip-pcie"
      "phy_rockchip_snps_pcie3"
      "phy_rockchip_naneng_combphy"
      "phy_rockchip_inno_usb2"
      "dwmac_rk"
      "dw_wdt"
      "dw_hdmi"
      "dw_hdmi_cec"
      "dw_hdmi_i2s_audio"
      "dw_mipi_dsi"
    ];

    powerManagement.cpuFreqGovernor = lib.mkDefault "schedutil";
  };
}
