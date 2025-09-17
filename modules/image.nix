{
  config,
  pkgs,
  modulesPath,
  lib,
  system,
  ...
}:
{
  imports = [
    ./nanopi.nix
    ./boot.nix
  ];
  config = {
    fileSystems = {
      "/" = {
        device = "/dev/disk/by-label/NIXOS";
        fsType = "ext4";
      };
      "/var/log" = {
        fsType = "tmpfs";
      };
    };

    boot.tmp.useTmpfs = true;
    boot.growPartition = true;

    networking.hostName = "nixos";
    networking.useDHCP = true;

    nix = {
      settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    environment.systemPackages = with pkgs; [
      git
      python3
      mc
      psmisc
      curl
      wget
      dig
      file
      nvd
      ethtool
      sysstat
    ];

    security.sudo.wheelNeedsPassword = false;
    nix.settings.trusted-users = [
      "root"
      "@wheel"
    ];

    users.users.nix = {
      isNormalUser = true;
      description = "nix";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      password = "nix";
    };

    services.openssh.enable = true;

    i18n = {
      defaultLocale = "en_GB.UTF-8";
    };

    environment.etc = {
      "systemd/journald.conf.d/99-storage.conf".text = ''
        [Journal]
        Storage=volatile
      '';
    };

    system.stateVersion = lib.mkDefault "25.05";
  };
}
