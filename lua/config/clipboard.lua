-- cliphist integration (requires `cliphist` on system PATH)

local M = {}

function M.floating_menu()
  local handle = io.popen("cliphist list | head -n 15")
  if not handle then
    vim.notify("无法执行 cliphist", vim.log.levels.ERROR)
    return
  end

  local result = handle:read("*a")
  handle:close()

  local lines = {}
  for line in result:gmatch("[^\r\n]+") do
    table.insert(lines, line)
  end

  if #lines == 0 then
    vim.notify("剪贴板空空如也", vim.log.levels.INFO)
    return
  end

  vim.ui.select(lines, {
    prompt = "选择要粘贴的内容:",
    kind = "center",
  }, function(choice)
    if not choice then
      return
    end

    local id = choice:match("^(%d+)")
    if not id then
      local tab = choice:find("\t", 1, true)
      if tab then
        id = choice:sub(1, tab - 1):match("^(%d+)$")
      end
    end
    if not id then
      return
    end

    local content = vim.fn.trim(vim.fn.system({ "cliphist", "decode", id }))
    vim.fn.setreg('"', content)
    vim.cmd("normal! p")
  end)
end

return M
