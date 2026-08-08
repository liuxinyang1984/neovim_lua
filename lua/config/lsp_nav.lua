-- LSP 跳转：Telescope picker（多结果浮窗；Enter 跳转并关闭，t / <C-t> 新标签）

local builtin = require("telescope.builtin")

local M = {}

function M.setup() end

function M.definition()
  builtin.lsp_definitions()
end

function M.type_definition()
  builtin.lsp_type_definitions()
end

function M.implementation()
  builtin.lsp_implementations()
end

function M.references()
  builtin.lsp_references()
end

return M
