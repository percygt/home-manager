require("smartcolumn").setup({
  colorcolumn = "100",
  { python = "120" },
})
require("trouble").setup()
require("twilight").setup()
require("colorizer").setup({
  user_default_options = {
    names = false,
    css_fn = true,
    mode = "virtualtext",
    sass = { enable = true },
  },
})
require("dressing").setup()
require("notify").setup({
  background_colour = "#000000",
  enabled = false,
})
require("noice").setup({
  -- add any options here
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
    },
  },
  cmdline = {
    view = "cmdline",
    format = {
      search_down = {
        view = "cmdline",
      },
      search_up = {
        view = "cmdline",
      },
    },
  },
  presets = {
    -- bottom_search = true, -- use a classic bottom cmdline for search
    -- command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = true, -- add a border to hover docs and signature help
  },
  routes = {
    {
      filter = {
        event = "msg_show",
        any = {
          { find = "%d+L, %d+B" },
          { find = "; after #%d+" },
          { find = "; before #%d+" },
          { find = "%d fewer lines" },
          { find = "%d more lines" },
        },
      },
      opts = { skip = true },
    },
  },
})
