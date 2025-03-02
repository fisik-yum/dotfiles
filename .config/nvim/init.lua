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
    'nvim-lualine/lualine.nvim',
    'nvim-tree/nvim-tree.lua',
    'navarasu/onedark.nvim',
    'akinsho/toggleterm.nvim',

    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v4.x',
        dependencies = {
            -- LSP Support
            'neovim/nvim-lspconfig',             -- Required
            'williamboman/mason.nvim',           -- Optional
            'williamboman/mason-lspconfig.nvim', -- Optional
            -- Autocompletion
            'hrsh7th/cmp-nvim-lsp',              -- Required
            'hrsh7th/cmp-buffer',                -- Optional
            'saadparwaiz1/cmp_luasnip',          -- Optional
            {
                "hrsh7th/nvim-cmp",
                commit = "b356f2c",
                pin = true,
            },
            -- Snippets
            'L3MON4D3/LuaSnip',             -- Required
            'rafamadriz/friendly-snippets', -- Optional
        },
    },
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },


    'lewis6991/gitsigns.nvim',
    'mg979/vim-visual-multi',
    'm4xshen/autoclose.nvim',
})

--GITSIGNS
require('gitsigns').setup()

--LSP (autofmt)
--local lsp = require('lsp-zero')

-- Reserve a space in the gutter
-- This will avoid an annoying layout shift in the screen
vim.opt.signcolumn = 'yes'

-- Add borders to floating windows
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover,
    { border = 'single' }
)
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    { border = 'single' }
)

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
    'force',
    lspconfig_defaults.capabilities,
    require('cmp_nvim_lsp').default_capabilities()
)

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(event)
        local opts = { buffer = event.buf }

        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
        vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaratimn()<cr>', opts)
        vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
        vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
        vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
        vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    end,
})



--NVIM-CMP
local cmp = require('cmp')

require('luasnip.loaders.from_vscode').lazy_load()

vim.opt.completeopt = { 'menu', 'menuone', 'noinsert' }

cmp.setup({
    enabled = function()
        -- disable completion in comments
        local context = require 'cmp.config.context'
        -- keep command mode completion enabled when cursor is in a comment
        if vim.api.nvim_get_mode().mode == 'c' then
            return true
        else
            return not context.in_treesitter_capture("comment")
                and not context.in_syntax_group("Comment")
        end
    end,
    preselect = cmp.PreselectMode.None,
    completion = {
        completeopt = 'menu,menuone,noinsert'
    },
    window = {
        documentation = cmp.config.window.bordered(),
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip', keyword_length = 2 },
    },
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    formatting = {
        fields = { 'abbr', 'menu', 'kind' },
        format = function(entry, item)
            local n = entry.source.name
            if n == 'nvim_lsp' then
                item.menu = '[LSP]'
            else
                item.menu = string.format('[%s]', n)
            end
            return item
        end,
    },
    mapping = cmp.mapping.preset.insert({
        -- confirm completion item
        ['<CR>'] = cmp.mapping.confirm({ select = true }),

        -- scroll documentation window
        ['<C-f>'] = cmp.mapping.scroll_docs(5),
        ['<C-u>'] = cmp.mapping.scroll_docs(-5),

        -- toggle completion menu
        ['<C-Space>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.abort()
            else
                cmp.complete()
            end
        end),

        -- tab complete
        ['<Tab>'] = cmp.mapping(function(fallback)
            local col = vim.fn.col('.') - 1

            if cmp.visible() then
                cmp.select_next_item({ behavior = 'select' })
            elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
                fallback()
            else
                cmp.complete()
            end
        end, { 'i', 's' }),

        -- go to previous item
        ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = 'select' }),

        -- navigate to next snippet placeholder
        ['<C-d>'] = cmp.mapping(function(fallback)
            local luasnip = require('luasnip')

            if luasnip.jumpable(1) then
                luasnip.jump(1)
            else
                fallback()
            end
        end, { 'i', 's' }),

        -- navigate to the previous snippet placeholder
        ['<C-b>'] = cmp.mapping(function(fallback)
            local luasnip = require('luasnip')

            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
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
vim.keymap.set({ "n" }, "<Leader><tab>", "<Cmd>tabnext<CR>")
vim.keymap.set({ "n" }, "<Leader>n<tab>", "<cmd>tabnew<CR>")
vim.keymap.set({ "n" }, "<Leader>c<tab>", "<cmd>tabclose<CR>")
vim.keymap.set({ "n" }, "<Leader>k", "<cmd>lua vim.lsp.buf.hover()<CR>")
vim.keymap.set({ "n" }, "<Leader>l", "<Cmd>NvimTreeToggle<CR>")
vim.keymap.set({ "n" }, "<Leader>f", "<cmd>LspZeroFormat<CR>")
vim.keymap.set({ "n" }, "<Leader>tt", "<cmd>ToggleTerm<CR>")
vim.keymap.set({ 'n' }, '<Leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>')
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
