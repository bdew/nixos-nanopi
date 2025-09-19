{
  description = "A Nixos SD/EMMC image and supporting modules for Nanopi R5S/R5C";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    let
      models = import ./models;
      mkModule = import ./modules/model-specific.nix;
    in
    (flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        images = pkgs.lib.mapAttrs' (modelName: modelDef: {
          name = "nanopi-${modelName}-image";
          value = import ./utils/image.nix {
            inherit nixpkgs pkgs modelDef;
          };
        }) models;
      in
      {
        packages = images // {
          default = pkgs.symlinkJoin {
            name = "nanopi-images";
            paths = pkgs.lib.attrValues images;
          };
        };
      }
    ))
    // {
      nixosModules = builtins.mapAttrs (modelName: modelDef: mkModule modelDef) models;
    };
}
