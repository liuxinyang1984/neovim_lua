-- Markdown pipe table editing

return {
  {
    "dhruvasagar/vim-table-mode",
    ft = { "markdown" },
    config = function()
      pcall(vim.keymap.del, "n", "<Plug>(table-mode-tableize)")
    end,
  },
}
