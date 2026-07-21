-- LSP 跳转：on_list 始终打开 quickfix；<CR> 打开 / t 新标签 / q 关闭

local M = {}

local qf_group = vim.api.nvim_create_augroup("config_lsp_nav_qf", { clear = true })

local function qf_item_filename(item)
  if item.filename and item.filename ~= "" then
    return vim.fn.fnamemodify(item.filename, ":p")
  end
  if item.bufnr and item.bufnr > 0 then
    local name = vim.fn.bufname(item.bufnr)
    if name and name ~= "" then
      return vim.fn.fnamemodify(name, ":p")
    end
  end
end

local function jump_to_item(item, open_in_tab)
  vim.cmd("normal! m'")
  local filename = qf_item_filename(item)
  if not filename then
    vim.notify("无法解析跳转目标", vim.log.levels.WARN)
    return
  end
  local lnum = item.lnum or 1

  if open_in_tab then
    vim.cmd(string.format("keepjumps tabedit +%d %s", lnum, vim.fn.fnameescape(filename)))
  elseif item.bufnr and item.bufnr > 0 and vim.api.nvim_buf_is_valid(item.bufnr) then
    vim.fn.bufload(item.bufnr)
    vim.bo[item.bufnr].buflisted = true
    vim.api.nvim_set_current_buf(item.bufnr)
  else
    local bufnr = vim.fn.bufadd(filename)
    vim.fn.bufload(bufnr)
    vim.bo[bufnr].buflisted = true
    vim.api.nvim_set_current_buf(bufnr)
  end

  local bufnr = vim.api.nvim_get_current_buf()
  vim.fn.bufload(bufnr)
  local line_count = math.max(vim.api.nvim_buf_line_count(bufnr), 1)
  lnum = math.min(math.max(lnum, 1), line_count)
  local line = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)[1] or ""
  local col = math.min(math.max((item.col or 1) - 1, 0), #line)
  vim.api.nvim_win_set_cursor(0, { lnum, col })
  vim.cmd("normal! zv")
end

local function jump_from_qf(open_in_tab)
  local idx = vim.api.nvim_win_get_cursor(0)[1]
  local item = vim.fn.getqflist({ idx = idx, items = 1 }).items[1]
  if not item then
    return
  end
  vim.cmd("cclose")
  jump_to_item(item, open_in_tab)
end

local list_opts = {
  on_list = function(options)
    vim.fn.setqflist({}, " ", options)
    vim.cmd("botright copen")
  end,
}

function M.setup()
  vim.api.nvim_create_autocmd("FileType", {
    group = qf_group,
    pattern = "qf",
    callback = function(event)
      local opts = { buffer = event.buf, nowait = true, silent = true }
      vim.keymap.set("n", "<CR>", function()
        jump_from_qf(false)
      end, vim.tbl_extend("force", opts, { desc = "打开并关闭列表" }))
      vim.keymap.set("n", "t", function()
        jump_from_qf(true)
      end, vim.tbl_extend("force", opts, { desc = "新标签打开并关闭列表" }))
      vim.keymap.set("n", "q", function()
        vim.cmd("cclose")
      end, vim.tbl_extend("force", opts, { desc = "关闭 quickfix" }))
      vim.keymap.set("n", "<Esc>", function()
        vim.cmd("cclose")
      end, opts)
    end,
  })
end

function M.definition()
  vim.lsp.buf.definition(list_opts)
end

function M.type_definition()
  vim.lsp.buf.type_definition(list_opts)
end

function M.implementation()
  vim.lsp.buf.implementation(list_opts)
end

function M.references()
  vim.lsp.buf.references(nil, list_opts)
end

return M
