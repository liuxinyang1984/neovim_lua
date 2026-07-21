-- Floating terminal (replaces coc-floaterm)

return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { "<C-\\>", desc = "切换浮动终端" },
    },
    opts = {
      open_mapping = [[<C-\>]],
      direction = "float",
      float_opts = {
        border = "curved",
        width = function()
          return math.floor(vim.o.columns * 0.7)
        end,
        height = function()
          return math.floor(vim.o.lines * 0.5)
        end,
      },

      -- 以后可扩展其它方向：
      -- direction = "horizontal" | "vertical" | "tab"
      -- 多个终端实例：require("toggleterm").Terminal
    },
  },
}

-- 运行脚本（延后，见 lua/config/run.lua）：
-- <F5> / <leader>rr / <C-]>  → RunCurrentFile()  → toggleterm.exec()
-- <F6> / <leader>r.           → RunCurrentDir()   → go.mod 根目录 go run .
