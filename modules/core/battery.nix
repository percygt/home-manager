{
  config,
  pkgs,
  lib,
  libx,
  ...
}:
let
  p = pkgs.writeScriptBin "charge-upto" ''
    echo ''${0:-100} > /sys/class/power_supply/BAT?/charge_control_end_threshold
  '';
  cfg = config.modules.core.battery;
in
{
  options.modules.core.battery = {
    enable = libx.enableDefault "battery";
    chargeUpto = lib.mkOption {
      description = "Maximum level of charge for your battery, as a percentage.";
      default = 80;
      type = lib.types.int;
    };
    enableChargeUptoScript = lib.mkOption {
      description = "Whether to add charge-upto to environment.systemPackages. `charge-upto 75` temporarily sets the charge limit to 75%.";
      type = lib.types.bool;
      default = cfg.enable;
    };
  };
  config = lib.mkIf cfg.enable {
    services.thermald.enable = true;
    services.auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };
        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };
    environment.systemPackages = lib.mkIf cfg.enableChargeUptoScript [ p ];
    systemd.services.battery-charge-threshold = {
      wantedBy = [
        "local-fs.target"
        "suspend.target"
      ];
      after = [
        "local-fs.target"
        "suspend.target"
      ];
      description = "Set the battery charge threshold to ${toString cfg.chargeUpto}%";
      startLimitBurst = 5;
      startLimitIntervalSec = 1;
      serviceConfig = {
        Type = "oneshot";
        Restart = "on-failure";
        ExecStart = "${pkgs.runtimeShell} -c 'echo ${toString cfg.chargeUpto} > /sys/class/power_supply/BAT?/charge_control_end_threshold'";
      };
    };
  };
}
