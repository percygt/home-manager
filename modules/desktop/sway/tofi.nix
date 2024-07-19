{
  pkgs,
  config,
  configx,
  ...
}:
let
  inherit (configx) fonts;
  c = config.scheme.withHashtag;
in
{
  home.packages = with pkgs; [ tofi ];
  xdg.configFile = {
    "tofi/config".text = ''
      # vim: ft=dosini
      ; BEHAVIOR OPTIONS
      hide-cursor = true
      text-cursor = false
      history = true
      fuzzy-match = false
      require-match = true
      auto-accept-single = false
      hide-input = false
      drun-launch = false
      late-keyboard-init = false
      multi-instance = false
      ascii-input = true

      # STYLE OPTIONS
      font = ${fonts.interface.name}
      font-variations = "wght ${fonts.interface.weight}"
      selection-color = ${c.base07}
      prompt-color =  ${c.base0D}
      text-color = ${c.base04}
      background-color = ${c.base00}
      prompt-padding = 2
      anchor = top
      width = 0
      horizontal = true
      font-size = 10
      outline-width = 0
      border-width = 0
      min-input-width = 120
      result-spacing = 10
      corner-radius = 12
      height = 25
      margin-top = 5
      margin-left = 5
      margin-right = 5
      margin-bottom = 0
      padding-top = 0
      padding-bottom = 0
      padding-left = 10
      padding-right = 10
    '';
  };
}
