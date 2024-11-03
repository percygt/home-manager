{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.modules.fonts;
  optionals =
    { fonttype, typeface }:
    lib.optionals (cfg."${fonttype}".typeface == typeface) [ cfg."${fonttype}".name ];
  setFontConfig =
    typeface:
    (optionals {
      inherit typeface;
      fonttype = "interface";
    })
    ++ (optionals {
      inherit typeface;
      fonttype = "shell";
    });
in
{
  config = {
    nixpkgs.config.joypixels.acceptLicense = true;
    fonts = {
      enableDefaultPackages = false;
      fontDir.enable = true;
      packages = import ./allFonts.nix { inherit pkgs config; };
      fontconfig = {
        antialias = true;
        defaultFonts = {
          serif = setFontConfig "serif" ++ [
            "Source Serif"
            "Noto Serif"
          ];
          sansSerif = setFontConfig "sansSerif" ++ [
            "Inter"
            "Work Sans"
            "Noto Sans"
            "Source Sans Pro"
          ];
          monospace = setFontConfig "monospace" ++ [
            "Roboto Mono"
            "Noto Sans Mono"
            "JetBrainsMono Nerd Font"
            "Symbols Nerd Font Mono"
          ];
          emoji = [
            "Joypixels"
            "Noto Color Emoji"
          ];
        };
        enable = true;
        hinting = {
          autohint = false;
          enable = true;
          style = "slight";
        };
        subpixel = {
          rgba = "rgb";
          lcdfilter = "light";
        };
      };
    };
  };
}