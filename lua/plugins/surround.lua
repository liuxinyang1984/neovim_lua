-- Surround selections (replaces vim-surround; uses plugin default keymaps)

return {
  {
    "kylechui/nvim-surround",
    version = "^4.0.0",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-surround").setup()
    end,
  },
}
