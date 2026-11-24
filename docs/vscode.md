# VS Code 配置

统一编辑器，精简扩展，保护历史代码。

## 安装

https://code.visualstudio.com/download 下载 Windows x64 Stable，勾选 Add to PATH 和文件夹右键菜单。普通用户运行。

```cmd
code --version
where code
code --list-extensions
```

## 扩展管理

使用 configs/vscode/extensions.txt 的 13 项清单。Ctrl+Shift+X 搜索 ID 安装；网络不稳定时逐个安装。设置同步可能恢复旧扩展，清理前暂停同步。

```cmd
code --install-extension ms-ceintl.vscode-language-pack-zh-hans
code --list-extensions
```

## 配置替换

关闭 VS Code，备份 %APPDATA%\Code\User\settings.json，再复制模板到该目录。模板 PHP 路径按机器修改。保留手动格式化与工作区信任；项目级配置优先。

## 备份扩展（CMD）

将清单保存至当前目录。

```cmd
code --list-extensions > vscode-extensions.txt
```


## 中文化与设置同步

1. 普通用户安装 VS Code，保留 Add to PATH 和右键打开文件夹选项。
2. Ctrl+Shift+X 打开扩展，搜索 `@id:ms-ceintl.vscode-language-pack-zh-hans`，安装中文语言包。
3. Ctrl+Shift+P 搜索 `Configure Display Language`，选择简体中文并按提示重启。
4. 如果开启设置同步，检查是否恢复旧扩展、主题及配置。清理前可暂停同步，不清除云端数据；验收后再决定是否启用。

本次同步恢复了历史扩展，经过人工评审，将 26 项精简为 13 项。不是所有用户都需要卸载同样的扩展。

| 扩展 | 用途 |
|---|---|
| Chinese Language Pack | 中文界面 |
| Prettier | HTML/CSS/JS/JSON 格式化 |
| PHP Intelephense | PHP 提示及格式化 |
| PHP Debug | 配合 Xdebug（本次未配置 Xdebug） |
| Python | Python 开发 |
| Pylance | Python 智能提示 |
| Python Debugger | Python 调试 |
| Python Environments | 项目环境管理 |
| PowerShell | PowerShell 编辑 |
| Live Server | 静态 HTML 预览，不解析 PHP |
| Postman | API 测试 |
| Markdown Preview Enhanced | Markdown 预览 |
| Markdown All in One | Markdown 编辑 |

完整 ID 见 [扩展清单](../configs/vscode/extensions.txt)。先检查扩展，再按需通过图形界面卸载或使用 `code --uninstall-extension 扩展ID`；不要批量移除不认识的扩展。网络不稳定时逐个安装。

## 用户配置操作与关键原则

Ctrl+Shift+P → Preferences: Open User Settings (JSON)（打开用户设置 JSON）。不是默认设置或工作区设置。先保存并关闭 VS Code，Win+R 输入 `%APPDATA%\Code\User`，备份原 settings.json；再合并或替换为 [参考模板](../configs/vscode/settings.json)，重启并检查警告。清理 Postman 临时指令位置、旧 AI 扩展设置时只删除确认无用的配置，不删除整个用户目录。

| 设置 | 目的 |
|---|---|
| editor.fontSize / lineHeight | 15 / 24，阅读舒适 |
| editor.minimap.enabled | 关闭缩略图 |
| editor.tabSize / detectIndentation | 默认 4 空格，允许识别原项目缩进 |
| files.encoding | UTF-8 |
| files.autoSave / editor.formatOnSave | 关闭，避免历史项目无意改动 |
| editor.defaultFormatter | 各语言独立指定工具 |
| search.exclude / files.watcherExclude | 排除依赖及缓存目录 |
| security.workspace.trust.untrustedFiles | prompt，保留安全确认 |
| git.confirmSync / git.enableSmartCommit | 同步确认开启，Smart Commit 关闭 |
| terminal.integrated.defaultProfile.windows | PowerShell |

PHP 路径按机器调整：

```json
{
    "php.validate.enable": true,
    "php.validate.executablePath": "E:/xampp/php/php.exe",
    "php.validate.run": "onSave"
}
```

以上仅为合并片段；不要覆盖整个 settings.json。项目 `.vscode/settings.json` 可设置目标 PHP 版本、解释器等；生产兼容性以实际服务器为准。

打开项目：文件 → 打开文件夹；终端 → 新建终端，确认当前目录。PHP 用 XAMPP 浏览器入口，不用 Live Server 解析 PHP。完整测试见 [XAMPP](xampp-php.md)。
