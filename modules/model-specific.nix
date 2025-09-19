modelData:
{ config, lib, ... }:
{
  imports = [
    ./common.nix
    ./netdriver.nix
  ];

  options = {
    nanopi.network.intefaces = builtins.listToAttrs (
      builtins.map (
        nic:
        lib.nameValuePair nic.name {
          name = lib.mkOption {
            type = lib.types.str;
            default = nic.name;
            description = "Interface name for ${nic.name}";
          };
          mac = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Mac address for ${nic.name}, random address will be generated if unset";
          };
        }
      ) modelData.nics
    );
  };

  config = {
    hardware.deviceTree.name = modelData.dtb;
    systemd.network.links = builtins.listToAttrs (
      builtins.map (
        nic:
        let
          opts = config.nanopi.network.intefaces.${nic.name};
        in
        lib.nameValuePair "10-${nic.name}" {
          matchConfig = {
            Path = nic.path;
          };
          linkConfig = {
            Name = opts.name;
          }
          // (if (opts.mac != null) then { MACAddress = opts.mac; } else { });
        }
      ) modelData.nics
    );
  };
}
