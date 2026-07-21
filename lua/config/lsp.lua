-- LSP shared setup (servers added step-by-step in B class)

local nav = require("config.lsp_nav")

local M = {}

local augroup = vim.api.nvim_create_augroup("config_lsp", { clear = true })

function M.on_attach(_client, bufnr)
  if vim.lsp.completion then
    vim.lsp.completion.enable(false, _client.id, bufnr)
  end

  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
  end

  map("n", "gd", nav.definition, "跳转定义")
  map("n", "gy", nav.type_definition, "跳转类型定义")
  map("n", "gi", nav.implementation, "跳转实现")
  map("n", "gr", nav.references, "查找引用")
  map("n", "M", vim.lsp.buf.hover, "Hover 文档")
  map("n", "<leader>rn", vim.lsp.buf.rename, "LSP 重命名")
  map("n", "<leader>j", function()
    vim.diagnostic.jump({ count = -1, buffer = bufnr })
  end, "上一个诊断")
  map("n", "<leader>k", function()
    vim.diagnostic.jump({ count = 1, buffer = bufnr })
  end, "下一个诊断")
end

function M.setup()
  nav.setup()

  if vim.fn.exists(":LspInfo") ~= 2 then
    vim.api.nvim_create_user_command("LspInfo", function()
      vim.cmd.checkhealth("vim.lsp")
    end, { desc = "Alias to :checkhealth vim.lsp" })
  end

  vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup,
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client then
        M.on_attach(client, args.buf)
      end
    end,
  })

  vim.diagnostic.config({
    virtual_text = { prefix = "●", source = "if_many" },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
  })

  require("mason").setup()

  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  local function root_dir(bufnr, on_dir, markers)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    if fname == "" then
      on_dir(vim.fn.getcwd())
      return
    end
    for _, marker in ipairs(markers) do
      local root = vim.fs.root(fname, marker)
      if root then
        on_dir(root)
        return
      end
    end
    on_dir(vim.fn.getcwd())
  end

  local vue_ts_plugin_path = vim.fs.joinpath(
    vim.fn.stdpath("data"),
    "mason/packages/vue-language-server/node_modules/@vue/typescript-plugin"
  )

  vim.lsp.config("gopls", {
    capabilities = capabilities,
    root_dir = function(bufnr, on_dir)
      root_dir(bufnr, on_dir, { "go.work", "go.mod", ".git" })
    end,
  })

  vim.lsp.config("intelephense", {
    capabilities = capabilities,
    -- Match coc: workspace = directory from which nvim was opened (cwd),
    -- not the nearest addon composer.json.
    root_dir = function(_bufnr, on_dir)
      on_dir(vim.fn.getcwd())
    end,
  })

  vim.lsp.config("pyright", {
    capabilities = capabilities,
    root_dir = function(bufnr, on_dir)
      root_dir(bufnr, on_dir, { "pyproject.toml", "setup.py", "setup.cfg", ".git" })
    end,
  })

  vim.lsp.config("ts_ls", {
    capabilities = capabilities,
    init_options = {
      hostInfo = "neovim",
      plugins = {
        {
          name = "@vue/typescript-plugin",
          location = vue_ts_plugin_path,
          languages = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
        },
      },
    },
    filetypes = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "vue",
    },
    root_dir = function(bufnr, on_dir)
      root_dir(bufnr, on_dir, { "tsconfig.json", "jsconfig.json", "package.json", ".git" })
    end,
  })

  vim.lsp.config("vue_ls", {
    capabilities = capabilities,
    root_dir = function(bufnr, on_dir)
      root_dir(bufnr, on_dir, { "package.json", ".git" })
    end,
  })

  for _, server in ipairs({ "html", "cssls", "jsonls" }) do
    vim.lsp.config(server, {
      capabilities = capabilities,
      root_dir = function(bufnr, on_dir)
        root_dir(bufnr, on_dir, { "package.json", ".git" })
      end,
    })
  end

  vim.lsp.config("emmet_language_server", {
    capabilities = capabilities,
    init_options = {
      showAbbreviationSuggestions = true,
      showExpandedAbbreviation = "always",
      showSuggestionsAsSnippets = true,
    },
    root_dir = function(bufnr, on_dir)
      root_dir(bufnr, on_dir, { "package.json", ".git" })
    end,
  })

  vim.lsp.config("lua_ls", {
    capabilities = capabilities,
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
          path = { "lua/?.lua", "lua/?/init.lua" },
        },
        workspace = {
          checkThirdParty = false,
          library = { vim.env.VIMRUNTIME },
        },
      },
    },
    root_dir = function(bufnr, on_dir)
      root_dir(bufnr, on_dir, { ".luarc.json", ".luarc.jsonc", "stylua.toml", ".git" })
    end,
  })

  require("mason-lspconfig").setup({
    ensure_installed = {
      "gopls",
      "intelephense",
      "pyright",
      "ts_ls",
      "vue_ls",
      "html",
      "cssls",
      "jsonls",
      "emmet_language_server",
      "lua_ls",
    },
  })
end

return M
