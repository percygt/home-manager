return {
	"shellRaining/hlchunk.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local c = require("config.colorscheme")
		require("hlchunk").setup({
			chunk = {
				enable = true,
				priority = 15,
				style = {
					{ fg = c.base0A },
					{ fg = c.base08 },
				},
				use_treesitter = true,
				chars = {
					horizontal_line = "─",
					vertical_line = "│",
					left_top = "╭",
					left_bottom = "╰",
					right_arrow = "─",
				},
				textobject = "",
				max_file_size = 1024 * 1024,
				error_sign = true,
				-- animation related
				duration = 100,
				delay = 100,
			},
			indent = {
				enable = true,
				priority = 1,
				style = { c.base03 },
				use_treesitter = true,
				chars = { "│" },
				ahead_lines = 5,
				delay = 0,
			},
		})
	end,
}
