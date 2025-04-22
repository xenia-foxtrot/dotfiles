---@module "lazy"

local function find_overseer_win()
	for _, winid in ipairs(vim.api.nvim_list_wins()) do
		local bufnr = vim.api.nvim_win_get_buf(winid)
		if vim.bo[bufnr].filetype == "OverseerList" then
			return winid, bufnr
		end
	end

	return nil, nil
end

---@type LazySpec
return {
	"stevearc/overseer.nvim",
	opts = {},
	keys = {
		{
			"<leader>to",
			desc = "[T]oggle [O]verseer",
			-- Create our own toggle function so we can control the buffer on the window
			function()
				local overseer = require("overseer")
				overseer.toggle()

				local winid = find_overseer_win()
				if winid ~= nil then
					vim.wo[winid].winfixbuf = true
				end
			end,
		},
		{
			"<leader>R",
			":OverseerRun<CR>",
			desc = "[R]un Command",
		},
	},
}
