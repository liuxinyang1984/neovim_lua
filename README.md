# Neovim Lua 配置

从 Vimscript + coc.nvim 迁移到 Lua + 原生 LSP 栈的新配置仓库。  
**当前状态：可日常测试使用**（A 类编辑体验 + B 类 LSP 栈已接入）。

## 主要语言

PHP · Go · Python · JavaScript / TypeScript · Vue · Lua（本仓库配置）

## 安装

### 推荐：符号链接整目录

仓库即配置目录，改代码立刻生效，无需 `cp` 同步。

```bash
# 备份旧配置（若 ~/.config/nvim 已存在）
mv ~/.config/nvim ~/.config/nvim.bak

# 链到本仓库（路径按实际 clone 位置调整）
ln -sf ~/git/neovim ~/.config/nvim
```

之后直接 `nvim` 即可。`init.lua` 会自动解析仓库根目录为 `root`，`require("config.*")` 与 lazy.nvim 的 `performance.rtp.paths` 均基于此路径。

### 并行测试（不改动 ~/.config/nvim）

与旧 `init.nvim` + coc 并存时，用 `-u` 指定入口：

```bash
nvim -u ~/git/neovim/init.lua
```

建议别名（`~/.zshrc`）：

```bash
alias nvim-new='nvim -u ~/git/neovim/init.lua'
```

| 命令 | 说明 |
|------|------|
| `nvim` | 当前默认配置（未 link 时为旧 `init.nvim` + coc） |
| `nvim-new` | 本仓库配置（`-u` 方式） |

### 备选：wrapper `init.lua`

若需在 `~/.config/nvim` 保留本机私有文件、又不想替换整目录，可写最小入口加载仓库：

```lua
-- ~/.config/nvim/init.lua
local root = vim.fn.expand("~/git/neovim")
vim.opt.rtp:prepend(root)
loadfile(root .. "/init.lua")()
```

注意：此方式下 `stdpath("config")` 仍是 `~/.config/nvim`，`lazy-lock.json` 默认会写在 wrapper 目录而非仓库。若希望 lock 文件进 git，需在 `lazy.setup` 中设置 `lockfile = root .. "/lazy-lock.json"`。

### 首次启动

```bash
nvim          # 或 nvim-new
:Lazy sync    # 安装插件（lazy.nvim 首次会自动 clone）
:Mason        # 安装 LSP / formatter（如 gopls、intelephense、pyright、ruff）
```

| 命令 | 说明 |
|------|------|
| `:Lazy` | 插件管理 |
| `:Mason` | LSP / formatter 安装 |
| `:LspInfo` | LSP 状态（alias → `:checkhealth vim.lsp`） |
| `:checkhealth` | 健康检查 |

## 目录结构

```
.
├── init.lua              # 入口
├── lazy-lock.json        # lazy.nvim 版本锁（提交到 git）
├── README.md
└── lua/
    ├── config/                 # 与 lazy 插件无关的核心配置
    │   ├── options.lua         # vim.opt
    │   ├── abbrev.lua          # ddd / dddd 插入缩写
    │   ├── keymaps.lua         # 通用快捷键
    │   ├── autocmds.lua        # 自动命令（treesitter、fcitx 等）
    │   ├── clipboard.lua       # cliphist 粘贴历史（<leader>cn）
    │   ├── fcitx.lua           # 退出插入模式 → fcitx5 切英文
    │   └── lsp.lua             # mason + 各语言 LSP + on_attach 键位
    └── plugins/                # lazy.nvim 插件 spec（每文件一类）
        ├── lsp.lua             # mason、mason-lspconfig、lspconfig
        ├── cmp.lua             # nvim-cmp（仅 LSP 补全）
        ├── conform.lua         # 格式化
        ├── autopairs.lua       # 自动括号（替代 coc-pairs）
        ├── treesitter.lua
        ├── colorscheme.lua     # gruvbox
        ├── ufo.lua             # 折叠
        ├── neotree.lua         # 文件树（tt）
        ├── telescope.lua       # 模糊搜索
        ├── toggleterm.lua
        ├── comment.lua
        ├── lualine.lua
        ├── surround.lua
        ├── dressing.lua
        ├── indent-blankline.lua
        ├── render-markdown.lua
        ├── table-mode.lua
        ├── wildfire.lua        # Normal/Visual <Enter> 括号/引号内扩选
        └── suda.lua            # :sw 远程 sudo 保存
```

