return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		event = "VimEnter",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable "make" == 1
				end,
			},
			"nvim-telescope/telescope-ui-select.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		-- Need to load extensions in a particular order, so we have to manage the setup call ourselves
		config = function()
			-- Setup telescope config, help is in :help telescope.setup()
			require("telescope").setup {
				-- Extension config
				extensions = {
					["ui-select"] =  {
						require("telescope.themes").get_dropdown()
					},
					fzf = {
						fuzzy = true
					},
				},
			}

			-- Enable extensions
			require("telescope").load_extension "fzf"
			require("telescope").load_extension "ui-select"

			-- Telescope doesn't have any default keybinds
			-- As specified in the which-key config, we'll use "s" to group search commands
			local builtin = require("telescope.builtin")
			
			require("utils").set_keymaps {
				{"n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" }},
				{"n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" }},
				{"n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" }},
				{"n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" }},
				{"n", "<leader>sw", builtin.grep_string, { desc = "[S]earch curren [W]ord" }},
				{"n", "<leader>sg", builtin.grep_string, { desc = "[S]earch by [G]rep" }},
				{"n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" }},
				{"n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" }},
				{"n", "<leader>s.", builtin.oldfiles, { desc = "[S]earch Recent Files"}},
				{"n", "<leader>sb", builtin.buffers, { desc = "[S]earch Existing [B]uffers"}},
				{"n", "<leader>sp", function() builtin.planets{ show_pluto = true, show_moon = true } end, { desc = "[S][P]ace"}}, -- Easter egg
				{"n", "<leader>/", function()
					builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
						winblend = 10,
						previewer = false,
					})
				end, { desc = "[/] Fuzzily search in current buffer" }},
				{"n", "<leader>s/", function()
					builtin.live_grep {
						grep_open_files = true,
						prompt_title = 'Live Grep in Open Files',
					}
				end, { desc = "[S]earch [/] in Open Files" }},
			}
		end,
	},
}
