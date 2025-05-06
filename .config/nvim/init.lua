vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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
    'nvim-lualine/lualine.nvim',
    'nvim-tree/nvim-tree.lua',
    'navarasu/onedark.nvim',
    'akinsho/toggleterm.nvim',

    'neovim/nvim-lspconfig',
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'hrsh7th/nvim-cmp', -- use lua 5.1 to prevent crashes
    'hrsh7th/cmp-nvim-lsp',
    'L3MON4D3/LuaSnip',

    'mg979/vim-visual-multi',

    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
})

--TREESITTER
require 'nvim-treesitter.configs'.setup {

    highlight = {
        enable = true,
        disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,

        additional_vim_regex_highlighting = false,
    },
}

--MASON
require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {},
    handlers = {
        -- this first function is the "default handler"
        -- it applies to every language server without a custom handler
        function(server_name)
            require('lspconfig')[server_name].setup({})
        end,

        -- this is the "custom handler" for `lua_ls`
        lua_ls = function()
            require('lspconfig').lua_ls.setup({
                settings = {
                    Lua = {
                        runtime = {
                            version = 'LuaJIT',
                        },
                        diagnostics = {
                            globals = { 'vim' },
                        },
                        workspace = {
                            library = { vim.env.VIMRUNTIME },
                        },
                    },
                },
            })
        end,
    },
})

-- LSP
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        local opts = { buffer = event.buf }

        vim.keymap.set('n', '<leader>k', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
        vim.keymap.set('n', '<Leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>')
        vim.keymap.set('n', '<Leader>f', '<cmd>lua vim.lsp.buf.format()<CR>')
        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
        vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
        vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
        vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
        vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
        vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
        vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
        vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
        vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
    end
})

local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {},
    handlers = {
        function(server_name)
            require('lspconfig')[server_name].setup({
                capabilities = lsp_capabilities,
            })
        end,
    },
})

local cmp = require('cmp')
cmp.setup({
    preselect = cmp.PreselectMode.None,
    completion = { completeopt = "menu,menuone,noselect" },
    sources = {
        { name = 'nvim_lsp' },
    },
    mapping = cmp.mapping.preset.insert({
        -- Enter key confirms completion item
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),

        -- Ctrl + space triggers completion menu
        ['<C-Space>'] = cmp.mapping.complete(),
    }),
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
})
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

--Keymaps
vim.g.mapleader = " "
vim.keymap.set({ "n" }, "<Leader><tab>", "<Cmd>tabnext<CR>")
vim.keymap.set({ "n" }, "<Leader>n<tab>", "<cmd>tabnew<CR>")
vim.keymap.set({ "n" }, "<Leader>c<tab>", "<cmd>tabclose<CR>")
vim.keymap.set({ "n" }, "<Leader>l", "<Cmd>NvimTreeToggle<CR>")
vim.keymap.set({ "n" }, "<Leader>tt", "<cmd>ToggleTerm<CR>")
--Preferences
vim.opt.termguicolors = true
vim.cmd([[colorscheme onedark]])
vim.cmd([[set number]])
vim.cmd([[set clipboard=unnamedplus]])
vim.cmd([[set tabstop=4]])
vim.cmd([[set shiftwidth=4]])
vim.cmd([[set expandtab]])
vim.cmd([[set mouse=]])
vim.cmd([[set colorcolumn=80]])
vim.cmd([[set relativenumber]])
--vim.cmd([[highlight ColorColumn ctermbg=0 guibg=lavender]])

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = false,
    float = true,
})
vim.opt.signcolumn = 'yes'
