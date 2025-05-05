return {
	"lewis6991/gitsigns.nvim",
	opts = {
		on_attach = function(bufnr)
			local gitsigns = require("gitsigns")
			local utils = require("utils")

			local km_jump_next = {
				"n",
				"]c",
				function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gitsigns.nav_hunk("next")
					end
				end,
				{ desc = "Jump to next git [c]hange" },
			}

			local km_jump_prev = {
				"n",
				"[c",
				function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gitsigns.nav_hunk("prev")
					end
				end,
				{ desc = "Jump to previous git [c]hange" },
			}

			utils.set_keymaps({
				km_jump_next,
				km_jump_prev,
				{
					"v",
					"<leader>hs",
					function()
						gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end,
					{ desc = "git [s]tage hunk" },
				},
				{
					"v",
					"<leader>hr",
					function()
						gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end,
					{ desc = "git [r]eset hunk" },
				},
				{ "n", "<leader>hs", gitsigns.stage_hunk, { desc = "git [s]tage hunk" } },
				{ "n", "<leader>hr", gitsigns.reset_hunk, { desc = "git [r]eset hunk" } },
				{ "n", "<leader>hS", gitsigns.stage_buffer, { desc = "git [S]tage buffer" } },
				{ "n", "<leader>hR", gitsigns.reset_buffer, { desc = "git [R]eset buffer" } },
				{ "n", "<leader>hp", gitsigns.preview_hunk, { desc = "git [p]review hunk" } },
				{ "n", "<leader>hb", gitsigns.blame_line, { desc = "git [b]lame line" } },
				{ "n", "<leader>hd", gitsigns.diffthis, { desc = "git [d]iff against index" } },
				{
					"n",
					"<leader>hD",
					function()
						gitsigns.diffthis("@")
					end,
					{ desc = "git [D]iff against index" },
				},
				{
					"n",
					"<leader>tb",
					gitsigns.toggle_current_line_blame,
					{ desc = "[T]oggle git show [b]lame line" },
				},
				{
					"n",
					"<leader>tD",
					gitsigns.preview_hunk_inline,
					{ desc = "[T]oggle git show [D]eleted" },
				},
			}, { buffer = bufnr })
		end,
	},
}
