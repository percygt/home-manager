{pkgs, ...}: {
  services = {
    # needed for GNOME services outside of GNOME Desktop
    dbus = {
      enable = true;
      packages = with pkgs; [
        gcr
        gnome.gnome-settings-daemon
        dconf
      ];
      implementation = "broker";
    };
    gnome.gnome-keyring.enable = true;
  };
}
