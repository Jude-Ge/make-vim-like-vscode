# `.vimrc` 中文使用说明

## 1. 适用环境

这份配置面向断网 Linux 终端中的 Vim 8.0+，不下载插件，不依赖插件管理器。Vim 7.4 的多数编辑选项也能工作，但内置终端、`termguicolors`、异步特性等会因编译版本自动降级。

建议先确认版本与编译特性：

```sh
vim --version
```

看到 `+terminal` 表示可以使用内置终端，`+clipboard` 表示 Vim 能访问系统剪贴板。SSH 服务器上的 Vim 常见 `-clipboard`，这不是配置错误；此时普通寄存器复制粘贴仍然可用。

## 2. 安装与回滚

```sh
# 在仓库目录执行
cp ~/.vimrc ~/.vimrc.backup 2>/dev/null || true
cp .vimrc ~/.vimrc

# 检查配置是否能无界面加载
vim -Nu ~/.vimrc -n -es +'quit'
```

如果要回滚：

```sh
mv ~/.vimrc.backup ~/.vimrc
```

配置会在 `~/.vim/undo` 保存撤销历史。只要注释掉持久撤销开关，它就不会再使用该目录。

## 3. 用注释选择功能

`.vimrc` 最上方是唯一需要日常修改的区域。每个功能是一条 `let g:vscode_... = 1`：

```vim
let g:vscode_mouse = 1        " 当前启用
" let g:vscode_mouse = 1      " 加一个双引号后禁用
```

启用功能后可以执行 `:source ~/.vimrc`；禁用功能时建议重新打开 Vim，以确保旧映射和旧选项也从当前会话中消失。可控制的模块如下：

| 开关 | 默认 | 作用 |
|---|---:|---|
| `vscode_theme` | 开 | Dark+ 风格的真彩色/256 色主题 |
| `vscode_line_ui` | 开 | 行号、相对行号、当前行和第 80 列参考线 |
| `vscode_statusline` | 开 | 模式、文件、编码、行列位置状态栏 |
| `vscode_mouse` | 开 | 鼠标定位、选择、滚动和窗口调整 |
| `vscode_file_explorer` | 开 | Vim 自带 netrw 文件树 |
| `vscode_file_finder` | 开 | 项目路径中的文件查找 |
| `vscode_project_search` | 开 | 使用内置 `vimgrep` 全项目搜索 |
| `vscode_comments` | 开 | 单行/选区注释切换 |
| `vscode_auto_pairs` | 开 | 括号、方括号、花括号和引号补全 |
| `vscode_folding` | 开 | 代码折叠及快捷键 |
| `vscode_terminal` | 开 | Vim 内置终端；要求 `+terminal` |
| `vscode_persistent_undo` | 开 | 关闭文件或 Vim 后仍可撤销 |
| `vscode_system_clipboard` | 开 | 系统剪贴板映射；要求 `+clipboard` |
| `vscode_ctrl_clipboard` | 关 | Ctrl-C/X/V 映射，可能和终端按键冲突 |
| `vscode_trim_on_save` | 关 | 保存时删除行尾空白，会修改文件内容 |

可选功能默认是被注释的；删除行首双引号即可启用。不要删除整个功能实现块，只需调整顶部开关。

## 4. 快捷键

`<Space>` 表示先按空格键。进入 Vim 后可随时执行 `:VSCodeHelp` 查看最常用快捷键。

### 文件和编辑器

| VS Code 意图 | Vim 快捷键 | 说明 |
|---|---|---|
| 保存 | `Ctrl-S` 或 `<Space>w` | 仅在文件变化时写入 |
| 新文件 | `Ctrl-N` | 创建未命名缓冲区 |
| 打开文件 | `Ctrl-P` 或 `<Space>ff` | 输入相对路径；可按 Tab 补全 |
| 文件树 | `Ctrl-B` 或 `<Space>e` | 打开/关闭左侧 netrw |
| 关闭编辑器 | `<Space>bd` | 关闭当前缓冲区，修改未保存时确认 |
| 上/下一个编辑器 | `[b` / `]b` | 切换缓冲区 |
| 缓冲区列表 | `<Space>bb` | 显示列表后输入编号 |
| 仅保留当前编辑器 | `<Space>bo` | 关闭其他缓冲区 |
| 相对行号 | `F3` | 开关相对行号 |
| 空白字符 | `F4` | 显示/隐藏 Tab 和行尾空格 |

`Ctrl-P` 使用 Vim 的 `path=.,**` 递归查找。比如输入 `src/main.c`；如果路径很长，可输入一部分后按 `Tab` 查看补全。大型单体仓库中 `**` 可能较慢，建议在项目根目录启动 Vim。

### 搜索、跳转和重命名式编辑

| 功能 | 快捷键 | 说明 |
|---|---|---|
| 当前文件查找 | `/文本`，然后 Enter | `n`/`N` 到下/上一个结果 |
| 清除高亮 | 连按两次 `Esc` | 不清除搜索历史 |
| 全项目搜索 | `<Space>fg` | 结果进入 quickfix 窗口 |
| 打开搜索结果 | `F7` | 显示 quickfix |
| 上/下一个结果 | `[q` / `]q` | quickfix 导航 |
| 跳到定义 | `gd` | 依赖 Vim 语法或 tags 能力 |
| 查找引用近似 | `gr` | 搜索光标下单词 |
| 逐项替换近似 | `F2` 或 `<Space>rn` | 对当前单词启动 `cgn`；之后按 `.` 重复 |

