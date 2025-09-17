{
  description = "A Nixos SD/EMMC image for Nanopi R5S/R5C";

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
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        models = import ./models.nix;
      in
      {
        packages = rec {
          nanopi-r5s-image = import ./utils/image.nix {
            inherit nixpkgs pkgs;
            modelDef = models.r5s;
          };
          nanopi-r5c-image = import ./utils/image.nix {
            inherit nixpkgs pkgs;
            modelDef = models.r5c;
          };
          default = pkgs.symlinkJoin {
            name = "nanopi-images";
            paths = [
              nanopi-r5s-image
              nanopi-r5c-image
            ];
          };
        };
      }
    );
}
