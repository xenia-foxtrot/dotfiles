---@module "lazy"
---@module "neorg"

---@type LazySpec
return {
	"nvim-neorg/neorg",
	lazy = false,
	version = "*",
	dependencies = {
		{
			"kev-cao/neorg-fzflua",
			dependencies = {
				"ibhagwan/fzf-lua",
				"nvim-lua/plenary.nvim",
			},
		},
		-- Search engine
		{ "benlubas/neorg-se" },
		-- Integration with blink.mp
		-- TODO: I think I'd like to try coq_nvim
		"benlubas/neorg-interim-ls",
	},
	opts = {
		load = {
			["external.integrations.fzf-lua"] = {},
			["external.interim-ls"] = {
				config = {
					completion_provider = {
						enable = true,
					},
				},
			},
		},
		["core.completion"] = {
			config = {
				engine = {
					module_name = "external.lsp-completion",
				},
			},
		},
		["core.defaults"] = {},
		["core.dirman"] = {
			config = {
				workspaces = {
					zettlekasten = "~/Documents/zk-norg/",
				},
			},
		},
		["core.concealer"] = {},
	},
}
