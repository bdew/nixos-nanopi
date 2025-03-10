{
  config,
  pkgs,
  ...
}:
{
  config = {
    boot.postBootCommands =
      let
        nixPathRegistrationFile = "/nix-path-registration";
      in
      ''
        # On the first boot do some maintenance tasks
        if [ -f ${nixPathRegistrationFile} ]; then
          set -euo pipefail
          set -x

          # Figure out device names for the boot device and root filesystem.
          rootPart=$(${pkgs.util-linux}/bin/findmnt -n -o SOURCE /)
          bootDevice=$(lsblk -npo PKNAME $rootPart)

          # Resize the root partition and the filesystem to fit the disk
          echo ",+," | sfdisk -N1 --no-reread $bootDevice
          ${pkgs.parted}/bin/partprobe
          ${pkgs.e2fsprogs}/bin/resize2fs $rootPart

          # Register the contents of the initial Nix store
          ${config.nix.package.out}/bin/nix-store --load-db < ${nixPathRegistrationFile}

          # nixos-rebuild also requires a "system" profile and an /etc/NIXOS tag.
          touch /etc/NIXOS
          ${config.nix.package.out}/bin/nix-env -p /nix/var/nix/profiles/system --set /run/current-system

          # Prevents this from running on later boots.
          rm -f ${nixPathRegistrationFile}
        fi
      '';
  };
}
