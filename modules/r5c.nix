{ config, lib, ... }:
{
  config = lib.mkIf (config.nanopi.model == "r5c") {

    hardware.deviceTree.name = "rockchip/rk3568-nanopi-r5c.dtb";

    systemd.network.links = {
      "10-lan0" = {
        matchConfig = {
          Path = "platform-3c0400000.pcie-*";
        };
        linkConfig = {
          Name = "lan0";
        };
      };
      "10-wan0" = {
        matchConfig = {
          Path = "platform-3c0800000.pcie-*";
        };
        linkConfig = {
          Name = "wan0";
        };
      };
    };
  };

}
