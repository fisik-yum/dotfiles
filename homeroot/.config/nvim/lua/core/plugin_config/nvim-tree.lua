vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup({
respect_buf_cwd = false,
update_focused_file = {
enable = true,
update_root = true,
},
respect_buf_cwd=true,
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
	  show={
	     file=false,
	  },
        },
        special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md","go.mod","go.sum" },
        symlink_destination = true,
      },
})

local nvim_tree_events = require('nvim-tree.events')
local bufferline_api = require('bufferline.api')

local function get_tree_size()
  return require'nvim-tree.view'.View.width
end

nvim_tree_events.subscribe('TreeOpen', function()
  bufferline_api.set_offset(get_tree_size())
end)

nvim_tree_events.subscribe('Resize', function()
  bufferline_api.set_offset(get_tree_size())
end)

nvim_tree_events.subscribe('TreeClose', function()
  bufferline_api.set_offset(0)
end)
