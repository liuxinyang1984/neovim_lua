-- General keymaps (migrated from init.nvim, step-by-step confirmed)

local map = vim.keymap.set
local builtin = function(picker)
  return function()
    require("telescope.builtin")[picker]()
  end
end

-- =============================================================================
-- 搜索
-- =============================================================================

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "清除搜索高亮" })

-- wildfire: expand/shrink text objects (<CR> in Normal + Visual, <BS> in Visual)
-- Must map Visual <CR> too: first Enter leaves visual mode; without vmap the plugin's
-- default `map <ENTER>` is skipped because nmap already points at the Plug mapping.
map({ "n", "v" }, "<CR>", "<Plug>(wildfire-fuel)", { desc = "扩大选区（括号/引号内）" })
map("v", "<BS>", "<Plug>(wildfire-water)", { desc = "缩小选区" })

map("n", "ff", builtin("find_files"), { desc = "项目内找文件" })
map("n", "fr", builtin("live_grep"), { desc = "全局 rg 搜索" })
map("n", "fb", builtin("buffers"), { desc = "切换 buffer" })
map("n", "fm", builtin("oldfiles"), { desc = "最近文件" })
map("n", "fl", builtin("current_buffer_fuzzy_find"), { desc = "当前 buffer 行" })
map("n", "fc", builtin("colorscheme"), { desc = "配色方案" })
map("n", "fu", builtin("treesitter"), { desc = "当前文件符号（treesitter）" })
map("n", "ft", builtin("tags"), { desc = "tags" })

-- =============================================================================
-- 系统剪贴板
-- =============================================================================

map("n", "<leader>y", '"+y', { desc = "复制到系统剪贴板" })
map("v", "<leader>y", '"+y', { desc = "复制选中内容到系统剪贴板" })
map("n", "<leader>p", '"+p', { desc = "从系统剪贴板粘贴" })
map("v", "<leader>p", '"+p', { desc = "用系统剪贴板内容替换选中区域" })

-- =============================================================================
-- 剪贴板历史（cliphist）
-- =============================================================================

map("n", "<leader>cn", function()
  require("config.clipboard").floating_menu()
end, { desc = "从 cliphist 历史选择粘贴" })

-- 格式化见 lua/plugins/conform.lua（Normal <leader>f，整文件）

-- =============================================================================
-- 文件树（neo-tree）
-- =============================================================================

map("n", "tt", "<cmd>Neotree filesystem reveal toggle<CR>", { desc = "切换文件树并定位当前文件" })

-- =============================================================================
-- 注释（nvim-comment）
-- =============================================================================

local function comment_toggle()
  require("nvim_comment").comment_toggle(vim.fn.line("."), vim.fn.line("."))
end

map("n", "<C-/>", comment_toggle, { desc = "切换行注释" })
map("x", "<C-/>", ":'<,'>CommentToggle<CR>", { desc = "切换选中注释" })
map("i", "<C-/>", "<Esc><Cmd>lua require('nvim_comment').comment_toggle(vim.fn.line('.'), vim.fn.line('.'))<CR>", {
  desc = "切换行注释",
})

-- =============================================================================
-- Markdown 表格（table-mode）
-- =============================================================================

map("n", "<leader>tm", "<cmd>TableModeToggle<CR>", { desc = "开关表格模式" })
map("n", "<leader>tr", "<cmd>TableModeRealign<CR>", { desc = "重新对齐表格" })
map("n", "<leader>ti", "<cmd>TableModeTableize<CR>", { desc = "格式化为表格" })

-- =============================================================================
-- 插入模式：光标与编辑
-- =============================================================================

map("i", "<C-h>", "<Left>", { desc = "插入模式光标左移" })
map("i", "<C-j>", "<Down>", { desc = "插入模式光标下移" })
map("i", "<C-k>", "<Up>", { desc = "插入模式光标上移" })
map("i", "<C-l>", "<Right>", { desc = "插入模式光标右移" })

map("i", "<C-d>", "<Esc>ddi", { desc = "插入模式删除当前行" })
map("i", "<C-D>", "<Esc>Di", { desc = "插入模式删除到行尾" })

