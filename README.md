# Make Vim Like VS Code

在断网 Linux 上，只安装 Vim、不安装任何第三方插件，也能获得一套接近 VS Code 的编辑体验。主配置是可复制的 [`.vimrc`](./.vimrc)，内含 Dark+ 风格配色、文件树、模糊项目文件查找、全文搜索、状态栏、缓冲区标签式操作、分屏、注释、补全、括号补全、折叠、终端和持久撤销；仓库还附带可选的 VHDL、Verilog 和 SystemVerilog 离线关键字字典。

## 快速安装

```sh
cp ~/.vimrc ~/.vimrc.backup 2>/dev/null || true
cp .vimrc ~/.vimrc
mkdir -p ~/.vim/dict
cp dict/*.dict ~/.vim/dict/
vim
```

不需要联网，不需要插件管理器，也不需要 Node.js、Python 或语言服务器。建议使用 Vim 8.0 及以上版本，以及支持 256 色或真彩色的终端。

功能开关、完整快捷键、兼容性说明和故障排查见 [中文使用说明](docs/vimrc-guide.zh-CN.md)。

## 验证配置

```sh
vim -Nu .vimrc -n -es -S tests/test_vimrc.vim
```

命令退出码为 `0` 且没有断言错误表示测试通过；过程中可能显示模拟的文件与搜索提示。测试会检查配置能否加载、关键选项和映射是否存在、注释切换是否可逆，以及文件类型缩进规则是否生效。

仓库的 GitHub Actions 也会在 Ubuntu 上自动执行同一组测试。

## 设计边界

这是以 `.vimrc` 为核心的 VS Code 工作流近似，不包含 LSP、语义补全、调试器、Git 图形界面或大型项目中的高级模糊排序。对应功能使用纯 Vimscript 文件匹配、`vimgrep`、tag 跳转、omni completion 和普通文本字典；因此可完全离线，不依赖插件管理器。
