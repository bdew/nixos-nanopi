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
    fileSystems = {
      "/" = {
        device = "/dev/disk/by-label/NIXOS";
        fsType = "ext4";
      };
      "/var/log" = {
        fsType = "tmpfs";
      };
    };

    hardware.firmware = [
      pkgs.linux-firmware
    ];

    boot.tmp.useTmpfs = true;

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

    boot.growPartition = true;

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

    powerManagement.cpuFreqGovernor = "schedutil";

    networking.hostName = "nixos";
    networking.useDHCP = true;

    nix = {
      settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    environment.systemPackages = with pkgs; [
      git
      python3
      mc
      psmisc
      curl
      wget
      dig
      file
      nvd
      ethtool
      sysstat
    ];

    security.sudo.wheelNeedsPassword = false;
    nix.settings.trusted-users = [
      "root"
      "@wheel"
    ];

    users.users.nix = {
      isNormalUser = true;
      description = "nix";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      password = "nix";
    };

    services.openssh.enable = true;

    i18n = {
      defaultLocale = "en_GB.UTF-8";
    };

    environment.etc = {
      "systemd/journald.conf.d/99-storage.conf".text = ''
        [Journal]
        Storage=volatile
      '';
    };

    system.stateVersion = lib.mkDefault "25.05";
  };
}