map("i", "<C-u>", "<Cmd>undo<CR>", { desc = "插入模式撤销" })
map("i", "<C-r>", "<Cmd>redo<CR>", { desc = "插入模式重做" })
map("i", "<C-BS>", "<C-o>d0", { desc = "插入模式删除到行首" })

-- =============================================================================
-- 插入模式：保存与退出
-- =============================================================================

map("n", "<C-q>", "<cmd>q<CR>", { desc = "退出当前窗口" })
map("i", "<C-q>", "<Esc><cmd>q<CR>", { desc = "插入模式下退出当前窗口" })

map("n", "<C-s>", "<cmd>w<CR>", { desc = "保存当前文件" })
map("i", "<C-s>", "<Esc><cmd>w<CR>", { desc = "插入模式下保存当前文件" })

-- =============================================================================
-- 标签页
-- =============================================================================

map("n", "tn", "<cmd>tabe<CR>", { desc = "新建标签页" })
map("n", "th", "<cmd>tabp<CR>", { desc = "上一个标签页" })
map("n", "tl", "<cmd>tabn<CR>", { desc = "下一个标签页" })
map("n", "tk", "<cmd>-tabmove<CR>", { desc = "标签页左移" })
map("n", "tj", "<cmd>+tabmove<CR>", { desc = "标签页右移" })

-- =============================================================================
-- 快速移动
-- =============================================================================

map("n", "J", "5j", { desc = "向下移动 5 行" })
map("n", "K", "5k", { desc = "向上移动 5 行" })
map("v", "J", "5j", { desc = "可视模式向下移动 5 行" })
map("v", "K", "5k", { desc = "可视模式向上移动 5 行" })

-- =============================================================================
-- 窗口导航
-- =============================================================================

map("n", "wh", "<C-w>h", { desc = "焦点移到左侧窗口" })
map("n", "wj", "<C-w>j", { desc = "焦点移到下方窗口" })
map("n", "wk", "<C-w>k", { desc = "焦点移到上方窗口" })
map("n", "wl", "<C-w>l", { desc = "焦点移到右侧窗口" })

map("n", "<A-h>", "<C-w>h", { desc = "焦点移到左侧窗口" })
map("n", "<A-j>", "<C-w>j", { desc = "焦点移到下方窗口" })
map("n", "<A-k>", "<C-w>k", { desc = "焦点移到上方窗口" })
map("n", "<A-l>", "<C-w>l", { desc = "焦点移到右侧窗口" })

-- =============================================================================
-- 分屏
-- =============================================================================

map("n", "sl", "<cmd>set splitright<CR><cmd>vsplit<CR>", { desc = "在右侧竖分屏" })
map("n", "sh", "<cmd>set nosplitright<CR><cmd>vsplit<CR>", { desc = "在左侧竖分屏" })
map("n", "sj", "<cmd>set splitbelow<CR><cmd>split<CR>", { desc = "在下方横分屏" })
map("n", "sk", "<cmd>set nosplitbelow<CR><cmd>split<CR>", { desc = "在上方横分屏" })

-- =============================================================================
-- 窗口大小
-- =============================================================================

map("n", "<A-H>", "<cmd>vertical resize +5<CR>", { desc = "窗口变宽 5 列" })
map("n", "<A-L>", "<cmd>vertical resize -5<CR>", { desc = "窗口变窄 5 列" })
map("n", "<A-J>", "<cmd>resize +5<CR>", { desc = "窗口变高 5 行" })
map("n", "<A-K>", "<cmd>resize -5<CR>", { desc = "窗口变矮 5 行" })

-- =============================================================================
-- 折叠
-- =============================================================================

map("n", "zR", function()
  require("ufo").openAllFolds()
end, { desc = "展开所有折叠" })

map("n", "zM", function()
  require("ufo").closeAllFolds()
end, { desc = "折叠所有" })

-- =============================================================================
-- 占位
-- =============================================================================

map("n", "s", "<Nop>", { desc = "s 单独按下无操作（配合 sl/sh/sj/sk）" })
