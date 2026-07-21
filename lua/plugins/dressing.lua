-- UI enhancements for vim.ui.select / input / confirm (<leader>cn, LSP rename, etc.)

return {
  {
    "stevearc/dressing.nvim",
    lazy = false,
    opts = {
      select = {
        backend = { "builtin", "nui" },
        builtin = {
          win_options = {
            cursorline = true,
            cursorlineopt = "both",
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,CursorLineNr:CursorLineNr",
          },
        },
      },
    },
  },
}
