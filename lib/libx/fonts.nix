{desktop, ...}: {
  interface =
    if desktop == "gnome"
    then {
      name = "Rubik";
      style = "Regular";
      package = pkgs: pkgs.rubik;
      size = 10.0;
    }
    else {
      name = "GeistMono Nerd Font";
      style = "Regular";
      package = pkgs: pkgs.nerdfonts.override {fonts = ["GeistMono"];};
      size = 10.0;
    };

  app = {
    name = "Rubik";
    style = "Regular";
    package = pkgs: pkgs.rubik;
    size = 10.0;
  };

  shell = {
    name = "VictorMono Nerd Font";
    style = "SemiBold";
    package = pkgs: pkgs.nerdfonts.override {fonts = ["VictorMono"];};
    size = 14;
  };

  console = {
    name = "JetBrainsMono Nerd Font";
    style = "Regular";
    package = pkgs: pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];};
    size = 14;
  };

  packages = pkgs:
    with pkgs; [
      (nerdfonts.override {
        fonts = [
          "VictorMono"
          "JetBrainsMono"
          "MartianMono"
          "GeistMono"
        ];
      })
      # martian-mono
      source-serif
      rubik
      work-sans
      noto-fonts
      noto-fonts-cjk
      joypixels
      noto-fonts-emoji
      font-awesome

      corefonts
      vistafonts
      ubuntu_font_family
    ];
}
