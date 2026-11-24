# Windows 开发环境搭建与恢复指南

基于 2026-11-24 Windows 重装实践整理的个人开发环境手册，面向 PHP / WordPress、JavaScript、Python 与 Git 开发。重点是可复用的安装、配置、故障排查和恢复流程，而非工作站管理软件。

**v1.2.0 · 实践指南精修**

[在线指南](https://coowinit.github.io/windows-dev-environment-guide/) · [本地指南](index.html) · [报告查看器](report.html)

## 从这里开始

- [重装前备份清单](docs/backup-checklist.md)
- [重装后快速恢复指南](docs/quick-start.md)
- [环境规划与实测版本](docs/planning.md)

直接打开 index.html，无需构建或安装依赖。命令按标注的 CMD / PowerShell 环境逐条执行，路径按实际调整。GitHub Pages 可使用 main 分支根目录发布。

## 专项文档

| 内容 | 文档 |
|---|---|
| Python 与虚拟环境 | [Python](docs/python.md) |
| Node.js 与 npm | [Node.js](docs/nodejs.md) |
| Git 与 GitHub 认证、已有仓库恢复 | [Git / GitHub](docs/git-github.md) |
| VS Code 中文化、扩展、配置 | [VS Code](docs/vscode.md) |
| PowerShell 与终端 | [PowerShell](docs/powershell.md) |
| XAMPP、PHP、MariaDB、WordPress | [XAMPP / PHP](docs/xampp-php.md) |
| 真实故障与处理 | [故障排查](docs/troubleshooting.md) |

## 配置参考

[VS Code settings.json](configs/vscode/settings.json) · [13 项扩展清单](configs/vscode/extensions.txt) · [Git 模板](configs/git/gitconfig.example) · [PHP 片段](configs/php/development.ini.example)。模板不是强制标准，使用前备份，按机器和项目调整。PHP 片段只合并，不覆盖完整 php.ini。

## 辅助检测工具

[PowerShell 脚本](scripts/check-environment.ps1) · [操作说明](docs/environment-check.md) · [可视化报告](report.html) · [脱敏示例](examples/environment-report.json) · [实机验证记录](docs/validation.md)。下载完整仓库使用。保留 v1.1.0 报告查看器及已验证的 preview.3 脚本与报告协议；浏览器本地解析，不上传报告。

正常环境实测 50 PASS、0 WARN、0 FAIL、3 SKIP；不存在的 XAMPP 路径实测 46 PASS、1 WARN、0 FAIL、4 SKIP。PowerShell 7 未实机验证；Web PHP 参数逐项核验、VS Code 保存时错误提示、WordPress 实际兼容性和独立 Git 写入测试仍需人工确认。最终打印分页及两项异常导入界面提示尚待确认。Codex 暂缓。

维护者可执行 `node tests/report-parser.test.cjs`，无需 npm install。详见 [测试说明](tests/README.md)。

## 版本与维护

| 版本 | 定位 |
|---|---|
| v1.0.0 | 基础搭建指南与配置模板 |
| v1.1.0 | 自动检测、报告与回归测试 |
| v1.2.0 | 内容审校、备份清单、快速恢复指南 |
| 后续 | 按真实需要修订内容或修复缺陷 |

不再规划自动安装、自动恢复、历史报告管理平台。实测版本不是最新版推荐；项目兼容性优先。私人配置、密钥、SQL、完整 phpinfo 与实际报告放在仓库之外；公开前人工检查，.gitignore 不是安全边界。
