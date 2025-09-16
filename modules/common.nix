{
  config,
  pkgs,
  lib,
  ...
}: let
  # inspired from https://git.openwrt.org/?p=openwrt/openwrt.git;a=blob;f=package/kernel/r8125/Makefile;h=7cb28c9980482511fa143d6243fea63fd3f23f41;hb=HEAD
  customR8125 = config.boot.kernelPackages.r8125.overrideAttrs (old: {
    makeFlags =
      old.makeFlags
      ++ [
        "ENABLE_MULTIPLE_TX_QUEUE=y"
        "ENABLE_RSS_SUPPORT=y"
        # Disable PCI power management. I don't know if it's really necessary.
        # However, the logic is sound, as we don't want any trade-off in network performance.
        "CONFIG_ASPM=n"
      ];
  });
in {
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
    boot = {
      tmp.useTmpfs = true;

      loader = {
        grub.enable = false;
        generic-extlinux-compatible = {
          enable = true;
          useGenerationDeviceTree = true;
        };
        timeout = 1;
      };

      kernelPackages = pkgs.linuxKernel.packages.linux_6_13;
      extraModulePackages = [customR8125];
      # blacklist 'legacy' driver as we use the decicated realtek one
      # without this r8169 is loaded (lsmod | grep r81) but not used (ethtool -i lan0)
      blacklistedKernelModules = ["r8169"];

      kernelParams = [
        "console=tty0"
        "earlycon=uart8250,mmio32,0xfe660000"
      ];

      growPartition = true;
      initrd = {
        kernelModules = ["r8125"];
        availableKernelModules = [
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
      };
    };

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
