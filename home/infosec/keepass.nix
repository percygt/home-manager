{
  pkgs,
  lib,
  config,
  homeDirectory,
  ...
}: let
  kmk0 = "${homeDirectory}/data/config/keeps/m0.kdbx";
in {
  options = {
    infosec.keepass.enable =
      lib.mkEnableOption "Enable keepass";
  };

  config = lib.mkIf config.infosec.keepass.enable {
    home = {
      packages = with pkgs; [keepassxc];
      sessionVariables.KPDB = kmk0;
      file."${config.xdg.cacheHome}/keepassxc/keepassxc.ini".text = lib.generators.toINI {} {
        General.LastActiveDatabase = kmk0;
      };
    };

    xdg = {
      configFile = {
        "keepassxc/keepassxc.ini".text = lib.generators.toINI {} {
          General = {
            ConfigVersion = 2;
            MinimizeAfterUnlock = true;
          };
          Browser.Enabled = true;
          GUI = {
            ApplicationTheme = "classic";
            ColorPasswords = true;
            MinimizeOnClose = true;
            MinimizeToTray = true;
            MonospaceNotes = true;
            ShowTrayIcon = true;
            TrayIconAppearance = "monochrome-light";
          };

          Security.IconDownloadFallback = true;
        };
      };
    };
  };
}
