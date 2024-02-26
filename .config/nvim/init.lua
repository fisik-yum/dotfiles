vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1


--Pluginload

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    'wbthomason/packer.nvim',
    'nvim-lualine/lualine.nvim',
    'nvim-tree/nvim-tree.lua',
    'ellisonleao/gruvbox.nvim',
    'akinsho/toggleterm.nvim',

    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',
        dependencies = {
            -- LSP Support
            'neovim/nvim-lspconfig',             -- Required
            'williamboman/mason.nvim',           -- Optional
            'williamboman/mason-lspconfig.nvim', -- Optional
            -- Autocompletion
            'hrsh7th/nvim-cmp',                  -- Required
            'hrsh7th/cmp-nvim-lsp',              -- Required
            'hrsh7th/cmp-buffer',                -- Optional
            'hrsh7th/cmp-path',                  -- Optional
            'saadparwaiz1/cmp_luasnip',          -- Optional
            'hrsh7th/cmp-nvim-lua',              -- Optional

            -- Snippets
            'L3MON4D3/LuaSnip',             -- Required
            'rafamadriz/friendly-snippets', -- Optional
        },
    },


    'lewis6991/gitsigns.nvim',
    'mg979/vim-visual-multi',
    'm4xshen/autoclose.nvim',

})

--COMPLETE
local cmp = require('cmp')
cmp.setup({
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' }
    })
})

--GITSIGNS
require('gitsigns').setup()

--LSP (autofmt)
local lsp = require('lsp-zero')
lsp.preset({
    name = 'minimal',
    set_lsp_keymaps = true,
    manage_nvim_cmp = true,
    suggest_lsp_servers = false,
})
lsp.setup()

lsp.on_attach(function(client, bufnr)
    lsp.default_keymaps({ buffer = bufnr })
    lsp.buffer_autoformat()
end)

require('lualine').setup {
    options = {
        icons_enabled = false,
        section_separators = { left = '', right = '' }
    }
}

--NVIM-TREE
require("nvim-tree").setup({
    update_focused_file = {
        enable = true,
        update_root = true,
    },
    respect_buf_cwd = true,
    renderer = {
        icons = {
            glyphs = {
                default = "FL",
                symlink = "SYM",
                bookmark = "BK",
                modified = "M",
                folder = {
                    arrow_closed = ">",
                    arrow_open = "^",
                    default = "FLR",
                    open = "FLR(O)",
                    empty = "FLR(E)",
                    empty_open = "FLR(O,E)",
                    symlink = "SYM",
                    symlink_open = "SYM(O)",
                },
                git = {
                    unstaged = "X",
                    staged = "V",
                    unmerged = "UM",
                    renamed = "RN",
                    untracked = "UT",
                    deleted = "DEL",
                    ignored = "IGN",
                },
            },
            show = {
                file = false,
            },
        },
        special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md", "go.mod", "go.sum", "build.sh" },
        symlink_destination = true,
    },
})

--TOGGLETERM
require("toggleterm").setup()

--nvim-autopairs
require("autoclose").setup({
    options = {
        disabled_filetypes = { "text", "markdown" },
    },
})

--Keymaps
vim.g.mapleader = " "
vim.keymap.set({ "n" }, "<tab>", "<Cmd>tabnext<CR>")
vim.keymap.set({ "n", "v", "i" }, "<C-k>", "<cmd>lua vim.lsp.buf.hover()<CR>")
vim.keymap.set({ "n" }, "<Leader>l", "<Cmd>NvimTreeToggle<CR>")
vim.keymap.set({ "n" }, "<Leader>tt", "<cmd>ToggleTerm<CR>")
vim.keymap.set({ "n" }, "<Leader>tn", "<cmd>tabnew<CR>")
vim.keymap.set({ "n" }, "<Leader>tq", "<cmd>tabclose<CR>")
vim.keymap.set({ "n" }, "<Leader>f", "<cmd>LspZeroFormat<CR>")

--Preferences
vim.opt.termguicolors = true
vim.cmd([[colorscheme gruvbox]])
vim.cmd([[set number]])
vim.cmd([[set clipboard=unnamedplus]])
vim.cmd([[set tabstop=4]])
vim.cmd([[set shiftwidth=4]])
vim.cmd([[set expandtab]])

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = false,
    float = true,
})
