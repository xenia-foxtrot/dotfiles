---@type LazySpec
return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {},
	keys = {
		{ "<leader>,", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<CR>", desc = "Switch Buffer" },
		{ "<leader>/", "<cmd>FzfLua live_grep<CR>", desc = "Live Grep" },
		{ "<leader>fg", "<cmd>FzfLua git_files<CR>", desc = "Find Files (git-files)" },
		{ "<leader>fr", "<cmd>FzfLua oldfiles<CR>", desc = "Recent" },
		{ "<leader>gc", "<cmd>FzfLua git_commits<CR>", desc = "Commits" },
		{ "<leader>s", "<cmd>FzfLua registers<CR>", desc = "Registers" },
		{ "<leader>sb", "<cmd>FzfLua buffers<CR>", desc = "Buffers" },
		{ "<leader>sc", "<cmd>FzfLua command_history<CR>", desc = "Command History" },
		{ "<leader>sC", "<cmd>FzfLua commands<CR>", desc = "Commands" },
		{ "<leader>xd", "<cmd>FzfLua diagnostics_document<CR>", desc = "Document Diagnostics" },
		{ "<leader>xD", "<cmd>FzfLua diagnostics_workspace<CR>", desc = "Workspace Diagnostics" },
		{ "<leader>sR", "<cmd>FzfLua resume<CR>", desc = "Resume" },
		{ "<leader>sk", "<cmd>FzfLua keymaps<CR>", desc = "Keymaps" },
		{ "<leader>sq", "<cmd>FzfLua quickfix<CR>", desc = "Quickfix list" },
	},
}