项目搜索完全使用 Vim 自带 `vimgrep`，会遵守 `.vimrc` 中的 `wildignore`，默认跳过 `.git`、`node_modules`、`dist`、`build` 和常见二进制文件。它不具备 ripgrep 的速度，超大项目建议缩小 Vim 的当前目录后再搜索。

### 选择、缩进和注释

| 功能 | 快捷键 |
|---|---|
| 选择字符/行/块 | `v` / `V` / `Ctrl-V` |
| 增加/减少选区缩进 | `Tab` / `Shift-Tab` |
| 注释当前行或选区 | `Ctrl-/` 或 `<Space>/` |
| 上/下移动行或选区 | `Alt-Up` / `Alt-Down` |
| 自动补全 | 插入模式 `Ctrl-Space` 或 `Ctrl-N` |
| 补全菜单上/下选择 | `Shift-Tab` / `Tab` |

很多终端把 `Ctrl-/` 发送为 `Ctrl-_`，配置同时使用该编码；若终端不支持，`<Space>/` 始终可用。`Alt` 组合键也取决于终端模拟器。

注释标记会根据文件类型选择：C/Java/JavaScript/Go/Rust 使用 `//`，Python/Shell/YAML 使用 `#`，Vim 使用 `"`，Lua/SQL 使用 `--`，HTML/XML 使用 `<!-- -->`，CSS/SCSS 使用 `/* */`，TeX 使用 `%`。未知类型回退为 `#`。对 HTML 和 CSS 的多行选区会逐行添加完整注释对，这是零插件条件下更安全的做法，不等同于嵌套块注释插件。

### 分屏、折叠和终端

| 功能 | 快捷键 |
|---|---|
| 垂直/水平分屏 | `<Space>sv` / `<Space>sh` |
| 在窗口间移动 | `Ctrl-H/J/K/L` |
| 只保留当前窗口 | `<Space>so` |
| 调整窗口大小 | `Alt-H/J/K/L` |
| 切换当前折叠 | `<Space>z` |
| 全部折叠/展开 | `<Space>za` / `<Space>zr` |
| 打开底部终端 | `<Space>tt` |
| 终端回普通模式 | 连按两次 `Esc` |

## 5. netrw 文件树操作

光标在文件树中时，常用内置键如下：

| 按键 | 行为 |
|---|---|
| `Enter` | 打开文件或进入目录 |
| `-` | 返回上级目录 |
| `%` | 新建文件 |
| `d` | 新建目录 |
| `D` | 删除当前文件/目录（会确认） |
| `R` | 重命名 |
| `gh` | 显示/隐藏点文件 |
| `i` | 切换列表样式 |
| `q` | 关闭文件树窗口 |

这些键来自 Vim 自带 netrw，可在 Vim 中运行 `:help netrw-quickmap` 查看本机版本的准确说明。

## 6. 配色与终端

主题参考 VS Code 默认 Dark+：背景 `#1E1E1E`、前景 `#D4D4D4`、蓝色状态栏 `#007ACC`，并为字符串、注释、关键字、类型和函数设置相近颜色。配置会在以下条件下启用真彩色：

- GUI Vim；
- 环境变量 `COLORTERM=truecolor`；
- 环境变量 `COLORTERM=24bit`。

其他环境自动使用 256 色近似值。若颜色异常，可在 shell 中尝试 `export TERM=xterm-256color`；如果终端本身不支持真彩色，不要强制设置 `termguicolors`。

## 7. 与 VS Code 的差异

纯 `.vimrc` 可以很好地复刻编辑布局和按键习惯，但无法凭空提供这些 VS Code 服务：

- LSP 语义诊断与跨项目精确重命名；
- IntelliSense 语义补全；
- 图形化调试器；
- Git diff 装饰和源代码管理面板；
- 真正的模糊文件搜索和多光标。

离线机器若已有 `ctags`，可以在项目根目录执行 `ctags -R .`，之后 `Ctrl-]` 跳定义、`Ctrl-T` 返回；这会显著改善代码导航，但不是本配置的必要条件。

## 8. 常见问题

### `Ctrl-S` 后终端像卡住

某些传统终端启用了软件流控，`Ctrl-S` 会暂停输出。先按 `Ctrl-Q` 恢复，再在 shell 配置中加入：

```sh
stty -ixon
```

不想改终端时，使用 `<Space>w` 保存。

### 系统剪贴板不可用

查看 `vim --version | grep clipboard`。若是 `-clipboard`，说明这个 Vim 无法访问系统剪贴板；使用 `y`/`p` 的 Vim 内部寄存器，或通过终端自身的复制粘贴快捷键操作。SSH 会话中这很常见。

### 中文显示乱码

确保终端 locale 是 UTF-8：

```sh
locale
```

配置本身使用 UTF-8，并设置了 `encoding=utf-8`；文件编码不同时可执行 `:edit ++enc=gb18030 文件名`。

### 配置报错时定位行号

```sh
vim -Nu ~/.vimrc -n -V1vim-startup.log +'quit'
```

检查 `vim-startup.log` 中以 `Error detected` 或 `E` 加数字开头的错误。也可以暂时注释顶部对应功能开关，快速确定所属模块。
