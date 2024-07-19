return {
	"lukas-reineke/indent-blankline.nvim",
	event = "BufRead",
	main = "ibl",
	ops = {},
	config = function()
		local c = require("config.colorscheme")
		local hooks = require("ibl.hooks")

		hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
			vim.api.nvim_set_hl(0, "IndentYellow", { fg = c.base0A })
			vim.api.nvim_set_hl(0, "IndentBlack", { fg = c.base01 })
		end)

		require("ibl").setup({
			scope = {
				enabled = true,
				char = "▏",
				highlight = "IndentYellow",
			},
			indent = {
				char = "▏",
				smart_indent_cap = true,
				highlight = "IndentBlack",
			},
		})
	end,
}
