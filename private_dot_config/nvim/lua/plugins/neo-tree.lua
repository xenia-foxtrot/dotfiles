return {
	"nvim-neo-tree/neo-tree.nvim",
	version = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
		{ "3rd/image.nvim", opts = {} },
	},
	keys = {
		{ "<leader>tf", ":Neotree toggle reveal<CR>", desc = "NeoTree [T]oggle [F]iles", silent = true },
		{ "<leader>tb", ":Neotree toggle show buffers right<CR>", desc = "NeoTree [T]oggle [B]uffers" },
	},
	lazy = false,
	---@module "neo-tree"
	---@type neotree.Config?
	opts = {},
}
