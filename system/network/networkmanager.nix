{
  lib,
  config,
  ...
}: {
  options = {
    network.networkmanager = {
      enable =
        lib.mkEnableOption "Enable networkmanager";
    };
  };

  config = lib.mkIf config.network.networkmanager.enable {
    networking = {
      networkmanager = {
        enable = true;
        wifi = {
          backend = "iwd";
          # powersave = true;
        };
        # dns = "systemd-resolved";
      };
    };

    # Workaround https://github.com/NixOS/nixpkgs/issues/180175
    systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
  };
}
