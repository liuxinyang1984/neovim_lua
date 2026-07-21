-- Formatting (B-4): 整文件格式化；Go/PHP fallback 到 LSP；Python 用 ruff

return {
  {
    "stevearc/conform.nvim",
    cmd = { "ConformInfo" },
    opts = {
      formatters_by_ft = {
        python = { "ruff_format" },
      },
    },
    config = function(_, opts)
      require("conform").setup(opts)
    end,
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({
            async = true,
            lsp_format = "fallback",
            timeout_ms = 5000,
          })
        end,
        mode = "n",
        desc = "格式化 buffer",
      },
    },
  },
}
