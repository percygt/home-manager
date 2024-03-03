# home.nix
{
  pkgs,
  config,
  username,
  lib,
  flakeDirectory,
  colors,
  ...
}: let
  THEME = "Colloid-Dark-Nord";
  CURSOR = "Colloid-dark-cursors";
  ICON = "Papirus-Dark";
  FONT = "Rubik";
  HOME_THEMES = "${config.home.homeDirectory}/.themes";

  pkg-colloid-gtk-theme = pkgs.colloid-gtk-theme.overrideAttrs (oldAttrs: {
    installPhase = ''
      runHook preInstall

      # override colors
      sed -i "s\#0d0e11\#${colors.default.background}\g" ./src/sass/_color-palette-nord.scss
      sed -i "s\#bf616a\#${colors.bright.red}\g" ./src/sass/_color-palette-nord.scss
      sed -i "s\#a3be8c\#${colors.normal.magenta}\g" ./src/sass/_color-palette-nord.scss
      sed -i "s\#ebcb8b\#${colors.bright.yellow}\g" ./src/sass/_color-palette-nord.scss
      sed -i "s\#3a4150\#${colors.extra.azure}\g" ./src/sass/_color-palette-nord.scss
      sed -i "s\#333a47\#${colors.extra.nocturne}\g" ./src/sass/_color-palette-nord.scss
      sed -i "s\#242932\#${colors.extra.nocturne}\g" ./src/sass/_color-palette-nord.scss
      sed -i "s\#1e222a\#${colors.extra.obsidian}\g" ./src/sass/_color-palette-nord.scss

      name= HOME="$TMPDIR" ./install.sh \
        --color dark \
        --tweaks rimless nord \
        --dest $out/share/themes

      jdupes --quiet --link-soft --recurse $out/share

      runHook postInstall
    '';
  });
in {
  gtk = {
    enable = true;
    theme = {
      name = THEME;
      package = pkg-colloid-gtk-theme;
    };
    cursorTheme = {
      name = CURSOR;
      package = pkgs.colloid-icon-theme;
    };
    iconTheme = {
      name = ICON;
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = FONT;
      package = pkgs.rubik;
      size = 10;
    };
    gtk3 = {
      bookmarks = [
        "file:///${flakeDirectory}"
        "file:///home/${username}/.local"
        "file:///home/${username}/.config"
        "file:///windows"
        "file:///backup"
        "file:///data/playground"
        "file:///data/git-repo"
        "file:///data/logs"
        "file:///data/codebox"
        "file:///data/distrobox"
        "file:///data"
        "file:///home/${username}/Documents"
        "file:///home/${username}/Music"
        "file:///home/${username}/Pictures"
        "file:///home/${username}/Videos"
        "file:///home/${username}/Downloads"
      ];
    };
  };

  home = {
    activation = {
      cpGtkThemeIfDoesNotExist = lib.hm.dag.entryAfter ["linkGeneration"] ''
        [ -e "${HOME_THEMES}" ] || mkdir "${HOME_THEMES}"
        [ -e "${HOME_THEMES}/${THEME}" ] || cp -r "${pkg-colloid-gtk-theme}/share/themes/${THEME}" "${HOME_THEMES}/${THEME}"
      '';
    };
    packages = with pkgs; [
      rubik
      papirus-icon-theme
      colloid-gtk-theme
      colloid-icon-theme
      kora-icon-theme
      sweet
    ];
    # pointerCursor = {
    #   package = pkgs.colloid-icon-theme;
    #   name = CURSOR;
    #   size = 24;
    #   gtk.enable = true;
    #   x11.enable = true;
    # };
    sessionVariables = {
      GTK_THEME = THEME;
      GTK_CURSOR = CURSOR;
      XCURSOR_THEME = CURSOR;
      GTK_ICON = ICON;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      cursor-theme = CURSOR;
      gtk-theme = THEME;
      icon-theme = ICON;
      # font-name = FONT;
    };
  };
}