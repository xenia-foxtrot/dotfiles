--harper:ignore
---@class KeymapSpecOpts: vim.keymap.set.Opts
---@field desc? string
---@field noremap? boolean
---@field remap? boolean

---@class KeymapSpec: KeymapSpecOpts
---@field [1] string lhs
---@field [2]? string | function rhs
---@field mode? string | string[]

local M = {}

local opts_skip = { mode = true, ft = true, rhs = true, lhs = true }
local keymap_opts_select = {
	desc = true,
	buffer = true,
	remap = true,
	noremap = true,
	nowait = true,
	silent = true,
	script = true,
	expr = true,
	unique = true,
}

---Extracts two tables from the spec:
--- 1. A table of keymap opts which has the same type as `vim.keymap.setOpts`
--- 2. A table of function opts, which are the remainder of the table.
---@param spec KeymapSpecOpts
---@return vim.keymap.set.Opts, FuncOpts
function M.opts(spec)
	---@type vim.keymap.set.Opts
	local keymap_opts = {}

	---@class FuncOpts
	---@field positional any[]
	---@field named table
	local func_opts = {
		positional = {},
		named = {},
	}

	function func_opts:is_empty()
		return #self.positional == 0 and vim.tbl_count(self.named) == 0
	end

	for k, _ in pairs(spec) do
		if type(k) == "number" then
			if k > 2 then
				table.insert(func_opts.positional, spec[k])
			end
		elseif keymap_opts_select[k] then
			keymap_opts[k] = spec[k]
		elseif not opts_skip[k] then
			func_opts.named[k] = spec[k]
		end
	end
	return keymap_opts, func_opts
end

---Parses a `KeymapSpec` and returns the 4 parameters the can be passed to `vim.keymap.set`
---If rhs is a function and there are additional numerical or named entries in the spec, this function will attempt to call `rhs` with those entries as parameters.
---If there are additional named entries, then they are collected into a table and passed as the first parameter to the function.
---Each numerical entry is passed in order as additional parameters.
---Returns mode, lhs, rhs, and opts
---@param spec KeymapSpec
---@return string | string[], string, string | function, vim.keymap.set.Opts?
function M.parse(spec)
	local keymap_opts, func_opts = M.opts(spec)

	local rhs = nil
	if type(spec[2]) == "function" and not func_opts:is_empty() then
		rhs = function()
			if vim.tbl_count(func_opts.named) > 0 then
				return spec[2](func_opts.named, unpack(func_opts.positional))
			else
				return spec[2](unpack(func_opts.positional))
			end
		end
	else
		rhs = spec[2] or ""
	end

	return (spec.mode or "n"), spec[1], rhs, keymap_opts
end

---@param specs KeymapSpec[]
function M.set_keymaps(specs)
	for _, spec in ipairs(specs) do
		vim.keymap.set(M.parse(spec))
	end
end

return M
