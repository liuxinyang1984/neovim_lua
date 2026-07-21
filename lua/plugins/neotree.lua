-- File tree (replaces coc-explorer)

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = "Neotree",
    opts = {
      close_if_last_window = false,
      filesystem = {
        follow_current_file = {
          enabled = true,
          leave_dirs_open = true,
        },
        window = {
          position = "left",
          mappings = {
            ["h"] = "close_node",
            ["l"] = "open",
          },
        },
      },
    },
  },
}
