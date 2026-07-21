-- fcitx5: leave Insert mode → switch IME to English

local M = {}

function M.to_english()
  if vim.fn.executable("fcitx5-remote") ~= 1 then
    return
  end
  if vim.trim(vim.fn.system({ "fcitx5-remote" })) == "2" then
    vim.fn.system({ "fcitx5-remote", "-c" })
  end
end

function M.setup()
  if vim.fn.executable("fcitx5-remote") ~= 1 then
    return
  end

  local group = vim.api.nvim_create_augroup("config_fcitx", { clear = true })
  vim.api.nvim_create_autocmd("InsertLeave", {
    group = group,
    callback = M.to_english,
  })
end

return M
