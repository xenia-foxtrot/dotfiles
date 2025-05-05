---@type LazySpec
return {
	"gennaro-tedesco/nvim-possession",
	dependencies = {
		"ibhagwan/fzf-lua",
	},
	opts = {
		autoswitch = {
			enable = true,
		},
	},
	keys = {
		{
			"<leader>ql",
			function()
				require("nvim-possession").list()
			end,
			desc = "List Sessions",
		},
		{
			"<leader>qn",
			function()
				require("nvim-possession").new()
			end,
			desc = "New Session",
		},
		{
			"<leader>qu",
			function()
				require("nvim-possession").update()
			end,
			desc = "Update current Session",
		},
		{
			"<leader>qd",
			function()
				require("nvim-possession").delete()
			end,
			desc = "Delete selected session",
		},
	},
}
