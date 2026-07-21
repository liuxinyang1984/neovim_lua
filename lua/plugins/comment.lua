-- Toggle comments (replaces NERDCommenter)

return {
  {
    "terrortylor/nvim-comment",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim_comment").setup({
        create_mappings = false,
      })
    end,
  },
}
