{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (config._general) flakeDirectory;
  moduleNvim = "${flakeDirectory}/modules/editor/neovim";
in
{
  imports = [ ./packages.nix ];
  options.modules.editor.neovim.enable = lib.mkEnableOption "Enable neovim home";
  config = lib.mkIf config.modules.editor.neovim.enable {
    home.shellAliases.v = "nvim";
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      vimdiffAlias = true;
      vimAlias = true;
      viAlias = true;
      withNodeJs = true;
      withPython3 = true;
      withRuby = false;
      extraWrapperArgs = [
        "--prefix"
        "LD_LIBRARY_PATH"
        ":"
        "${lib.makeLibraryPath [
          pkgs.libgit2
          pkgs.gpgme
        ]}"
      ];

      extraLuaConfig =
        # lua
        ''
          vim.g.gcc_bin_path = '${lib.getExe pkgs.gcc}'
          vim.g.sqlite_clib_path = '${pkgs.sqlite.out}/lib/libsqlite3.so'
          require("config.options")
          require("config.remaps")
          require("config.autocmds")
          require("config.lazy")
        '';
      plugins = [
        pkgs.vimPlugins.lazy-nvim # All other plugins are managed by lazy-nvim
      ];
    };
    home = {
      activation.linkNvim = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
        [ -e "${config.xdg.configHome}/nvim/lua/config" ] && cp -rs ${moduleNvim}/lua/config/. ${config.xdg.configHome}/nvim/lua/config/
      '';
    };
    xdg = {
      configFile = {
        "nvim/lazy-lock.json".source = config.lib.file.mkOutOfStoreSymlink "${moduleNvim}/lazy-lock.json";
        "nvim/neoconf.json".source = config.lib.file.mkOutOfStoreSymlink "${moduleNvim}/neoconf.json";
        "nvim/spell".source = config.lib.file.mkOutOfStoreSymlink "${moduleNvim}/spell";
        "nvim/ftdetect".source = config.lib.file.mkOutOfStoreSymlink "${moduleNvim}/ftdetect";
        "nvim/lua/plugins".source = config.lib.file.mkOutOfStoreSymlink "${moduleNvim}/lua/plugins";
        "nvim/lua/utils".source = config.lib.file.mkOutOfStoreSymlink "${moduleNvim}/lua/utils";
        "nvim/lua/config/colorscheme.lua" =
          let
            colorschemeLua =
              pkgs.runCommand "colorscheme.lua" { }
                #bash
                ''
                  ${pkgs.yq-go}/bin/yq -o=lua 'del(.scheme) |
                      del(.author) |
                      del(.name) |
                      del(.slug) |
                      del(.system) |
                      del(.variant) |
                      .[] |= "#" + .' ${config.modules.theme.colors} > $out
                '';
          in
          {
            text = builtins.readFile colorschemeLua;
          };
      };
      desktopEntries = {
        neovim = {
          name = "Neovim";
          genericName = "Text Editor";
          exec =
            let
              app = pkgs.writeShellScript "neovim-terminal" ''
                # Killing foot from sway results in non-zero exit code which triggers
                # xdg-mime to use next valid entry, so we must always exit successfully
                if [ "$SWAYSOCK" ]; then
                  foot -- nvim "$1" || true
                else
                  gnome-terminal -- nvim "$1" || true
                fi
              '';
            in
            "${app} %U";
          terminal = false;
          categories = [
            "Utility"
            "TextEditor"
          ];
          mimeType = [
            "text/markdown"
            "text/plain"
            "text/javascript"
          ];
        };
      };
    };
  };
}
