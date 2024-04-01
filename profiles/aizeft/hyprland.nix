{
  wayland.windowManager.hyprland.settings = {
    monitor = ["preferred, auto, auto"];
    workspace = [];
    windowrulev2 = [
      # only allow shadows for floating windows
      "noshadow, floating:0"
      # idle inhibit while watching videos
      "idleinhibit focus, class:^(mpv|.+exe)$"
      "idleinhibit fullscreen, class:.*"

      # make Firefox PiP window floating and sticky
      "float, title:^(Picture-in-Picture)$"
      "pin, title:^(Picture-in-Picture)$"

      "float, class:^(org.gnome.*)$"
      "float, class:^(pavucontrol)$"
      "float, class:(blueberry\.py)"

      # make pop-up file dialogs floating, centred, and pinned
      "float, title:(Open|Progress|Save File)"
      "center, title:(Open|Progress|Save File)"
      "pin, title:(Open|Progress|Save File)"
      "float, class:^(code)$"
      "center, class:^(code)$"
      "pin, class:^(code)$"

      # assign windows to workspaces
      # "workspace 1 silent, class:[Ff]irefox"
      # "workspace 2 silent, class:[Oo]bsidian"
      # "workspace 2 silent, class:google-chrome"
      # "workspace 3 silent, class:[Rr]ambox"
      # "workspace 4 silent, class:[Ss]ignal"
      # "workspace 5 silent, class:code-url-handler"

      # throw sharing indicators away
      "workspace special silent, title:^(Firefox — Sharing Indicator)$"
      "workspace special silent, title:^(.*is sharing (your screen|a window)\.)$"
    ];
  };
}
