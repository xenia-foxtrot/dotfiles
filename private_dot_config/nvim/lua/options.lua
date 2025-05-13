-- Set <space> as leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.autoindent = true -- Indent is copied from the previous line
vim.o.breakindent = true -- Enable break indent (wrapped lines will continue to be visually indented)
vim.o.cursorline = true -- Highlight the text line of the cursor
vim.o.expandtab = false -- We use tabs as tab width can be customized
vim.o.ignorecase = true
vim.o.list = true -- Display whitespace characters.
vim.opt.listchars = {
	eol = "",
	lead = "·",
	trail = "·",
	tab = "▎ ",
}
vim.o.mouse = "a" -- Enable mouse mode, for when I don't have rsi
vim.o.number = true -- Enable line number
vim.o.relativenumber = true -- Use relative line numbers
vim.o.scrolloff = 10 -- Minimum number of screen lines to keep above and below the cursor
vim.o.shiftwidth = 8 -- Width of spaces is 8
vim.o.showmode = false-- Disable showmode as we put it in the status line
vim.o.signcolumn = "yes" -- Keep the sign column on
vim.o.smartcase = true -- Case-insensitive searching unless \C or one or more capital letters in the search term
vim.o.smarttab = true -- Tab in insert mode goes to the next indent, but only if the cursor is at the beginning of a line
vim.o.softtabstop = 0 -- Disable softtabstop
vim.o.splitbelow = true -- TODO: I'm not sure what these options do and :help isn't telling me
vim.o.splitright = true -- Configure splits
vim.o.tabstop = 8 -- Tabs are 8 cells wide, default
vim.o.termguicolors = true
vim.o.undofile = true -- Save undo history
vim.o.updatetime = 2000 -- Decrease update time (ms of inactivity that passes before a swap file is written to disk)

-- Sync clipboard between the OS and Neovim.
-- Scheduled after UiEnter because it can increase startup-time.
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

-- Diagnostic config, see :help vim.diagnostic.Opts
vim.diagnostic.config({
	severity_sort = true,
	float = { boarder = "rounded", source = "if_many" },
	underline = { severity = vim.diagnostic.severity.ERROR },
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.INFO] = "󰋽 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
	},
	virtual_text = {
		source = "if_many",
		spacing = 2,
		format = function(diagnostic)
			local diagnostic_message = {
				[vim.diagnostic.severity.ERROR] = diagnostic.message,
				[vim.diagnostic.severity.WARN] = diagnostic.message,
				[vim.diagnostic.severity.INFO] = diagnostic.message,
				[vim.diagnostic.severity.HINT] = diagnostic.message,
			}
			return diagnostic_message[diagnostic.severity]
		end,
	},
})
