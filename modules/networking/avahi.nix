{ lib, config, ... }:
{
  options.modules.networking.avahi.enable = lib.mkEnableOption "Enable avahi";

  config = lib.mkIf config.modules.networking.avahi.enable {
    # network discovery, mDNS
    services.avahi = {
      enable = true;
      openFirewall = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        addresses = true;
        domain = true;
        hinfo = true;
        userServices = true;
        workstation = true;
      };
    };
  };
}