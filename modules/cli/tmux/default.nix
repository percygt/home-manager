{
  pkgs,
  config,
  lib,
  flakeDirectory,
  ...
}:
let
  c = config.modules.theme.colors.withHashtag;
in
{
  options.modules.cli.tmux.enable = lib.mkEnableOption "Enable tmux";
  config = lib.mkIf config.modules.cli.tmux.enable {
    systemd.user.services.tmux = {
      Unit = {
        Description = "tmux server";
      };
      # creates the [Service] section
      # based on the emacs systemd service
      # does not source uses a login shell so does not load ~/.zshrc in case this is needed
      # just add -l(E.g bash -cl "...").
      Service = {
        Type = "forking";
        Restart = "always";
        ExecStart = "${pkgs.bash}/bin/bash -c 'source ${config.system.build.setEnvironment} ; exec ${config.programs.tmux.package}/bin/tmux start-server'";
        ExecStop = "${pkgs.tmux}/bin/tmux kill-server";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
    programs.tmux = {
      enable = true;
      baseIndex = 1;
      shell = "${pkgs.fish}/bin/fish";
      keyMode = "vi";
      sensibleOnTop = false;
      terminal = "tmux-256color";
      aggressiveResize = true;
      mouse = true;
      customPaneNavigationAndResize = true;
      disableConfirmationPrompt = true;
      prefix = "C-a";
      escapeTime = 0;
      historyLimit = 1000000;
      inherit
        (import ./config.nix {
          inherit config;
          pkgs = pkgs.stash;
        })
        extraConfig
        ;
    };
    home = {
      shellAliases.home = "tmux new -As home";
      # dependencies
      packages = with pkgs; [
        wl-clipboard
        moreutils
        fzf
        gitmux
      ];
    };
    xdg.configFile =
      let
        moduleTmux = "${flakeDirectory}/modules/cli/tmux";
      in
      {
        "tmux/gitmux.yaml".source = config.lib.file.mkOutOfStoreSymlink "${moduleTmux}/gitmux.yaml";
        "tmux/beforePlugins.conf".source = config.lib.file.mkOutOfStoreSymlink "${moduleTmux}/beforePlugins.conf";
        "tmux/afterPlugins.conf".source = config.lib.file.mkOutOfStoreSymlink "${moduleTmux}/afterPlugins.conf";
        "tmux/.tmux-env".text = ''
          TMUX_TMPDIR="${config.home.sessionVariables.TMUX_TMPDIR}"
        '';
        "tmux/variables.conf".text = ''
          set -g @BORDER '${c.base02}'
          set -g @BORDER_ACTIVE '${c.base0A}'
          set -g @FG_PREFIX '${c.base14}'
          set -g @FG_PREFIX_ACTIVE '${c.base13}'
          set -g @FG_WINDOW_ACTIVE '${c.base16}'
          set -g @FG_WINDOW_PREV '${c.base08}'
          set -g @FG_STATUS '${c.base05}'
        '';
      };
  };
}
