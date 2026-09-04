-- Colorscheme: gruvbox (Lua port, treesitter/LSP friendly)

return {
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("gruvbox").setup()
      vim.cmd.colorscheme("gruvbox")

      -- Telescope: stronger selection (gruvbox links TelescopeSelection → faint CursorLine)
      vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = "#504945", bold = true })
      vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { fg = "#fabd2f", bold = true })
    end,
  },
}
