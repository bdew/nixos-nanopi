{
  description = "A Nixos SD/EMMC image for Nanopi R5S";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
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
      in
      {
        packages =
          let
            image = nixpkgs.lib.nixosSystem {
              system = "aarch64-linux";
              modules = [
                ./nanopi.nix
                ./boot.nix
              ];
            };
            bootLoader = import ./loader.nix { inherit pkgs; };
          in
          {
            nanopi-r5s-image = import ./image.nix {
              inherit image bootLoader pkgs;
              imageName = "nanopi-r5s-nixos";
              modulesPath = nixpkgs + "/nixos/modules";
              configFile = ./nanopi.nix;
            };
            default = self.packages."${system}".nanopi-r5s-image;
          };
      }
    );
}
