-- Miscellanous plugins

return {
	-- Themes
	{ "EdenEast/nightfox.nvim" },
	{
		"sainnhe/everforest",
		config = function()
			vim.g.everforest_enable_italic = true
		end,
	},

	-- Treesitter to better support syntax highlighting, navigating, and editing code
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		main = "nvim-treesitter.configs", -- Sets the module lazy `requires` and passes opts too
		opts = {
			ensure_installed = {
				"bash",
				"fish",
				"diff",
				"html",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"query",
				"vim",
				"vimdoc",
			},
			auto_install = true, -- Autoinstall languages that aren't installed

			-- Treesitter modules are disabled by default, there are 4 built-in ones: highlight, incremental_selection, indentation, folding
			highlight = {
				enable = true,
			},
			indent = { enable = true },
		},
	},

	-- Show indent lines
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		--@module "ibl"
		--@module ibl.config
		opts = {},
	},

	-- Easy commenting in normal & visual mode
	{ "numToStr/Comment.nvim", lazy = false },

	-- Table editor
	{ "dhruvasagar/vim-table-mode" },
}
