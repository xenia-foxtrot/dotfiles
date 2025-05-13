--- This module configures keymaps
local utils = require("utils")

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
utils.set_keymaps(keymaps)
