---@alias KeymapTable {mode: string | string[], lhs: string, rhs: string | function, opts: table}
---@alias KeymapTuple [string | string[], string, string | function, table]
---@alias Keymap KeymapTable | KeymapTuple


local function unpack_named(t, ...)
	local rv = {}
	for i, v in ipairs{...} do
		table.insert(rv, t[v] or t[i])
	end
	return unpack(rv)
end

return {
	--- Unpacks the provided table by the keys provided.
	--- If the keys do not exist, then it will use the index of that key as an index into the table.
	unpack_named = unpacked_named,

	---@param keymaps Keymap
	set_keymaps = function(keymaps)
		for _, km in ipairs(keymaps) do
			vim.keymap.set(unpack_named(km, "mode", "lhs", "rhs", "opts"))
		end
	end,
	
	--- Polyfil between neovim 0.11 (nightly) and 0.10
	---@param client vim.lsp.Client
	---@param method vim.lsp.protocol.Method
	---@param bufnr? integer some lsp support methods only in specific files
	---@return boolean
	client_supports_method = function(client, method, bufnr)
		if vim.fn.has "nvim-0.11" == 1 then
			return client:supports_method(method, bufnr)
		else
			return client.supports_method(method, { bufnr = bufnr })
		end
	end,
	
}
