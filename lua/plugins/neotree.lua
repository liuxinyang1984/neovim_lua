-- File tree (replaces coc-explorer)

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        "s1n7ax/nvim-window-picker",
        version = "2.*",
        config = function()
          require("window-picker").setup({
            filter_rules = {
              autoselect_one = true,
              include_current_win = false,
              bo = {
                filetype = { "neo-tree", "neo-tree-popup", "notify", "qf", "help" },
                buftype = { "terminal", "nofile" },
              },
            },
          })
        end,
      },
    },
    cmd = "Neotree",
    opts = {
      close_if_last_window = false,
      event_handlers = {
        {
          event = "file_opened",
          handler = function()
            require("neo-tree.command").execute({ action = "close" })
          end,
        },
      },
      filesystem = {
        follow_current_file = {
          enabled = true,
          leave_dirs_open = true,
        },
        window = {
          position = "left",
          mappings = {
            ["h"] = "close_node",
            ["l"] = "open_with_window_picker",
          },
        },
      },
    },
  },
}
