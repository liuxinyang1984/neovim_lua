-- In-buffer markdown rendering (F7 右侧竖分屏 / F8 下方横分屏；编辑区保持源码)

local preview = require("config.markdown_preview")

return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      {
        "<F7>",
        function()
          preview.toggle("right")
        end,
        desc = "Markdown 右侧竖分屏预览",
      },
      {
        "<F8>",
        function()
          preview.toggle("below")
        end,
        desc = "Markdown 下方横分屏预览",
      },
    },
    config = function()
      require("render-markdown").setup({
        enabled = false,
        file_types = { "markdown" },
      })
      preview.setup()
    end,
  },
}
