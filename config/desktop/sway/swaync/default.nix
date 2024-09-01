{
  pkgs,
  config,
  lib,
  ...
}:
let
  g = config._general;
  moduleSwaync = "${g.flakeDirectory}/config/desktop/sway/swaync";
  c = config.modules.theme.colors.withHashtag;
  f = config.modules.fonts.app;
  i = config.modules.fonts.icon;
  extraPackages =
    g.envPackages
    ++ (with pkgs; [
      toggle-service
      toggle-sway-window
      wlsunset
      foot
      grim
      slurp
      swappy
      g.desktop.sway.package
    ]);
  swayncWithExtraPackages =
    pkgs.runCommand "swaync"
      {
        nativeBuildInputs = [ pkgs.makeWrapper ];
        meta.mainProgram = "swaync";
      }
      ''
        makeWrapper ${pkgs.swaynotificationcenter}/bin/swaync $out/bin/swaync --prefix PATH : ${lib.makeBinPath extraPackages}
        makeWrapper ${pkgs.swaynotificationcenter}/bin/swaync-client $out/bin/swaync-client --prefix PATH : ${lib.makeBinPath extraPackages}
      '';
in
{
  services.swaync = {
    enable = true;
    package = swayncWithExtraPackages;
  };

  xdg.configFile = {
    "swaync/config.json" = lib.mkForce {
      source = config.lib.file.mkOutOfStoreSymlink "${moduleSwaync}/config.json";
    };
    "swaync/style.css" = {
      source = config.lib.file.mkOutOfStoreSymlink "${moduleSwaync}/style.css";
    };
    "swaync/configSchema.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${moduleSwaync}/configSchema.json";
    };
    "swaync/nix.css".text =
      # css
      ''
        @define-color bg ${c.base00};
        @define-color bg-lighter ${c.base10};
        @define-color bg-darker ${c.base11};
        @define-color bg-alt ${c.base02};
        @define-color grey ${c.base03};
        @define-color grey-alt ${c.base04};
        @define-color border ${c.base03};
        @define-color text-dark ${c.base01};
        @define-color text-light ${c.base05};
        @define-color green ${c.base0B};
        @define-color blue ${c.base0D};
        @define-color red ${c.base08};
        @define-color purple ${c.base0E};
        @define-color orange ${c.base0F};
        @define-color transparent rgba(0,0,0,0);
        @define-color bg-hover rgba(255, 255, 255, 0.1);
        @define-color bg-focus rgba(255, 255, 255, 0.1);
        @define-color bg-close rgba(255, 255, 255, 0.1);
        @define-color bg-close-hover rgba(255, 255, 255, 0.15);
        * {
          font-family: '${f.name}, ${i.name}';
        }
      '';
  };
}
