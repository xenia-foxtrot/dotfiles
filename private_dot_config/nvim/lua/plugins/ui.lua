return {
	{
		"akinsho/bufferline.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		opts = {
			options = {
				diagnostics = "nvim_lsp",
				numbers = "buffer_id",
			},
		},
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			local palette = require("nightfox.palette.terafox").palette

			local empty = require("lualine.component"):extend()
			function empty:draw(default_highlight)
				self.status = ""
				self.applied_separator = ""
				self:apply_highlights(default_highlight)
				self:apply_section_separators()
				return self.status
			end

			-- Put proper separators and gaps between components in sections
			local function process_sections(sections)
				for name, section in pairs(sections) do
					local left = name:sub(9, 10) < "x"
					for pos = 1, name ~= "lualine_z" and #section or #section - 1 do
						table.insert(
							section,
							pos * 2,
							{ empty, color = { fg = palette.white.base, bg = palette.bg1 } }
						)
					end
					for id, comp in ipairs(section) do
						if type(comp) ~= "table" then
							comp = { comp }
							section[id] = comp
						end
						comp.separator = left and { right = "" } or { left = "" }
					end
				end
				return sections
			end

			require("lualine").setup({
				options = {
					icons_enabled = true,
					component_separators = "",
					section_separators = { left = "", right = "" },
					globalstatus = true,
				},
				sections = process_sections({
					lualine_a = { "mode" },
					lualine_b = {
						"branch",
						"diff",
						{
							"diagnostics",
							source = { "nvim_lsp" },
							sections = { "error", "warn" },
						},
						{
							"%w",
							cond = function()
								return vim.wo.previewwindow
							end,
						},
					},
					lualine_c = {
						{
							"filename",
							file_status = true,
							path = 4,
							color = { bg = palette.bg3 },
						},
					},
					lualine_x = {},
					lualine_y = { "overseer" },
					lualine_z = {
						{
							"%l:%c",
							color = { bg = palette.white.bright, fg = palette.black.bright },
						},
						{ "%p%%/%L", color = { bg = palette.pink.bright } },
						{ "filetype", color = { bg = palette.cyan.bright } },
					},
				}),
			})
		end,
	},
}
