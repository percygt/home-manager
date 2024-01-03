{pkgs, ...}: let
  lsp_servers = pkgs.writeText "lsp-servers.json" (builtins.toJSON (import ./lsp-servers.nix {inherit pkgs;}));
  lsp_tools = pkgs.writeText "lsp-tools.json" (builtins.toJSON (import ./lsp-tools.nix {inherit pkgs;}));
  session-lens = pkgs.vimUtils.buildVimPlugin {
    pname = "session-lens";
    version = "2024-01-02";
    src = pkgs.fetchFromGitHub {
      owner = "rmagatti";
      repo = "session-lens";
      rev = "1b65d8e1bcd1836c5135cce118ba18d662a9dabd";
      hash = "sha256-ZSzUp3i3JZMwzN2f9nG5zS+qWq0qE2J+djEv042IMI0=";
    };
    meta.homepage = "https://github.com/rmagatti/session-lens";
  };
  vim-maximizer = pkgs.vimUtils.buildVimPlugin {
    pname = "vim-maximizer";
    version = "2024-01-01";
    src = pkgs.fetchFromGitHub {
      owner = "szw";
      repo = "vim-maximizer";
      rev = "2e54952fe91e140a2e69f35f22131219fcd9c5f1";
      hash = "sha256-+VPcMn4NuxLRpY1nXz7APaXlRQVZD3Y7SprB/hvNKww=";
    };
    meta.homepage = "https://github.com/szw/vim-maximizer";
  };
in {
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly.overrideAttrs (_: {CFLAGS = "-O3";});
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = false;
    extraLuaConfig = ''
      require("config.general")
      require("config.remaps")
      require("config.autocmds")
      require("config.tools.misc")
      require("config.ui.misc")
    '';

    plugins = with pkgs.stable-23-11.vimPlugins; [
      # Completion #-------------------------------------------------------------------------------------
      {
        plugin = nvim-cmp;
        type = "lua";
        config = ''require("config.lsp.completion")'';
      }
      cmp-path
      cmp-buffer
      cmp-nvim-lsp
      cmp-nvim-lua
      cmp_luasnip
      lspkind-nvim
      nvim-autopairs
      luasnip
      friendly-snippets
      # Language Server #-------------------------------------------------------------------------------------
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = ''require("config.lsp.lspconfig").setup_servers("${lsp_servers}")'';
      }
      # Formatting/Diagnostic/Code Action #------------------------------------------------------------------------------------
      {
        plugin = none-ls-nvim;
        type = "lua";
        config = ''require("config.lsp.nonels").setup_null_ls("${lsp_tools}")'';
      }
      # Syntax Highlighting/LSP based motions #-------------------------------------------------------------------------------------
      {
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config = ''require("config.lsp.treesitter")'';
      }
      nvim-treesitter-textobjects
      nvim-cursorline
      # Sessions #-------------------------------------------------------------------------------------
      {
        plugin = auto-session;
        type = "lua";
        config = ''require("config.tools.auto-session")'';
      }
      session-lens
      # Database #-------------------------------------------------------------------------------------
      {
        plugin = vim-dadbod;
        type = "lua";
        config = ''require("config.tools.database")'';
      }
      vim-dadbod-ui
      vim-dadbod-completion
      # Debug #-------------------------------------------------------------------------------------
      {
        plugin = nvim-dap;
        type = "lua";
        config = ''require("config.tools.debug")'';
      }
      nvim-dap-ui
      nvim-dap-go
      nvim-dap-python
      nvim-dap-virtual-text
      # Git #-------------------------------------------------------------------------------------
      {
        plugin = gitsigns-nvim;
        type = "lua";
        config = ''require("config.tools.git")'';
      }
      git-worktree-nvim
      # thePrimeagen #-------------------------------------------------------------------------------------
      {
        plugin = pkgs.vimPlugins.harpoon2;
        type = "lua";
        config = ''require("config.tools.harpoon2")'';
      }
      # Misc tools #-------------------------------------------------------------------------------------
      vim-tmux-navigator
      vim-maximizer
      comment-nvim
      vim-surround
      vim-repeat
      plenary-nvim
      # UI Enhancement #-------------------------------------------------------------------------------------
      {
        plugin = onedark-nvim;
        type = "lua";
        config = ''require("config.ui.theme")'';
      }
      {
        plugin = indent-blankline-nvim;
        type = "lua";
        config = ''require("config.ui.indent")'';
      }
      {
        plugin = lualine-nvim;
        type = "lua";
        config = ''require("config.ui.lualine")'';
      }
      {
        plugin = which-key-nvim;
        type = "lua";
        config = ''require("config.ui.which-key")'';
      }
      trouble-nvim
      dressing-nvim
      nvim-colorizer-lua
      smartcolumn-nvim
      twilight-nvim
      nvim-web-devicons
      nvim-notify
      fidget-nvim
      nui-nvim
      noice-nvim
      # Fuzzy Finder/File Browser #-------------------------------------------------------------------------------------
      {
        plugin = telescope-nvim;
        type = "lua";
        config = ''require("config.telescope")'';
      }
      telescope-file-browser-nvim
      telescope-fzf-native-nvim
      # File Browser #-------------------------------------------------------------------------------------
      {
        plugin = oil-nvim;
        type = "lua";
        config = ''require("config.oil")'';
      }
      # {
      #   plugin = nvim-tree-lua;
      #   type = "lua";
      #   config = ''require("config.tree")'';
      # }neovim
    ];
    extraPackages = with pkgs; [
      # Essentials
      nodePackages.npm
      nodePackages.neovim

      # Telescope dependencies
      ripgrep
      fd

      (python3.withPackages (ps:
        with ps; [
          setuptools # Required by pylama for some reason
          pylama
          black
          isort
          debugpy
        ]))
      nodePackages.pyright
      ruff
      # Lua
      lua-language-server
      stylua
      selene

      # Nix
      statix
      alejandra
      nil

      # C, C++
      clang-tools
      cppcheck

      # Shell scripting
      shfmt
      shellcheck
      shellharden

      # JavaScript
      prettierd
      eslint_d
      nodePackages.prettier
      nodePackages.typescript-language-server

      # Go
      go
      gopls
      golangci-lint
      delve

      # Additional
      deno
      nodePackages.bash-language-server
      nodePackages.yaml-language-server
      nodePackages.dockerfile-language-server-nodejs
      nodePackages.vscode-langservers-extracted
      nodePackages.markdownlint-cli
      taplo-cli
      codespell
      gitlint
      terraform-ls
      actionlint
    ];
  };
  xdg.configFile."nvim/lua/config/colors.lua" = {
    text = ''
      return {

      }

    '';
  };
  xdg.configFile.nvim = {
    recursive = true;
    source = ../../common/nvim;
  };
}
