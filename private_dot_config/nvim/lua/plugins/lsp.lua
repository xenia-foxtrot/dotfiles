return {
	-- Configures the Lua LSP for the neovim config
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				path = "${3rd}/luv/library",
				words = { "vim%.uv" },
			},
		},
	},

	-- Install Neovim LSP Client Configurations
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Mason allows us to automatically install LSPs and related tools
			-- Mason must be loaded before it's dependents so we have to set it up here
			{ "williamboman/mason.nvim", opts = {} },
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			-- Status updates for LSP
			-- It's pretty terminal eye candy :3
			{ "j-hui/fidget.nvim", opts = {} },

			-- Better completion menu than built-in, faster than nvim-cmp
			"saghen/blink.cmp",
		},
		config = function()
			-- This will run whenever an LSP attaches to a buffer.
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local telescopes = require("telescope.builtin")
					local utils = require("utils")

					---Custom syntax for setting LSP keymaps
					---@param maps [string | string[], string, function, string][]
					local function set_lsp_keymaps(maps)
						local fun = require("fun")
						utils.set_keymaps(fun.iter(maps)
							:map(function(km)
								km[4] = { buffer = event.buf, desc = "LSP: " .. km[4] }
								return km
							end)
							:totable())
					end

					set_lsp_keymaps({
						-- Jump to the definition of the word underneath the cursor
						{ "n", "gd", telescopes.lsp_definitions, "[G]oto [D]efinition" },
						-- This is not goto definition this is goto declaration
						{ "n", "gD", vim.lsp.buf.declaration, "[G]oto [D]ECLARATION" },
						-- Find references for the word under the cursor
						{ "n", "gr", telescopes.lsp_references, "[G]oto [R]eferences" },
						-- Jump to implementation of the word under the cursor
						{
							"n",
							"gI",
							telescopes.lsp_implementations,
							"[G]oto [I]mplementation",
						},
						-- Jump to the type of the word under the cursor
						{
							"n",
							"<leader>D",
							telescopes.lsp_type_definitions,
							"Type [D]efinition",
						},
						-- Fuzzy find all symbols in the current document
						{
							"n",
							"<leader>ds",
							telescopes.lsp_document_symbols,
							"[D]ocument [S]ymbols",
						},
						-- Fuzzy find all symbols in the entire workspace
						{
							"n",
							"<leader>ws",
							telescopes.lsp_dynamic_workspace_symbols,
							"[W]orkspace [S]ymbols",
						},
						-- Rename the symbol under the cursor
						{ "n", "<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame" },
						-- Execute a code action, usually the cursor needs to be on top of something actionable
						{
							{ "n", "x" },
							"<leader>ca",
							vim.lsp.buf.code_action,
							"[C]ode [A]ction",
						},
					})

					-- Highlight references of the word under the cursor if the LSP supports it.
					local highlight_augroup_name = "kickstart-lsp-highlight"
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if
						client
						and client:supports_method(
							vim.lsp.protocol.Methods.textDocument_documentHighlight,
							event.buf
						)
					then
						local highlight_augroup = vim.api.nvim_create_augroup(
							highlight_augroup_name,
							{ clear = false }
						)
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
							group = vim.api.nvim_create_augroup(
								"kickstart-lsp-detach",
								{ clear = true }
							),
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
					if
						client
						and client:supports_method(
							vim.lsp.protocol.Methods.textDocument_inlayHint,
							event.buf
						)
					then
						local function toggle_inlay()
							vim.lsp.inlay_hint.enable(
								not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
							)
						end
						set_lsp_keymaps({
							{ "n", "<leader>th", toggle_inlay, "[T]oggle Inlay [H]ints" },
						})
					end
				end,
			})

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

			local blink = require("blink.cmp")
			local lspconfig = require("lspconfig")
			lspconfig["pylsp"].setup({
				capabilities = blink.get_lsp_capabilities(),
			})

			-- Setup our capabilities
			-- Returns a function that can be passed to the `handlers` table in the mason-lspconfig setup
			local function make_server_handler(server_settings, fn)
				if type(server_settings) == "function" then
					fn, server_settings = server_settings, nil
				end
				local server = server_settings or { capabilities = {} }

				return function(server_name)
					if fn ~= nil then
						server = fn(server)
					end
					-- Unlike cmp-nvim, get_lsp_capabilities calls `vim.lsp.protocol.make_client_capabilities` for us and merges
					server.capabilities = blink.get_lsp_capabilities(server.capabilities)
					lspconfig[server_name].setup(server)
				end
			end

			-- Ensure servers and other tools are installed
			require("mason-tool-installer").setup({
				"lua_ls",
				"stylua",
				"rust-analyzer",
			})

			require("mason-lspconfig").setup({
				ensure_installed = {},
				automatic_installation = false,
				handlers = {
					-- Generic server handler
					make_server_handler(),
					["lua_ls"] = make_server_handler({
						settings = {
							Lua = {
								completion = {
									callSnippet = "Replace",
								},
							},
						},
					}),
				},
			})
		end,
	},

	-- Autoformatting
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				-- Disable "format_on_save lsp_fallback" for language that don't have a standardized coding style
				local disable_filetypes = { c = true, cpp = true }
				if disable_filetypes[vim.bo[bufnr].filetype] then
					return nil
				else
					return {
						timeout_ms = 500,
						lsp_format = "fallback",
					}
				end
			end,
			formatters_by_ft = {
				lua = { "stylua" },
			},
		},
	},

	-- Autocompletion
	{
		"saghen/blink.cmp",
		-- Snippets
		dependencies = { "rafamadriz/friendly-snippets" },
		version = "1.*",
		build = "cargo build --release",
		opts = {
			keymap = {
				-- <C-Space> =  Show
				-- <C-e> = hide
				-- <C-y> select_and_accept
				-- <Up> select_prev
				-- <Down> select_next
				-- <C-p> select_prev
				-- <C-n> select_next
				-- <C-b> scroll_documentation_up
				-- <C-f> scroll_documentation_down
				-- Tab snippet_forward
				-- S-Tab snippet_backward
				-- C-k show_signature
				preset = "default",
			},
			sources = {
				default = { "lazydev", "lsp", "path", "snippets", "buffer" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
				},
			},
		},
	},
}
