{
  pkgs,
  config,
  lib,
  ...
}:
let
  loginctl = "${pkgs.systemd}/bin/loginctl";
  swaymsg = "${config._general.desktop.sway.package}/bin/swaymsg";
  systemctl = "${pkgs.systemd}/bin/systemctl";
in
{

  systemd.user.services.swayidle.Service.ExecStop = lib.getExe (
    pkgs.writeShellApplication {
      name = "swayidle-cleanup";
      runtimeInputs = [ pkgs.coreutils ];
      text = ''
        BLOCKFILE="$HOME/.local/share/idle-sleep-block"
        if test -f "$BLOCKFILE"; then
          rm "$BLOCKFILE"
        fi
      '';
    }
  );
  services = {
    swayidle = {
      enable = true;
      systemdTarget = "sway-session.target";
      events = [
        {
          event = "before-sleep";
          command = lib.getExe (
            pkgs.writeShellApplication {
              runtimeInputs = [
                pkgs.coreutils
                pkgs.sway
                pkgs.swaylock
              ];
              name = "swayidle-before-sleep";
              text = ''
                swaylock --daemonize
                swaymsg 'output * power off'
              '';
            }
          );
        }
        {
          event = "after-resume";
          command = lib.getExe (
            pkgs.writeShellApplication {
              name = "swayidle-after-resume";
              runtimeInputs = [
                pkgs.coreutils
                pkgs.sway
                pkgs.pomo
              ];
              text = ''
                if [ -f "$HOME/.local/share/pomo" ]; then pomo start || true; fi
                ${pkgs.sway}/bin/swaymsg 'output * power on'
              '';
            }
          );
        }
      ];

      timeouts = [
        {
          timeout = 30 * 60;
          command = lib.getExe (
            pkgs.writeShellApplication {
              name = "swayidle-sleepy-sleep";
              runtimeInputs = [
                pkgs.coreutils
                pkgs.systemd
                pkgs.playerctl
                pkgs.gnugrep
                pkgs.acpi
                pkgs.swaylock
              ];
              text = ''
                set -x
                if test -f "$HOME/.local/share/idle-sleep-block"; then
                  echo "Restarting service because of idle-sleep-block file"
                  systemctl --restart swayidle.service
                elif acpi --ac-adapter | grep -q "on-line"; then
                  echo "Restarting service because laptop is plugged in"
                  systemctl --restart swayidle.service
                else
                  echo "Idle timeout reached. Night night."
                  systemctl sleep
                fi
              '';
            }
          );
        }
        {
          timeout = 15 * 60;
          command = "${swaymsg} 'output * power off'";
          resumeCommand = "${swaymsg} 'output * power on' && '${systemctl} --user restart kanshi'";
        }
      ];
    };
  };
}