## 已接入功能

### A 类（编辑 / UI，替代原 vim-plug + 部分 coc 非语言扩展）

| 能力 | 插件 / 模块 |
|------|-------------|
| 插件管理 | lazy.nvim |
| 主题 | gruvbox |
| 语法高亮 | nvim-treesitter |
| 折叠 | nvim-ufo |
| 文件树 `tt` | neo-tree |
| 搜索 `ff`/`fr`/… | telescope |
| 终端 | toggleterm |
| 注释 `<C-/>` | nvim-comment |
| 状态栏 | lualine |
| surround / 表格 / Markdown 预览 | vim-surround、table-mode、render-markdown |
| 缩进线 | indent-blankline |
| 剪贴板历史 `<leader>cn` | dressing + cliphist |
| 远程保存 `:sw` | suda.vim |
| wildfire | Normal/Visual `<Enter>` 扩大选区（括号/引号内）；Visual `<BS>` 缩小 |
| fcitx5 | `config/fcitx.lua`（InsertLeave → 英文） |

### B 类（LSP 栈，替代 coc 语言扩展）

| 能力 | 实现 |
|------|------|
| LSP 安装 | mason + mason-lspconfig |
| LSP 配置 | Neovim 0.11+ `vim.lsp.config` + `lua/config/lsp.lua` |
| 补全 | nvim-cmp + cmp-nvim-lsp + **signature help**（输入 `(` 参数提示） |
| 格式化 `<leader>f` | conform（Go/PHP → LSP fallback；Python → ruff） |
| 自动括号 | nvim-autopairs |
| Emmet | emmet_language_server |

#### LSP 服务器（Mason）

| 类别 | 服务器 |
|------|--------|
| 主语言 | gopls、intelephense、pyright、ts_ls、vue_ls |
| Web 辅助 | html、cssls、jsonls |
| 其它 | emmet_language_server、lua_ls |

Vue 需 **ts_ls + @vue/typescript-plugin**（与 vue_ls 联动，见 `lua/config/lsp.lua`）。

#### Buffer 级 LSP 键位（LspAttach）

| 键位 | 功能 |
|------|------|
| `gd` / `gy` / `gi` / `gr` | 定义 / 类型定义 / 实现 / 引用 |
| `M` | Hover |
| `<leader>rn` | 重命名 |
| `<leader>j` / `<leader>k` | 上 / 下一条诊断 |

导航为 **Telescope** LSP picker（`gd`/`gr`/…；Enter 跳转，t 新标签）。

#### 补全键位（插入模式）

| 键位 | 功能 |
|------|------|
| `<C-j>` / `<C-k>` | 补全菜单上下 |
| `<CR>` | 确认补全 |
| `<Tab>` | 缩进（非补全触发） |

#### 插入缩写（Insert）

| 输入 | 功能 |
|------|------|
| `ddd` + 空格 | 插入日期 `YYYY-MM-DD` |
| `dddd` + 空格 | 插入日期时间 `YYYY-MM-DD HH:MM:SS` |

（用 `InsertCharPre` 实现，避免与 nvim-autopairs 抢 Space 导致 iabbrev 不触发。）

## 尚未迁移 / 待定

| 项 | 说明 |
|----|------|
| **run.lua + F5** | 运行 PHP/Go/Python 等（旧 init.nvim + toggleterm） |
| **CodeCompanion** | AI 助手（旧配置有） |
| **LuaSnip / 片段** | 曾明确推迟（B-2 仅 LSP 补全） |
| **前端 Prettier** | conform 未配 JS/TS/Vue 专用 formatter |

## 与旧配置的关系

| | 旧配置 | 本仓库 |
|--|--------|--------|
| 路径 | `~/.config/nvim/init.nvim` | `~/git/neovim/`（推荐 `ln -sf` 到 `~/.config/nvim`） |
| 插件管理 | vim-plug | lazy.nvim |
| LSP | coc.nvim + 扩展 | mason + nvim-lspconfig |
| 补全 | coc | nvim-cmp |
| 格式化 | coc-format | conform |
| 文件树 | coc-explorer | neo-tree |
| 搜索 | Leaderf（主）+ telescope | telescope |
| 输入法 | fcitx5 InsertLeave | 同左（`config/fcitx.lua`） |

未 link 前可用 `nvim-new`（`-u`）与旧配置并行测试；link 后 `nvim` 即为本仓库配置。
