---@module "lazy"
--- Plugins in this file should always be lazy-loaded. After lazy.nvim loads we configure the LSP autocmd

---@type LazySpec
return {
	-- Configures the Lua LSP for the neovim config
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				path = "${3rd}/luv/library",
				words = { "vim%.uv" },
			},
		},
	},
	-- Provides configurations for lsp servers so we don't have to define them all in lsp
	"neovim/nvim-lspconfig",
	{
		"SmiteshP/nvim-navbuddy",
		lazy = true,
		dependencies = {
			"SmiteshP/nvim-navic",
			"MunifTanjim/nui.nvim",
		},
	},
	-- Status updates for LSP
	-- It's pretty terminal eye candy :3
	{ "j-hui/fidget.nvim", opts = {} },
	-- Automatically install LSP servers
	{
		"williamboman/mason.nvim",
		dependencies = {
			{
				"WhoIsSethDaniel/mason-tool-installer.nvim",
				opts = {
					"lua_ls",
					"stylua",
					"rust-analyzer",
				},
			},
		},
		opts = {},
	},
	-- Super fast autocomplete
	{
		"saghen/blink.cmp",
		-- Snippets
		dependencies = { "rafamadriz/friendly-snippets" },
		version = "1.*",
		build = "cargo build --release",
		opts = {
			keymap = {
				-- <C-Space> =  Show
				-- <C-e> = hide
				-- <C-y> select_and_accept
				-- <Up> select_prev
				-- <Down> select_next
				-- <C-p> select_prev
				-- <C-n> select_next
				-- <C-b> scroll_documentation_up
				-- <C-f> scroll_documentation_down
				-- Tab snippet_forward
				-- S-Tab snippet_backward
				-- C-k show_signature
				preset = "default",
			},
			sources = {
				default = { "lazydev", "lsp", "path", "snippets", "buffer" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
				},
			},
		},
	},
}
