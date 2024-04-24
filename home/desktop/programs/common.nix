{pkgs, ...}: {
  programs = {
    firefox.enable = true;
    mpv.enable = true;
  };

  home.packages = with pkgs; [
    gnome.nautilus
    # zoom-us
    audacity
    # bambu-studio
    desktop-file-utils
    libnotify
    loupe
    # mumble
    # obsidian
    # rambox
    # signal-desktop
    # todoist-electron
    # xorg.xlsclients
  ];
}
