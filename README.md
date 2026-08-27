# Make Vim Like VS Code

在断网 Linux 上，只安装 Vim、不安装任何第三方插件，也能获得一套接近 VS Code 的编辑体验。整个方案只有一个可复制的 [`.vimrc`](./.vimrc)，内含 Dark+ 风格配色、文件树、项目文件查找、全文搜索、状态栏、缓冲区标签式操作、分屏、注释、补全、括号补全、折叠、终端和持久撤销。

## 快速安装

```sh
cp ~/.vimrc ~/.vimrc.backup 2>/dev/null || true
cp .vimrc ~/.vimrc
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

这是“只有 `.vimrc`”条件下对 VS Code 工作流的近似，不包含 LSP、语义补全、调试器、Git 图形界面或真正的模糊搜索。对应功能使用 Vim 自带的文件补全、`vimgrep`、tag 跳转和 omni completion；因此可完全离线，也不会把插件文件带到目标机器。
