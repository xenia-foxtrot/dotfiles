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

	---@param keymaps Keymap
	set_keymaps = function(keymaps)
		for _, km in ipairs(keymaps) do
			vim.keymap.set(unpack_named(km, "mode", "lhs", "rhs", "opts"))
		end
	end,
}
