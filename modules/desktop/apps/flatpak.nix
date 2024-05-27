{username, ...}: {
  services.flatpak = {
    enable = true;
    uninstallUnmanaged = true;
    update.auto = {
      enable = true;
      onCalendar = "weekly"; # Default value
    };
    packages = [
      "io.gitlab.librewolf-community"
      "so.libdb.dissent"
      "org.freedesktop.Bustle"
      "io.github.bytezz.IPLookup"
      "com.github.geigi.cozy"
      "com.obsproject.Studio"
      "org.kde.kdenlive"
      "com.rafaelmardojai.SharePreview"
      "net.nokyan.Resources"
      "io.github.flattool.Warehouse"
      "org.mozilla.Thunderbird"
      "com.github.huluti.Coulr"
      "com.github.muriloventuroso.pdftricks"
      "com.slack.Slack"
      "io.beekeeperstudio.Studio"
      "io.github.dvlv.boxbuddyrs"
      "io.github.shiftey.Desktop"
      "md.obsidian.Obsidian"
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
    "/persist/system".directories = [
      "/var/lib/flatpak"
    ];
    "/persist".users.${username}.directories = [
      ".var/app/org.telegram.desktop"
    ];
  };
}
