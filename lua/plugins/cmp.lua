-- LSP completion + signature help (parameter hints on fn()

return {
  {
    "hrsh7th/nvim-cmp",
    lazy = false,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
    },
    config = function()
      local cmp = require("cmp")

      -- 双 Tab 手动触发（与 fcitx C-Space 冲突时用）；需要时取消下面整块注释并注释掉上面的 Tab 映射
      -- local last_tab = 0
      -- local tab_double_ms = 300

      cmp.setup({
        preselect = cmp.PreselectMode.Item,
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping(function(fallback)
            -- 启用双 Tab 时替换为：
            -- local now = vim.loop.now()
            -- if now - last_tab < tab_double_ms then
            --   if cmp.visible() then
            --     cmp.select_next_item()
            --   else
            --     cmp.complete()
            --   end
            -- else
            --   fallback()
            -- end
            -- last_tab = now
            fallback()
          end),

          ["<C-j>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<C-k>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "nvim_lsp_signature_help" },
        },
      })
    end,
  },
}
