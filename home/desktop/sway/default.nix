{
  pkgs,
  libx,
  isGeneric,
  config,
  ...
}: let
  inherit (libx) fonts sway;
  inherit (sway) mkWorkspaceKeys mkDirectionKeys;
  wezterm =
    if isGeneric
    then pkgs.stash.wezterm_wrapped
    else pkgs.stash.wezterm_nightly;
in {
  imports = [
    ./waybar.nix
  ];

  home.packages = [
    pkgs.j4-dmenu-desktop
    pkgs.dmenu
  ];
  wayland.windowManager.sway = {
    enable = true;
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland

      # Firefox wayland
      export MOZ_ENABLE_WAYLAND=1

      # XDG portal related variables (for screen sharing etc)
      export XDG_SESSION_TYPE=wayland
      export XDG_CURRENT_DESKTOP=sway

      # Run QT programs in wayland
      export QT_QPA_PLATFORM=wayland
    '';
    wrapperFeatures = {
      # Fixes GTK applications under Sway
      gtk = true;
      # To run Sway with dbus-run-session and other stuff
      # (dbus-run-session is unneeded since dbus is socket activated in NixOS now)
      base = true;
    };

    swaynag.enable = true;
    config = rec {
      modifier = "Mod4";
      up = "k";
      down = "j";
      left = "h";
      right = "l";
      output = {
        HDMI-A-1 = {
          pos = "0 -1080";
          res = "1920x1080";
        };
        eDP-1 = {
          pos = "0 0";
          res = "1920x1080";
        };
      };
      window = {
        titlebar = false;
        border = 1;
        commands = [
          {
            command = "gaps border 0";
            criteria = {
              pid = "2972";
            };
          }
        ];
      };

      keybindings = let
        rofi = pkgs.rofi.override {plugins = [pkgs.rofi-emoji];};
        # pactl = "${pkgs.pulseaudio}/bin/pactl";
      in
        {
          "${modifier}+f" = "exec ${pkgs.foot}/bin/foot";
          "${modifier}+Shift+w" = "exec ${wezterm}/bin/wezterm";
          "${modifier}+Shift+q" = "kill";
          "${modifier}+Shift+c" = "reload";
          "${modifier}+e" = "exec ${pkgs.j4-dmenu-desktop}/bin/j4-dmenu-desktop --dmenu=${pkgs.bemenu}/bin/bemenu' | xargs ${pkgs.sway}/bin/swaymsg exec --";

          # "${modifier}+e" = "exec ${rofi}/bin/rofi -show combi -theme glue_pro_blue | xargs swaymsg exec --";
          "${modifier}+i" = "exec ${rofi}/bin/rofi -show emoji -theme glue_pro_blue";
          "${modifier}+d" = "exec ${rofi}/bin/rofi -show drun -theme glue_pro_blue";
          "Ctrl+Alt+l" = "workspace next";
          "Ctrl+Alt+h" = "workspace prev";
          # Split in horizontal orientation:
          "${modifier}+h" = "split h";

          # Split in vertical orientation:
          "${modifier}+v" = "split v";
          # Change layout of focused container:
          "${modifier}+o" = "layout stacking";
          "${modifier}+comma" = "layout tabbed";
          "${modifier}+period" = "layout toggle split";

          # Fullscreen for the focused container:
          "${modifier}+u" = "fullscreen toggle";

          # Toggle the current focus between tiling and floating mode:
          "${modifier}+Shift+space" = "floating toggle";

          # Swap focus between the tiling area and the floating area:
          "${modifier}+space" = "focus mode_toggle";

          Print = "exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.swappy}/bin/swappy -f -";

          # # Backlight:
          # XF86MonBrightnessUp = "exec ${pkgs.acpilight}/bin/xbacklight -inc 10";
          # XF86MonBrightnessDown = "exec ${pkgs.acpilight}/bin/xbacklight -dec 10";
          #
          # # Audio:
          # XF86AudioMute = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
          # XF86AudioLowerVolume = "exec pactl set-sink-volume @DEFAULT_SINK@ -10%";
          # XF86AudioRaiseVolume = "exec pactl set-sink-volume @DEFAULT_SINK@ +10%";
          # XF86AudioMicMute = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";
          # Focus the parent container
          # "${modifier}+a" = "focus parent";

          # Focus the child container
          # "${modifier}+d" = "focus child";

          # Move window to scratchpad:
          "${modifier}+Shift+minus" = "move scratchpad";

          # Show scratchpad window and cycle through them:
          "${modifier}+minus" = "scratchpad show";

          # Enter other modes:
          "${modifier}+r" = "mode resize";
          "${modifier}+Shift+r" = "mode passthrough";
        }
        // mkDirectionKeys modifier {inherit up down left right;}
        // mkWorkspaceKeys modifier ["1" "2" "3" "4" "5"];

      modes.resize = {
        "${left}" = "resize shrink width 10px"; # Pressing left will shrink the window’s width.
        "${right}" = "resize grow width 10px"; # Pressing right will grow the window’s width.
        "${up}" = "resize shrink height 10px"; # Pressing up will shrink the window’s height.
        "${down}" = "resize grow height 10px"; # Pressing down will grow the window’s height.

        Left = "resize shrink width 10px";
        Down = "resize grow height 10px";
        Up = "resize shrink height 10px";
        Right = "resize grow width 10px";

        # Exit mode
        Return = "mode default";
        Escape = "mode default";
        "${modifier}+r" = "mode default";
      };
      modes.passthrough = {
        # Exit mode
        "Shift+Escape" = "mode default";
        "${modifier}+Shift+r" = "mode default";
      };

      focus.wrapping = "workspace";
      focus.newWindow = "urgent";
      gaps.inner = 2;
      defaultWorkspace = "workspace number 1";
      bars = [{mode = "invisible";}];
      startup = [
        # {command = "${pkgs.mako}/bin/mako";}

        # Import variables needed for screen sharing and gnome3 pinentry to work.
        # {command = "${pkgs.dbus}/bin/dbus-update-activation-environment WAYLAND_DISPLAY";}

        # Reload kanshi on reload of config
        # {
        #   command = "${config.systemd.package}/bin/systemctl --user restart kanshi";
        #   always = true;
        # }
      ];
    };
  };
  programs.bemenu = {
    enable = true;
    settings = {
      line-height = 28;
      prompt = "open";
      ignorecase = true;
      fb = "#1e1e2e";
      ff = "#cdd6f4";
      nb = "#1e1e2e";
      nf = "#cdd6f4";
      tb = "#1e1e2e";
      hb = "#1e1e2e";
      tf = "#f38ba8";
      hf = "#f9e2af";
      af = "#cdd6f4";
      ab = "#1e1e2e";
      width-factor = 0.3;
    };
  };
}
