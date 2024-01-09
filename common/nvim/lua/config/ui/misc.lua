require("smartcolumn").setup()
require("trouble").setup()
require("twilight").setup()
require("colorizer").setup()
require("dressing").setup()
require("nvim-web-devicons").set_icon({
  astro = { icon = "󱓞", color = "#FF4900", name = "Astro" },
})
require("notify").setup({
  background_colour = "#000000",
  enabled = false,
})
require("noice").setup({
  -- add any options here
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
vim.api.nvim_set_keymap("n", "<leader>nn", ":NoiceDismiss<CR>", { noremap = true })
