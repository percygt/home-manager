{
  pkgs,
  lib,
  config,
  libx,
  isGeneric,
  ...
}:
let
  g = config._general;
  cfg = config.wayland.windowManager.sway.config;
  mod = cfg.modifier;
  wez-ddterm = if isGeneric then pkgs.wez-wrapped-ddterm else pkgs.wez-nightly-ddterm;
  inherit (libx) sway;
  inherit (sway)
    viewRebuildLogCmd
    viewBackupLogCmd
    mkWorkspaceKeys
    mkDirectionKeys
    ;
in
{
  home.packages = [ pkgs.ddapp ];
  wayland.windowManager.sway.config.keybindings =
    mkDirectionKeys mod {
      inherit (cfg)
        up
        down
        left
        right
        ;
    }
    // mkWorkspaceKeys mod [
      "1"
      "2"
      "3"
      "4"
      "5"
      "6"
      "7"
      "8"
      "9"
      "10"
    ]
    // {
      "Ctrl+KP_Insert" = "exec ${lib.getExe pkgs.toggle-sway-window} --id system-software-update -- ${viewRebuildLogCmd}";
      "Ctrl+KP_Delete" = "exec ${lib.getExe pkgs.toggle-sway-window} --id backup -- ${viewBackupLogCmd}";
      "Ctrl+Shift+KP_Insert" = "exec systemctl --user start nixos-rebuild";
      "${mod}+Space" = "exec swaync-client -t -sw";
      "${mod}+Alt+Space" = "exec pkill tofi || ${lib.getExe pkgs.tofi-power-menu}";
      "Ctrl+Alt+w" = "exec ${lib.getExe wez-ddterm}";
      "${mod}+w" = "exec ${lib.getExe pkgs.foot-ddterm}";
      "Ctrl+Alt+return" = "exec ${lib.getExe config.programs.wezterm.package}";
      "${mod}+Return" = "exec ${lib.getExe pkgs.foot}";
      "${mod}+s" = "exec pkill tofi-drun || tofi-drun --drun-launch=true --prompt-text=\"Apps: \"| xargs swaymsg exec --";
      "${mod}+x" = "exec pkill tofi-run || tofi-run --prompt-text=\"Run: \"| xargs swaymsg exec --";
      "${mod}+m" = "exec ${lib.getExe pkgs.toggle-sway-window} --id btop -- foot --title=SystemMonitor --app-id=btop btop";
      "${mod}+v" = "exec ${lib.getExe pkgs.toggle-sway-window} --id pavucontrol -- pavucontrol";
      "${mod}+n" = "exec ${lib.getExe pkgs.toggle-sway-window} --id wpa_gui -- wpa_gui";
      # TODO: decide on what dropdown/window-toggle script to use. Maybe rewrite ddapp in babashka
      "${mod}+e" = "exec ${lib.getExe pkgs.i3-quickterm} emacseditor";
      "${mod}+Shift+e" = "exec ${lib.getExe pkgs.ddapp} -p emacsconfigddterm -c 'emacs ${g.flakeDirectory}/modules/editor/emacs'";
      "${mod}+Shift+i" = "exec ${lib.getExe pkgs.toggle-sway-window} --id \"chrome-chatgpt.com__-WebApp-ai\" -- ${config.xdg.desktopEntries.ai.exec}";
      "${mod}+Shift+d" = "exec ${lib.getExe pkgs.toggle-sway-window} --id gnome-disks -- gnome-disks";
      "${mod}+b" = "exec ${lib.getExe pkgs.toggle-sway-window} --id .blueman-manager-wrapped -- blueman-manager";
      "${mod}+k" = "exec pkill tofi || keepmenu | xargs swaymsg exec --";
      "${mod}+Shift+k" = "exec pkill tofi || ${lib.getExe pkgs.tofi-pass}";
      "${mod}+f" = "exec ${lib.getExe pkgs.toggle-sway-window} --id yazi -- foot --app-id=yazi fish -c yazi ~";
      "${mod}+Shift+f" = "exec ${lib.getExe pkgs.toggle-sway-window} --id nemo -- nemo ~";
      "${mod}+Shift+Tab" = "exec ${lib.getExe pkgs.cycle-sway-output}";
      "${mod}+Tab" = "workspace back_and_forth";
      "${mod}+Backslash" = "exec ${lib.getExe pkgs.cycle-sway-scale}";
      "${mod}+Delete" = "exec swaylock";

      XF86Calculator = "exec ${lib.getExe pkgs.toggle-sway-window} --id qalculate-gtk -- qalculate-gtk";
      XF86Launch1 = "exec ${lib.getExe pkgs.toggle-service} wlsunset";

      "F11" = "fullscreen toggle";
      "${mod}+Shift+q" = "kill";
      "${mod}+Shift+t" = "layout stacking";
      "${mod}+t" = "layout tabbed";
      "${mod}+Alt+s" = "layout toggle split";
      "${mod}+Shift+s" = "sticky toggle";
      "${mod}+Less" = "focus parent";
      "${mod}+Greater" = "focus child";
      "${mod}+Shift+Minus" = "split h";
      "${mod}+Shift+Backslash" = "split v";
      "${mod}+Shift+Space" = "floating toggle";
      "${mod}+Shift+r" = "reload";

      "Ctrl+Alt+l" = "workspace next";
      "Ctrl+Alt+h" = "workspace prev";

      "Ctrl+Print" = "exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.swappy}/bin/swappy -f -";

      # Backlight:
      XF86MonBrightnessUp = "exec brightnessctl set 5%+";
      XF86MonBrightnessDown = "exec brightnessctl set 5%-";

      # Audio:
      XF86AudioMute = "exec pamixer --toggle-mute";
      XF86AudioLowerVolume = "exec pamixer --decrease 5";
      XF86AudioRaiseVolume = "exec pamixer --increase 5";
      XF86AudioMicMute = "exec pamixer --default-source -t";

      # Move window to scratchpad:
      "${mod}+Minus" = "move scratchpad";

      # Show scratchpad window and cycle through them:
      "${mod}+Plus" = "scratchpad show";

      # Enter other modes:
      "${mod}+r" = "mode resize";
      "${mod}+Shift+p" = "mode passthrough";
    };
}
