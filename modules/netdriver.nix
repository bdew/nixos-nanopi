{ config, lib, ... }:
{
  options = {
    nanopi.drivers.r8125 = lib.mkEnableOption "custom r8125 network driver";
  };
  config = lib.mkIf config.nanopi.drivers.r8125 (
    let
      # inspired from https://git.openwrt.org/?p=openwrt/openwrt.git;a=blob;f=package/kernel/r8125/Makefile;h=7cb28c9980482511fa143d6243fea63fd3f23f41;hb=HEAD
      customR8125 = config.boot.kernelPackages.r8125.overrideAttrs (old: {
        makeFlags = old.makeFlags ++ [
          "ENABLE_MULTIPLE_TX_QUEUE=y"
          "ENABLE_RSS_SUPPORT=y"
          # Disable PCI power management. I don't know if it's really necessary.
          # However, the logic is sound, as we don't want any trade-off in network performance.
          "CONFIG_ASPM=n"
        ];
      });
    in
    {
      boot = {
        extraModulePackages = [ customR8125 ];
        # blacklist 'legacy' driver as we use the decicated realtek one
        blacklistedKernelModules = [ "r8169" ];
        initrd.kernelModules = [ "r8125" ];
      };
    }
  );
}
