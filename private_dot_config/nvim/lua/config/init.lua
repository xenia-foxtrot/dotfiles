-- This module defines basic neovim config. Global variables, vim options, etc.
-- This should be loaded before plugins are.

-- Configures nvim global variables. This gets set to `vim.g` in config.lua
local globals = {
	-- Set <space> as leader
	mapleader = " ",
	maplocalleader = " ",
}

-- Configures nvim options. This gets set to `vim.opt` in config.lua
local options = {
	autoindent = true, -- Indent is copied from the previous line
	breakindent = true, -- Enable break indent (wrapped lines will continue to be visually indented)
	cursorline = true, -- Hilight the text line of the cursor
	expandtab = false, -- We use tabs as tab width can be customized
	ignorecase = true,
	list = true, -- Display whitespace characters.
	listchars = {
		eol = "",
		lead = "·",
		trail = "·",
		tab = "▎ ",
	},
	mouse = "a", -- Enable mouse mode, for when I don't have rsi
	number = true, -- Enable line number
	relativenumber = true, -- Use relative line numbers
	scrolloff = 10, -- Minimum number of screen lines to keep above and below the cursor
	shiftwidth = 8, -- Width of spaces is 8
	showmode = false, -- Disable showmode as we put it in the status line
	signcolumn = "yes", -- Keep the sign column on
	smartcase = true, -- Case-insensitive searching unless \C or one or more capital letters in the search term
	smarttab = true, -- Tab in insert mode goes to the next indent, but only if the cursor is at the beginning of a line
	softtabstop = 0, -- Disable softtabstop
	splitbelow = true, -- TODO: I'm not sure what these options do and :help isn't telling me
	splitright = true, -- Configure splits
	tabstop = 8, -- Tabs are 8 cells wide, default
	termguicolors = true,
	undofile = true, -- Save undo history
	updatetime = 2000, -- Decrease update time (ms of inactivity that passes before a swap file is written to disk)
}

---@type KeymapSpec[]
local keymaps = {
	-- Clear highlights on search when pressing <Esc> in normal mode
	{ "<Esc>", "<cmd>nohlsearch<CR>" },

	-- Open the diagnostic quickfix list
	{ "<leader>xq", vim.diagnostic.setloclist, desc = "Open diagnostic quickfix list" },

	-- Disable arrow keys is normal mode
	-- { "<left>", "<cmd>echo 'Trainer: Use h to move! (Remember, this is the leftmost key)'<CR>" },
	-- { "<right>", "<cmd>echo 'Trainer: Use l to move! (Remember, this is the rightmost key)'<CR>" },
	-- { "<up>", "<cmd>echo 'Trainer: Use k to move!'<CR>" },
	-- { "<down>", "<cmd>echo 'Trainer: Use j to move! (Remember, this looks like a down arrow)'<CR>" },

	-- Make split navigation easier by using CTRL+<hjkl> to switch between windows
	{ "<C-h>", "<C-w><C-h>", desc = "Move focus to left window" },
	{ "<C-l>", "<C-w><C-l>", desc = "Move focus to right window" },
	{ "<C-j>", "<C-w><C-j>", desc = "Move focus to down window" },
	{ "<C-k>", "<C-w><C-k>", desc = "Move focus to up window" },

	-- Navigate tab pages
	-- Tabs contain windows, windows show a view onto a buffer. Buffers are global.
	{ "tj", ":tabprev<CR>" },
	{ "tk", ":tabnext<CR>" },
	{ "tn", ":tabnew<CR>" },
	{ "to", ":tabo<CR>" },

	-- Use (shift-)enter to insert newline without going into insert mode
	{ "<S-Enter>", "O<Esc>" },
	{ "<CR>", "o<Esc>" },
}

local table = require("std.table")
local utils = require("utils")

return {
	g = function()
		table.merge(vim.g, globals, ":nometa")
	end,
	opt = function()
		table.merge(vim.opt, options, ":nometa")

		-- Sync clipboard between the OS and Neovim.
		-- Scheduled after UiEnter because it can increase startup-time.
		vim.schedule(function()
			vim.opt.clipboard = "unnamedplus"
		end)
	end,
	keymap = function()
		utils.set_keymaps(keymaps)
	end,
	autocmd = function()
		vim.api.nvim_create_autocmd("TextYankPost", {
			desc = "Highlight when yanking text",
			group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
			callback = function()
				vim.highlight.on_yank()
			end,
		})
	end,
}
