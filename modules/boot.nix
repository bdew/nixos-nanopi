{
  config,
  pkgs,
  lib,
  ...
}:
{

  config =
    let
      nixPathRegistrationFile = "/nix-path-registration";
    in
    {

      # Stolen from nixos/modules/installer/sd-card/sd-image.nix

      systemd.services.expand-root-partition = {
        description = "Grow the root partition and filesystem to fill the SD card";
        unitConfig = {
          DefaultDependencies = false;
          ConditionPathExists = nixPathRegistrationFile;
        };
        wantedBy = [ "sysinit.target" ];
        before = [
          "sysinit.target"
          "shutdown.target"
          "register-nix-paths.service"
        ];
        after = [ "local-fs.target" ];
        conflicts = [ "shutdown.target" ];
        restartIfChanged = false;
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        script = ''
          # Figure out device names for the boot device and root filesystem.
          rootPart=$(${lib.getExe' pkgs.util-linux "findmnt"} -n -o SOURCE /)
          bootDevice=$(${lib.getExe' pkgs.util-linux "lsblk"} -npo PKNAME $rootPart)
          partNum=$(${lib.getExe' pkgs.util-linux "lsblk"} -npo MAJ:MIN $rootPart | ${lib.getExe pkgs.gawk} -F: '{print $2}')

          # Resize the root partition and the filesystem to fit the disk
          echo ",+," | ${lib.getExe' pkgs.util-linux "sfdisk"} -N$partNum --no-reread $bootDevice
          ${lib.getExe' pkgs.parted "partprobe"}
          ${lib.getExe' pkgs.e2fsprogs "resize2fs"} $rootPart
        '';
      };

      systemd.services.register-nix-paths = {
        description = "Register Nix Store Paths";
        unitConfig = {
          DefaultDependencies = false;
          ConditionPathExists = nixPathRegistrationFile;
        };
        wantedBy = [ "sysinit.target" ];
        before = [
          "sysinit.target"
          "shutdown.target"
          "nix-daemon.socket"
          "nix-daemon.service"
        ];
        after = [ "local-fs.target" ];
        conflicts = [ "shutdown.target" ];
        restartIfChanged = false;
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        script = ''
          ${lib.getExe' config.nix.package.out "nix-store"} --load-db < ${nixPathRegistrationFile}

          # nixos-rebuild also requires a "system" profile and an /etc/NIXOS tag.
          touch /etc/NIXOS
          ${lib.getExe' config.nix.package.out "nix-env"} -p /nix/var/nix/profiles/system --set /run/current-system

          # Prevents this from running on later boots.
          rm -f ${nixPathRegistrationFile}
        '';
      };
    };
}
