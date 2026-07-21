-- Neovim Lua config (test entry — does NOT replace ~/.config/nvim/init.nvim)
--
-- Usage:
--   nvim -u ~/git/neovim/init.new.lua
--
-- Suggested alias (~/.zshrc):
--   alias nvim-new='nvim -u ~/git/neovim/init.new.lua'

-- Config root = this init file's directory (test: git/neovim; deploy: ~/.config/nvim)
local root = vim.fn.fnamemodify(vim.fn.resolve(debug.getinfo(1, "S").source:sub(2)), ":h")
-- prepend for requires before lazy.setup; lazy reset rtp clears this, so also set paths below
vim.opt.rtp:prepend(root)

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.abbrev").setup()

-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local uv = vim.uv or vim.loop
if not uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  performance = {
    rtp = {
      paths = { root },
    },
  },
  checker = { enabled = true },
  change_detection = { enabled = false, notify = false },
})
