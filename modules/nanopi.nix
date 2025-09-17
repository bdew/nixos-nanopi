{ lib, config, ... }:
{
  imports = [
    ./common.nix
    ./r5s.nix
    ./r5c.nix
    ./netdriver.nix
  ];

  options = {
    nanopi.model = lib.mkOption {
      type = lib.types.enum [
        "r5s"
        "r5c"
      ];
      description = "NanoPi model to use. Supported models: r5s, r5c";
      example = "r5s";
    };
  };

  config = { };
}
