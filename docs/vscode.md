# VS Code 配置

统一编辑器，精简扩展，保护历史代码。

## 安装

https://code.visualstudio.com/download 下载 Windows x64 Stable，勾选 Add to PATH 和文件夹右键菜单。普通用户运行。

```text
code --version
where code
code --list-extensions
```

## 扩展管理

使用 configs/vscode/extensions.txt 的 13 项清单。Ctrl+Shift+X 搜索 ID 安装；网络不稳定时逐个安装。设置同步可能恢复旧扩展，清理前暂停同步。

```text
code --install-extension ms-ceintl.vscode-language-pack-zh-hans
code --list-extensions
```

## 配置替换

关闭 VS Code，备份 %APPDATA%\Code\User\settings.json，再复制模板到该目录。模板 PHP 路径按机器修改。保留手动格式化与工作区信任；项目级配置优先。

## 备份扩展（CMD）

将清单保存至当前目录。

```text
code --list-extensions > vscode-extensions.txt
```
