---@module "which-key"
---@type LazySpec
return {
	-- Shows pending keybinds with a nice popup
	{
		"folke/which-key.nvim",
		event = "VimEnter",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer local keymaps",
			},
		},
		---@type wk.Opts
		opts = {
			delay = 0,
			icons = {
				-- I always use nerd font, so set mappings to true and use default
				mappings = true,
				keys = {},
			},
			-- Configure group descriptions
			-- We'll use these groups in other keybinds
			spec = {
				{ "g", group = "[G]oto" },
				{ "<leader>c", group = "[c]ode", mode = { "n", "x" } },
				{ "<leader>g", group = "[g]it" },
				{ "<leader>s", group = "[s]earch" },
				{ "<leader>t", group = "[t]oggle" },
				{ "<leader>h", group = "Git [h]unk", mode = { "n", "v" } },
				{ "<leader>x", group = "diagnostics/quickfi[x]" },
			},
		},
	},
}
