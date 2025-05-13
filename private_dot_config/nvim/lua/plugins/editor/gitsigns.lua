return {
	"lewis6991/gitsigns.nvim",
	lazy = false,
	config = function()
		require("gitsigns").setup({
			signcolumn = true,
			auto_attach = true,
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")
				local utils = require("utils")

				local specs = {
					{
						"]c",
						function()
							if vim.wo.diff then
								vim.cmd.normal({ "]c", bang = true })
							else
								gitsigns.nav_hunk("next")
							end
						end,
						desc = "Jump to next git [c]hange",
					},
					{
						"[c",
						function()
							if vim.wo.diff then
								vim.cmd.normal({ "[c", bang = true })
							else
								gitsigns.nav_hunk("prev")
							end
						end,
						desc = "Jump to previous git [c]hange",
					},

					{
						"<leader>hs",
						function()
							gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
						end,
						mode = "v",
						desc = "git [s]tage hunk",
					},
					{
						"<leader>hr",
						function()
							gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
						end,
						mode = "v",
						desc = "git [r]eset hunk",
					},
					{ "<leader>hs", gitsigns.stage_hunk, desc = "git [s]tage hunk" },
					{ "<leader>hr", gitsigns.reset_hunk, desc = "git [r]eset hunk" },
					{ "<leader>hS", gitsigns.stage_buffer, desc = "git [S]tage buffer" },
					{ "<leader>hR", gitsigns.reset_buffer, desc = "git [R]eset buffer" },
					{ "<leader>hp", gitsigns.preview_hunk, desc = "git [p]review hunk" },
					{ "<leader>hb", gitsigns.blame_line, desc = "git [b]lame line" },
					{ "<leader>hd", gitsigns.diffthis, desc = "git [d]iff against index" },
					{
						"<leader>hD",
						function()
							gitsigns.diffthis("@")
						end,
						desc = "git [D]iff against index",
					},
					{
						"<leader>tb",
						gitsigns.toggle_current_line_blame,
						desc = "[T]oggle git show [b]lame line",
					},
					{
						"<leader>tD",
						gitsigns.preview_hunk_inline,
						desc = "[T]oggle git show [D]eleted",
					},
				}

				specs = vim.tbl_map(function(t)
					return vim.tbl_extend("force", { buffer = bufnr }, t)
				end, specs)

				utils.set_keymaps(specs)
			end,
		})
	end,
}
