require("oil").setup({
  columns = {
    "icon",
    "permissions",
    "size",
    "mtime",
  },
  delete_to_trash = true,
  float = {
    padding = 4,
    max_width = 150,
    max_height = 50,
    border = "rounded",
    win_options = {
      winblend = 10,
    },
  },
})
vim.keymap.set("n", "-", require("oil").toggle_float, { desc = "Open Parent Directory" })
