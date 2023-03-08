--STARTUP
require("core.keymaps")
require("core.plugins")
require("core.plugin_config")

--Theming and other stuff
vim.cmd([[set number]])
vim.cmd([[set clipboard=unnamedplus]])

--Commands
vim.api.nvim_create_user_command("Nvimreload",function()
  vim.cmd([[source ~/.config/nvim/init.lua]])
end,{})

--Stuff to run
vim.cmd([[NvimTreeOpen]])

