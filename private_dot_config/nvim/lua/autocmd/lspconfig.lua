---@module "snacks"

local utils = require("utils")

---@param direction -1 | 1
---@param severity vim.diagnostic.Severity?
local function diagnostic_goto(direction, severity)
	severity = severity and vim.diagnostic.severity[severity] or nil
	return function()
		local count = vim.v.count1
		vim.diagnostic.jump({ count = count * direction, severity = severity })
		print("Moved " .. (direction > 0 and "forward" or "backward") .. " " .. count .. " diagnostics.")
	end
end

local function set_lsp_keymaps(event)
	local fzflua = require("fzf-lua")

	---@type KeymapSpec[]
	local specs = {
		-- Jump to the definition of the word underneath the cursor
		{
			"gd",
			fzflua.lsp_definitions,
			desc = "Goto Definition (LSP)",
			jump1 = true,
		},
		-- Find references for the word under the cursor
		{
			"gr",
			fzflua.lsp_references,
			desc = "Goto References (LSP)",
			jump1 = true,
		},
		-- This is not goto definition this is goto declaration
		{ "gD", vim.lsp.buf.declaration, desc = "Goto DECLARATION (LSP)" },
		-- Jump to implementation of the word under the cursor
		{
			"gI",
			fzflua.lsp_implementations,
			desc = "Goto Implementation (LSP)",
		},
		-- Jump to the type of the word under the cursor
		{
			"gy",
			fzflua.lsp_typedefs,
			desc = "Goto Type Definition (LSP)",
			jump1 = true,
		},
		{ "K", vim.lsp.buf.hover, desc = "Hover (LSP)" },
		{ "gK", vim.lsp.buf.signature_help, desc = "Signature Help (LSP)" },
		{ "<leader>cd", vim.diagnostic.open_float, desc = "Line Diagnostic" },
		{ "]d", diagnostic_goto(1), desc = "Next Diagnostic" },
		{ "[d", diagnostic_goto(-1), desc = "Previous Diagnostic" },
		{ "[e", diagnostic_goto(1, "ERROR"), desc = "Next Error" },
		{ "]e", diagnostic_goto(-1, "ERROR"), desc = "Previous Error" },
		{ "[w", diagnostic_goto(1, "WARN"), desc = "Next Warning" },
		{ "]w", diagnostic_goto(-1, "WARN"), desc = "Previous Warning" },
		-- Fuzzy find all symbols in the current document
		{
			"<leader>sd",
			fzflua.lsp_document_symbols,
			desc = "Document Symbols (LSP)",
		},
		-- Fuzzy find all symbols in the entire workspace
		{
			"<leader>sw",
			fzflua.lsp_live_workspace_symbols,
			desc = "[W]orkspace [S]ymbols (LSP)",
		},
		-- Rename the symbol under the cursor
		{ "<leader>rn", vim.lsp.buf.rename, desc = "[R]e[n]ame (LSP)" },
		-- Execute a code action, usually the cursor needs to be on top of something actionable
		{
			"<leader>ca",
			vim.lsp.buf.code_action,
			mode = { "n", "x" },
			desc = "[C]ode [A]ction (LSP)",
		},
		{
			"<leader>cA",
			function()
				vim.lsp.buf.code_action({
					apply = true,
					context = {
						only = { "source" },
						diagnostics = {},
					},
				})
			end,
			desc = "Source Action (LSP)",
		},
		{
			"]]",
			Snacks.words.jump,
			vim.v.count1,
			desc = "Next Reference",
		},
		{
			"[[",
			Snacks.words.jump,
			-vim.v.count1,
			desc = "Prev Reference",
		},
		{
			"<a-n>",
			Snacks.words.jump,
			vim.v.count1,
			desc = "Next Reference",
		},
		{
			"<a-p>",
			Snacks.words.jump,
			-vim.v.count1,
			desc = "Prev Reference",
		},
	}

	specs = vim.tbl_map(function(t)
		return vim.tbl_extend("force", { buffer = event.buf }, t)
	end, specs)
	utils.set_keymaps(specs)
end

---@param client vim.lsp.Client?
---@param event vim.api.keyset.create_autocmd.callback_args
---@param method string
---@return boolean
local function client_supports_method(client, event, method)
	return client ~= nil and client:supports_method(method, event.buf)
end

--- Autocmd that runs when an Lsp attaches.
--- An LSP should pretty much never attach until lazy finishes loading, so everything here will run after lazy does.
vim.api.nvim_create_autocmd("LspAttach", {
	desc = "Configures the LSP keybindings on attach.",
	group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
	callback = function(event)
		set_lsp_keymaps(event)

		local client = vim.lsp.get_client_by_id(event.data.client_id)

		-- Highlight references of the word under the cursor if the LSP supports it.
		if client_supports_method(client, event, vim.lsp.protocol.Methods.textDocument_documentHighlight) then
			local highlight_augroup_name = "kickstart-lsp-highlight"
			local highlight_augroup = vim.api.nvim_create_augroup(highlight_augroup_name, { clear = false })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})

			-- Cleanup
			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({
						group = highlight_augroup_name,
						buffer = event2.buf,
					})
				end,
			})
		end

		-- Keymap to toggle inlay hints if the language server supports it
		if client_supports_method(client, event, vim.lsp.protocol.Methods.textDocument_inlayHint) then
			local function toggle_inlay()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
			end
			utils.set_keymaps({
				{ "<leader>th", toggle_inlay, desc = "[T]oggle Inlay [H]ints" },
			})
		end

		-- Configure navic
		if client_supports_method(client, event, vim.lsp.protocol.Methods.textDocument_documentSymbol) then
			local navic = require("nvim-navic")
			local navbuddy = require("nvim-navbuddy")

			navic.attach(client, event.buf)
			navbuddy.attach(client, event.buf)
			utils.set_keymaps({
				{ "<leader>n", navbuddy.open, desc = "Open Navbuddy" },
			})
		end
	end,
})
