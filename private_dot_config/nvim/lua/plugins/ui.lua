---@module "lazy"
---@module "snacks"
---@module "bufferline"

---@type LazySpec
return {
	{
		"akinsho/bufferline.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		opts = {
			---@type bufferline.Options
			options = {
				-- Prevent closing buffers from messing up window layout
				close_command = function(n)
					Snacks.bufdelete(n)
				end,
				right_mouse_command = function(n)
					Snacks.bufdelete(n)
				end,
				always_show_bufferline = false,

				diagnostics = "nvim_lsp",
				numbers = "buffer_id",
			},
		},
		keys = {
			{ "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Pin Buffer" },
			{ "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Close Right Buffer" },
			{ "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Close Left Buffer" },
			{ "[b", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev Buffer" },
			{ "]b", "<Cmd>BufferLineCycleNext<CR>", desc = "Next Buffer" },
			{ "[B", "<Cmd>BufferLineMovePrev<CR>", desc = "Move Buffer Left" },
			{ "]B", "<Cmd>BufferLineMoveNext<CR>", desc = "Move Buffer Right" },
		},
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			local palette = require("nightfox.palette.duskfox").palette

			local empty = require("lualine.component"):extend()
			function empty:draw(default_highlight)
				self.status = ""
				self.applied_separator = ""
				self:apply_highlights(default_highlight)
				self:apply_section_separators()
				return self.status
			end

			-- Put proper separators and gaps between components in sections
			--
			local function process_sections(sections)
				for name, section in pairs(sections) do
					local left = name:sub(9, 10) < "x"
					for pos = 1, name ~= "lualine_z" and #section or #section - 1 do
						table.insert(
							section,
							pos * 2,
							{ empty, color = { fg = palette.white.base, bg = palette.bg0 } }
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
						{
							"filename",
							file_status = true,
							path = 4,
						},
					},
					lualine_c = {
						{ "branch", color = { bg = palette.bg3 } },
						{ "diff", color = { bg = palette.bg3 } },
						{
							"diagnostics",
							source = { "nvim_lsp" },
							sections = { "error", "warn" },
							color = { bg = palette.bg3 },
						},
						{
							"%w",
							cond = function()
								return vim.wo.previewwindow
							end,
							color = { bg = palette.bg3 },
						},
					},
					lualine_x = {},
					lualine_y = {
						"overseer",
						{
							require("nvim-possession").status,
							cond = function()
								return require("nvim-possession").status() ~= nil
							end,
						},
					},
					lualine_z = {
						{
							"%l:%c",
							color = { bg = palette.white.bright, fg = palette.black.bright },
						},
						{
							function()
								return " " .. os.date("%R")
							end,
							color = { bg = palette.pink.bright },
						},
						{ "filetype", color = { bg = palette.cyan.bright } },
					},
				}),
			})
		end,
	},

	-- Shows location in the top right corner
	{
		"b0o/incline.nvim",
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons",
		},
		event = "VeryLazy",
		config = function()
			local helpers = require("incline.helpers")
			local navic = require("nvim-navic")
			local devicons = require("nvim-web-devicons")

			require("incline").setup({
				render = function(props)
					local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
					if filename == "" then
						filename = "[No Nome]"
					end
					local ft_icon, ft_color = devicons.get_icon_color(filename)
					local modified = vim.bo[props.buf].modified
					local res = {
						ft_icon and {
							" ",
							ft_icon,
							" ",
							guibg = ft_color,
							guifg = helpers.contrast_color(ft_color),
						} or "",
						" ",
						{ filename, gui = modified and "bold,italic" or "bold" },
						guibg = "#44406e",
					}
					if props.focused then
						for _, item in ipairs(navic.get_data(props.buf) or {}) do
							table.insert(res, {
								{ " > ", group = "NavicSeparator" },
								{ item.icon, group = "NavicIcons" .. item.type },
								{ item.name, group = "NavicText" },
							})
						end
					end
					table.insert(res, " ")
					return res
				end,
			})
		end,
	},
}
