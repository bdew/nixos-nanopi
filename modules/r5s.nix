{ config, lib, ... }:
{
  config = lib.mkIf (config.nanopi.model == "r5s") {

    hardware.deviceTree.name = "rockchip/rk3568-nanopi-r5s.dtb";

    systemd.network.links = {
      "10-lan1" = {
        matchConfig = {
          Path = "platform-3c0000000.pcie-*";
        };
        linkConfig = {
          Name = "lan1";
        };
      };
      "10-lan2" = {
        matchConfig = {
          Path = "platform-3c0400000.pcie-*";
        };
        linkConfig = {
          Name = "lan2";
        };
      };
      "10-wan0" = {
        matchConfig = {
          Path = "platform-fe2a0000.ethernet";
        };
        linkConfig = {
          Name = "wan0";
        };
      };
    };
    
  };
}
