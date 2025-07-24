--- @module "lazy"
-- Plugins in this module define language support

return {
	{
		'MeanderingProgrammer/render-markdown.nvim',
		dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
	},
	{
		'mrcjkb/rustaceanvim',
		version = '^6', -- Recommended
		lazy = false, -- This plugin is already lazy
	},
}
