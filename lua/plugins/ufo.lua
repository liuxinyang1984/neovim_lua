-- Code folding (requires nvim-treesitter)

return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      "nvim-treesitter/nvim-treesitter",
    },
    lazy = false,
    config = function()
      require("ufo").setup()
    end,
  },
}
