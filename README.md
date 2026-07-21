# Neovim Lua 配置

从 Vimscript + coc.nvim 迁移到 Lua + 原生 LSP 栈的新配置仓库。  
**当前状态：可日常测试使用**（A 类编辑体验 + B 类 LSP 栈已接入）；与旧 `~/.config/nvim/init.nvim` **并行**，正式切换前勿覆盖日常环境。

## 主要语言

PHP · Go · Python · JavaScript / TypeScript · Vue · Lua（本仓库配置）

## 使用方式

### 测试新配置

```bash
nvim -u ~/git/neovim/init.new.lua
```

建议别名（`~/.zshrc`）：

```bash
alias nvim-new='nvim -u ~/git/neovim/init.new.lua'
```

| 命令 | 说明 |
|------|------|
| `nvim` | 现有配置（`~/.config/nvim/init.nvim` + coc） |
| `nvim-new` | 本仓库测试配置 |

### 入口与 runtimepath

- 入口文件为 **`init.new.lua`**（正式切换前**不要**改名为 `init.lua`）
- 本仓库不在 `~/.config/nvim` 时，需 `init.new.lua` **prepend runtimepath**，`require("config.*")` 才能解析 `lua/config/`
- lazy.nvim 通过 `performance.rtp.paths` 在 reset rtp 后仍能找到本仓库

### 常用维护命令

| 命令 | 说明 |
|------|------|
| `:Lazy` | 插件管理 |
| `:Mason` | 安装 LSP / formatter（如 `ruff`） |
| `:LspInfo` | LSP 状态（alias → `:checkhealth vim.lsp`） |
| `:checkhealth` | 健康检查 |

## 目录结构

```
.
├── init.new.lua
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
| fcitx5 | `config/fcitx.lua`（InsertLeave → 英文） |

### B 类（LSP 栈，替代 coc 语言扩展）

| 能力 | 实现 |
|------|------|
| LSP 安装 | mason + mason-lspconfig |
| LSP 配置 | Neovim 0.11+ `vim.lsp.config` + `lua/config/lsp.lua` |
| 补全 | nvim-cmp + cmp-nvim-lsp（**仅 LSP**，无 LuaSnip） |
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

导航为 **Neovim 原生** `vim.lsp.buf.*`（多结果走 quickfix）。

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
| **正式切换** | 见下文 |

## 正式切换（将来）

测试满意后：

```bash
# 备份旧配置
mv ~/.config/nvim/init.nvim ~/.config/nvim/init.nvim.bak

# 同步并重命名入口
cp -r ~/git/neovim/* ~/.config/nvim/
mv ~/.config/nvim/init.new.lua ~/.config/nvim/init.lua
```

也可使用 git clone / symlink 等方式，按个人习惯选择。

## 与旧配置的关系

| | 旧配置 | 本仓库 |
|--|--------|--------|
| 路径 | `~/.config/nvim/init.nvim` | `~/git/neovim/` |
| 插件管理 | vim-plug | lazy.nvim |
| LSP | coc.nvim + 扩展 | mason + nvim-lspconfig |
| 补全 | coc | nvim-cmp |
| 格式化 | coc-format | conform |
| 文件树 | coc-explorer | neo-tree |
| 搜索 | Leaderf（主）+ telescope | telescope |
| 输入法 | fcitx5 InsertLeave | 同左（`config/fcitx.lua`） |

迁移期间两套配置并行，互不影响。
