-- Syntax highlighting, indent, and parser management (nvim-treesitter v1 rewrite)

local parsers = {
  "php",
  "go",
  "python",
  "javascript",
  "typescript",
  "vue",
  "html",
  "css",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup()
      require("nvim-treesitter").install(parsers)
    end,
  },
}
