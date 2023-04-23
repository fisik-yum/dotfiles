--STARTUP
require("core.keymaps")
require("core.plugins")
require("core.plugin_config")

--Theming and other stuff
vim.cmd([[set number]])
vim.cmd([[set clipboard=unnamedplus]])
vim.cmd([[set tabstop=4]])
vim.cmd([[set shiftwidth=4]])
vim.cmd([[set expandtab]])

--Commands
vim.api.nvim_create_user_command("Nvimreload",function()
  vim.cmd([[source ~/.config/nvim/init.lua]])
end,{})

