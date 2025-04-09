local config = require("config")
config.g()
config.opt()
config.keymap()
config.autocmd()

require("config.lazy")

vim.cmd.colorscheme("duskfox")

vim.filetype.add({
	pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
})
