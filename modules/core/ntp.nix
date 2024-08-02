{
  config,
  lib,
  libx,
  ...
}:
{
  options.modules.core.ntp = {
    enable = libx.enableDefault "ntp";
  };

  config = lib.mkIf config.modules.core.ntp.enable {
    services.chrony.enable = true;
    networking.timeServers = [
      "time.upd.edu.ph"
      "time.cloudflare.com"
      "0.nixos.pool.ntp.org"
      "1.nixos.pool.ntp.org"
      "2.nixos.pool.ntp.org"
      "3.nixos.pool.ntp.org"
    ];
  };
}
