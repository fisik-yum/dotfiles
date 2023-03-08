--STARTUP
require("core.keymaps")
require("core.plugins")
require("core.plugin_config")





--Theming and other stuff

vim.cmd([[set number]])
vim.cmd([[set clipboard=unnamedplus]])

--Stuff to run
vim.cmd([[NvimTreeOpen]])
--vim.cmd([[ToggleTerm]])
