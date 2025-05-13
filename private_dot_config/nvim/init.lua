require("options")
require("keymaps")

require("lazy-bootstrap")
require("autocmd")

vim.cmd.colorscheme("duskfox")

vim.filetype.add({
	pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
})

vim.lsp.enable("lua_ls")
