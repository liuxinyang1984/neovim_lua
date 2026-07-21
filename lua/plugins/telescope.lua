-- Fuzzy finder (replaces Leaderf)

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = "Telescope",
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        defaults = {
          prompt_prefix = "  ",
          selection_caret = "  ",
          path_display = { "truncate" },
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              width = 0.9,
              height = 0.9,
              preview_width = 0.55,
              prompt_position = "top",
            },
          },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-n>"] = false,
              ["<C-p>"] = false,
              ["<C-t>"] = actions.select_tab,
              ["<Esc>"] = actions.close,
            },
            n = {
              ["j"] = actions.move_selection_next,
              ["k"] = actions.move_selection_previous,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              t = actions.select_tab,
            },
          },
        },
        pickers = {
          colorscheme = {
            enable_preview = true,
          },
        },
      })
    end,
  },
}
