---@alias KeymapTable {mode: string | string[], lhs: string, rhs: string | function, opts: table}
---@alias KeymapTuple [string | string[], string, string | function, table]
---@alias Keymap KeymapTable | KeymapTuple

local function unpack_named(t, ...)
	local rv = {}
	for i, v in ipairs({ ... }) do
		table.insert(rv, t[v] or t[i])
	end
	return unpack(rv)
end

return {
	--- Unpacks the provided table by the keys provided.
	--- If the keys do not exist, then it will use the index of that key as an index into the table.
	unpack_named = unpacked_named,

	---@param keymaps Keymap[]
	---@param opts vim.keymap.set.Opts
	set_keymaps = function(keymaps, opts)
		for _, km in ipairs(keymaps) do
			local mode, lhs, rhs, km_opts = unpack_named(km, "mode", "lhs", "rhs", "opts")
			km_opts = vim.tbl_extend("force", opts or {}, km_opts or {})
			vim.keymap.set(mode, lhs, rhs, km_opts)
		end
	end,
}
