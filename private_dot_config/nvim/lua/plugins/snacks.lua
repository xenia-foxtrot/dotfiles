---@module "lazy"
---@module "snacks"
---@type LazySpec
return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			words = {
				enabled = true,
			},
			lazygit = {
				enabled = true,
			},
		},
		keys = {
			{
				"<leader>gg",
				function()
					Snacks.lazygit()
				end,
				desc = "[G]it [G]ud (Opens lazygit)",
			},
		},
	},
}
