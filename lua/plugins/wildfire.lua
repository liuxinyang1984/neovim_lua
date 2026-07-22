-- Expand selection inside brackets/quotes (Normal <CR>, Visual <BS>)

return {
  {
    "gcmt/wildfire.vim",
    event = "VeryLazy",
    init = function()
      vim.g.wildfire_objects = vim.split("ip i) i] i} i' i\" it", " ")
    end,
  },
}
