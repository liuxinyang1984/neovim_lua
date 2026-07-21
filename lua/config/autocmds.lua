-- Autocmds (fcitx, treesitter per buffer, cursor restore, etc.)

local augroup = vim.api.nvim_create_augroup("config", { clear = true })

require("config.fcitx").setup()

-- treesitter: highlight + indent (foldexpr handled by nvim-ufo)
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  callback = function(args)
    local buf = args.buf
    local ft = vim.bo[buf].filetype
    if ft == "" then
      return
    end

    local skip = {
      ["neo-tree"] = true,
      ["neo-tree-popup"] = true,
      ["NuiTree"] = true,
      ["toggleterm"] = true,
      ["DressingSelect"] = true,
    }
    if skip[ft] then
      return
    end

    if vim.treesitter.language.get_lang(ft) then
      local ok = pcall(vim.treesitter.start, buf)
      if ok then
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    else
      vim.bo[buf].syntax = ft
    end
  end,
})

-- restore cursor position when reopening a file
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- cliphist 选择框：整行高亮，仅上下选择（dressing builtin）
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "DressingSelect",
  callback = function(args)
    local buf = args.buf
    local win = vim.fn.bufwinid(buf)
    if win == -1 then
      return
    end

    vim.wo[win].cursorline = true
    vim.wo[win].cursorlineopt = "both"
    vim.wo[win].winhighlight =
      "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,CursorLineNr:CursorLineNr"

    local map = function(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = buf, nowait = true, silent = true, desc = desc })
    end

    local line_start = function()
      local row = vim.api.nvim_win_get_cursor(0)[1]
      vim.api.nvim_win_set_cursor(0, { row, 0 })
    end

    map("h", line_start, "光标回到行首")
    map("l", line_start, "光标回到行首")
    map("<Left>", line_start, "光标回到行首")
    map("<Right>", line_start, "光标回到行首")
    map("j", function()
      vim.cmd("normal! j")
      line_start()
    end, "下一项")
    map("k", function()
      vim.cmd("normal! k")
      line_start()
    end, "上一项")
    map("<Down>", function()
      vim.cmd("normal! j")
      line_start()
    end, "下一项")
    map("<Up>", function()
      vim.cmd("normal! k")
      line_start()
    end, "上一项")

    line_start()
  end,
})

-- vim-table-mode 默认映射 <Space>tt，与 neo-tree 的 tt 冲突
vim.api.nvim_create_autocmd("VimEnter", {
  group = augroup,
  callback = function()
    pcall(vim.keymap.del, "n", "<Space>tt")
  end,
})
