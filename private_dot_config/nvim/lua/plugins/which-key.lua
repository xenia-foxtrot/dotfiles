return {
	-- Shows pending keybinds with a nice popup
	{
		"folke/which-key.nvim",
		event = "VimEnter",
		dependencies = { "nvim-tree/nvim-web-devicons" },
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
				{ "<leader>c", group = "[C]ode", mode = { "n", "x" } },
				{ "<leader>d", group = "[D]ocument" },
				{ "<leader>r", group = "[R]ename" },
				{ "<leader>s", group = "[S]earch" },
				{ "<leader>w", group = "[W]orkspace" },
				{ "<leader>t", group = "[T]oggle" },
				{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" }},
			},
		},
	}
}
