{
  services.flatpak = {
    enable = true;
    uninstallUnmanaged = true;
    update.auto = {
      enable = true;
      onCalendar = "weekly"; # Default value
      onActivation = true;
    };
    packages = [
      "ca.desrt.dconf-editor"
      "com.github.KRTirtho.Spotube"
      "org.mozilla.Thunderbird"
      "com.github.finefindus.eyedropper"
      "com.github.muriloventuroso.pdftricks"
      "com.slack.Slack"
      "io.beekeeperstudio.Studio"
      "io.github.dvlv.boxbuddyrs"
      "io.github.shiftey.Desktop"
      "org.gimp.GIMP"
      "org.gnome.Calculator"
      "org.gnome.Firmware"
      "org.gnome.Snapshot"
      "org.libreoffice.LibreOffice"
      "org.telegram.desktop"
      "page.codeberg.Imaginer.Imaginer"
      "rest.insomnia.Insomnia"
    ];
  };
  fileSystems = {
    "/var/lib/flatpak".options = ["exec"];
  };
  environment.persistence = {
    "/persist/system".directories = ["/var/lib/flatpak"];
  };
}
