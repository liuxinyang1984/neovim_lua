-- Insert abbreviations: ddd / dddd (InsertCharPre + vim.schedule; iabbrev breaks with autopairs)

local M = {}

local abbrevs = {
  { word = "dddd", text = function()
    return os.date("%Y-%m-%d %H:%M:%S")
  end },
  { word = "ddd", text = function()
    return os.date("%Y-%m-%d")
  end },
}

function M.setup()
  local group = vim.api.nvim_create_augroup("config_abbrev", { clear = true })

  vim.api.nvim_create_autocmd("InsertCharPre", {
    group = group,
    callback = function(ev)
      local char = (ev.data and ev.data.char) or vim.v.char
      if not char or char == "" then
        return
      end
      if char ~= " " and char ~= ";" and char ~= "," then
        return
      end

      local row, col = unpack(vim.api.nvim_win_get_cursor(0))
      local line = vim.api.nvim_get_current_line()
      local before = line:sub(1, col)

      for _, entry in ipairs(abbrevs) do
        local word = entry.word
        if #before >= #word and before:sub(-#word) == word then
          local start = col - #word
          local text = entry.text()
          vim.v.char = ""
          vim.schedule(function()
            local cur_line = vim.api.nvim_get_current_line()
            vim.api.nvim_set_current_line(cur_line:sub(1, start) .. text .. cur_line:sub(col + 1))
            vim.api.nvim_win_set_cursor(0, { row, start + #text })
          end)
          return
        end
      end
    end,
  })
end

return M
