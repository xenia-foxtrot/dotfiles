---@module "lazy"
---@module "snacks"
---@type LazySpec
return {
	{
		"folke/snacks.nvim",
		---@type snacks.Config
		opts = {
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
