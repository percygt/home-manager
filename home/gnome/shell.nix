# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{
  lib,
  flakeDirectory,
  config,
  ...
}: let
  WALLPAPER_PATH = builtins.toString ../../assets/gradient1.png;
  SHELL_THEME_PATH = builtins.toString ../_config/gtk/themes;
  wallpaper = "file://${WALLPAPER_PATH}";
  LOCAL_THEMES = "${config.xdg.dataHome}/themes";
  SHELL_THEME = "Marble-crispblue-dark";
in {
  home = {
    activation = {
      lnShellThemeIfDoesNotExist = lib.hm.dag.entryAfter ["linkGeneration"] ''
        [ -e "${LOCAL_THEMES}/${SHELL_THEME}" ] || ln -s "${SHELL_THEME_PATH}/${SHELL_THEME}" "${LOCAL_THEMES}/${SHELL_THEME}"
      '';
    };
  };
  dconf.settings = with lib.hm.gvariant; {
    "org/gnome/shell/extensions/user-theme" = {
      name = SHELL_THEME;
    };
    "org/gnome/desktop/screensaver" = {
      picture-uri = wallpaper;
    };
    "org/gnome/desktop/background" = {
      picture-uri = wallpaper;
      picture-uri-dark = wallpaper;
    };
    "org/gnome/desktop/input-sources" = {
      # remap capslock to esc
      xkb-options = ["caps:escape"];
    };
    "org/gnome/desktop/wm/preferences" = {
      action-double-click-titlebar = "toggle-maximize";
      action-middle-click-titlebar = "minimize";
      action-right-click-titlebar = "menu";
      audible-bell = true;
      auto-raise = false;
      auto-raise-delay = 500;
      button-layout = ":minimize,maximize,close";
      disable-workarounds = false;
      focus-mode = "click";
      focus-new-windows = "smart";
      mouse-button-modifier = "<Super>";
      num-workspaces = 8;
      raise-on-click = true;
      resize-with-right-button = true;
      titlebar-font = "Rubik 10";
      titlebar-uses-system-font = true;
    };
    "org/gnome/desktop/interface" = {
      clock-format = "12h";
      clock-show-date = true;
      clock-show-seconds = true;
      clock-show-weekday = true;
      cursor-blink = true;
      cursor-blink-time = 1200;
      cursor-blink-timeout = 10;
      document-font-name = "Noto Sans CJK HK Bold 10";
      enable-animations = true;
      enable-hot-corners = false;
      font-antialiasing = "rgba";
      font-hinting = "full";
      font-rgba-order = "rgb";
      gtk-color-scheme = "";
      gtk-enable-primary-paste = true;
      gtk-im-module = "gtk-im-context-simple";
      gtk-im-preedit-style = "callback";
      gtk-im-status-style = "callback";
      gtk-key-theme = "Default";
      gtk-timeout-initial = 200;
      gtk-timeout-repeat = 20;
      locate-pointer = true;
      menubar-accel = "F10";
      menubar-detachable = false;
      menus-have-icons = false;
      menus-have-tearoff = false;
      monospace-font-name = "JetBrainsMono Nerd Font 10";
      overlay-scrolling = true;
      scaling-factor = mkUint32 0;
      show-battery-percentage = false;
      show-input-method-menu = true;
      show-unicode-menu = true;
      text-scaling-factor = 1.0;
      toolbar-detachable = false;
      toolbar-icons-size = "large";
      toolbar-style = "both-horiz";
      toolkit-accessibility = false;
    };

    "org/gnome/shell" = {
      enabled-extensions = [
        "quick-settings-tweaks@qwreey"
        "Battery-Health-Charging@maniacx.github.com"
        "bluetooth-quick-connect@bjarosze.gmail.com"
        "mprisLabel@moon-0xff.github.com"
        "quake-mode@repsac-by.github.com"
        "customreboot@nova1545"
        "ShutdownTimer@deminder"
        "improved-workspace-indicator@michaelaquilina.github.io"
        "reboottouefi@ubaygd.com"
        "docker@stickman_0x00.com"
        "pano@elhan.io"
        "panel-date-format@atareao.es"
        "date-menu-formatter@marcinjakubowski.github.com"
        "update-extension@purejava.org"
        "space-bar@luchrioh"
        "supergfxctl-gex@asus-linux.org"
        "appindicatorsupport@rgcjonas.gmail.com"
        "dash-to-panel@jderose9.github.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "vertical-workspaces@G-dH.github.com"
        "ddterm@amezin.github.com"
        "caffeine@patapon.info"
        "pop-shell@system76.com"
        "rounded-window-corners@yilozt"
        "trimmer@hedgie.tech"
        # "blur-my-shell@aunetx"
        "system-stats-plus@remulo.costa.gmail.com"
        # "just-perfection-desktop@just-perfection"
        "unredirect@vaina.lt"
      ];
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "codium.desktop"
        "brave-browser.desktop"
        "firefox.desktop"
        "com.github.tchx84.Flatseal.desktop"
        "org.keepassxc.KeePassXC.desktop"
        "btrfs-assistant.desktop"
        "com.discordapp.Discord.desktop"
        "io.beekeeperstudio.Studio.desktop"
        "org.cockpit_project.CockpitClient.desktop"
        "md.obsidian.Obsidian.desktop"
        "virt-manager.desktop"
      ];
      last-selected-power-profile = "performance";
    };
    "org/gnome/mutter" = {
      # attach-modal-dialogs = true;
      # auto-maximize = false;
      center-new-windows = true;
      dynamic-workspaces = true;
      edge-tiling = false;
      experimental-features = ["scale-monitor-framebuffer"];
      locate-pointer-key = "Control_L";
      overlay-key = "";
      workspaces-only-on-primary = true;
    };
  };
}
