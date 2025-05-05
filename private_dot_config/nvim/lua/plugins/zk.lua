return {
	"zk-org/zk-nvim",
	lazy = false,
	config = function()
		require("zk").setup({
			picker = "fzf_lua",
			lsp = {
				config = {
					cmd = { "zk", "lsp" },
					name = "zk",
				},
				auto_attach = {
					enabled = true,
					filetypes = { "markdown" },
				},
			},
		})
	end,
	keys = {
		{
			"<leader>zn",
			"<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>",
			desc = "Create a new note.",
			noremap = true,
			silent = false,
		},
		{
			"<leader>zo",
			"<Cmd>ZkNotes { sort = { 'modified' } }<CR>",
			desc = "Open notes.",
			noremap = true,
			silent = false,
		},
		{
			"<leader>zt",
			"<Cmd>ZkTags<CR>",
			desc = "Open notes with the selected tags.",
			noremap = true,
			silent = false,
		},
		{
			"<leader>zf",
			"<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>",
			desc = "Search for notes",
			noremap = true,
			silent = false,
		},
		{
			"<leader>zf",
			":'<,'>ZkMatch<CR>",
			desc = "Search notes with the selection.",
			mode = "v",
			noremap = true,
			silent = false,
		},
		{ "<leader>zb", "<Cmd>ZkBacklinks<CR>", desc = "Open backlinks", noremap = true, silent = false },
	},
}
