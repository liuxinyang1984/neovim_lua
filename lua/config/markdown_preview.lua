-- Markdown split preview (F7 right / F8 left); edit buffer stays raw.

local M = {}

local group = vim.api.nvim_create_augroup("config_markdown_preview", { clear = true })

---@type table<integer, { dst: integer, win: integer, split: string }>
local previews = {}

local function find_preview(src)
  return previews[src]
end

local function find_src_by_dst(dst)
  for src, info in pairs(previews) do
    if info.dst == dst then
      return src
    end
  end
end

local function enable_render(buf)
  local manager = require("render-markdown.core.manager")
  if manager.attached(buf) then
    manager.set_buf(buf, true)
  end
end

local function close_preview(src)
  local info = previews[src]
  if not info then
    return
  end
  previews[src] = nil
  vim.api.nvim_clear_autocmds({ group = group, buffer = src })
  if vim.api.nvim_buf_is_valid(info.dst) then
    vim.api.nvim_buf_delete(info.dst, { force = true })
  end
  local manager = require("render-markdown.core.manager")
  if manager.attached(src) then
    manager.set_buf(src, false)
  end
end

---@param src_buf integer
---@param dst_buf integer
local function copy_lines(src_buf, dst_buf)
  local env = require("render-markdown.lib.env")
  local src_lines = vim.api.nvim_buf_get_lines(src_buf, 0, -1, false)
  local dst_lines = vim.api.nvim_buf_get_lines(dst_buf, 0, -1, false)

  local src_text = table.concat(src_lines, "\n") .. "\n"
  local dst_text = table.concat(dst_lines, "\n") .. "\n"

  ---@diagnostic disable-next-line: deprecated
  local get_diff = vim.text and vim.text.diff or vim.diff
  local diff = get_diff(dst_text, src_text, { result_type = "indices" })
  assert(type(diff) == "table", "diff must provide indices")

  env.buf.set(dst_buf, "modifiable", true)
  for i = 1, #diff do
    local hunk = diff[#diff - i + 1]
    local start_a, count_a, start_b, count_b = unpack(hunk)
    local line_start = start_a - 1
    local line_end = start_a + count_a - 1
    if count_a == 0 then
      line_start = line_start + 1
      line_end = line_end + 1
    end
    vim.api.nvim_buf_set_lines(dst_buf, line_start, line_end, false, {
      unpack(src_lines, start_b, start_b + count_b - 1),
    })
  end
  env.buf.set(dst_buf, "modifiable", false)
end

local function copy_cursor(src_win, dst_win)
  local cursor = vim.api.nvim_win_get_cursor(src_win)
  pcall(vim.api.nvim_win_set_cursor, dst_win, cursor)
end

local function copy_event(args, buf)
  vim.api.nvim_exec_autocmds(args.event, { buffer = buf })
end

---@param split 'right'|'left'|'below'|'above'
function M.toggle(split)
  if vim.bo.filetype ~= "markdown" then
    vim.notify("仅在 Markdown 文件中可用", vim.log.levels.INFO)
    return
  end

  local env = require("render-markdown.lib.env")
  local manager = require("render-markdown.core.manager")
  local src = vim.api.nvim_get_current_buf()

  if not manager.attached(src) then
    manager.attach(src)
  end

  local existing = find_preview(src)
  if existing then
    close_preview(src)
    if existing.split == split then
      return
    end
  end

  manager.set_buf(src, false)

  local src_win = env.buf.win(src)
  local dst_buf = vim.api.nvim_create_buf(false, true)
  local dst_win = vim.api.nvim_open_win(dst_buf, false, { split = split })
  previews[src] = { dst = dst_buf, win = dst_win, split = split }

  vim.bo[dst_buf].bufhidden = "wipe"
  vim.bo[dst_buf].buftype = "nofile"
  vim.bo[dst_buf].filetype = vim.bo[src].filetype
  vim.bo[dst_buf].modifiable = false
  vim.bo[dst_buf].swapfile = false

  copy_lines(src, dst_buf)
  copy_cursor(src_win, dst_win)

  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    group = group,
    buffer = src,
    callback = function(args)
      local info = find_preview(src)
      if not info or not env.valid(src, src_win) or not env.valid(info.dst, info.win) then
        return
      end
      copy_cursor(src_win, info.win)
      copy_event(args, info.dst)
    end,
  })

  vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
    group = group,
    buffer = src,
    callback = function(args)
      local info = find_preview(src)
      if not info or not env.valid(src, src_win) or not env.valid(info.dst, info.win) then
        return
      end
      copy_lines(src, info.dst)
      copy_cursor(src_win, info.win)
      copy_event(args, info.dst)
    end,
  })

  vim.api.nvim_create_autocmd("BufWipeout", {
    group = group,
    buffer = dst_buf,
    once = true,
    callback = function()
      previews[src] = nil
      vim.api.nvim_clear_autocmds({ group = group, buffer = src })
      if manager.attached(src) then
        manager.set_buf(src, false)
      end
    end,
  })

  vim.schedule(function()
    enable_render(dst_buf)
  end)
end

function M.setup()
  vim.api.nvim_create_autocmd("BufWipeout", {
    group = group,
    callback = function(args)
      local src = find_src_by_dst(args.buf)
      if src and vim.api.nvim_buf_is_valid(src) then
        previews[src] = nil
        vim.api.nvim_clear_autocmds({ group = group, buffer = src })
        vim.schedule(function()
          if require("render-markdown.core.manager").attached(src) then
            require("render-markdown.core.manager").set_buf(src, false)
          end
        end)
      end
    end,
  })
end

return M
