-- Read/write files via sudo (forget sudo vim → :sw after editing)
-- Neovim user commands must start uppercase; :sw is a cmdline abbrev → SudaWrite

return {
  {
    "lambdalisue/suda.vim",
    config = function()
      vim.cmd("cnoreabbrev sw SudaWrite")
    end,
  },
}
