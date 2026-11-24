# 重装系统后快速恢复指南

本页是操作入口，按顺序执行；遇到细节再进入专项文档。路径以本机实际情况为准，版本是实测快照而不是强制安装版本。

| 步骤 | 操作 | 验收标准 | 详细指南 |
|---|---|---|---|
| 01 | 检查数据盘、项目、备份 | 项目与 `.git` 完整，SQL 备份可读 | [备份清单](backup-checklist.md) |
| 02 | 安装 Python | python、pip、venv、requests 测试 | [Python](python.md) |
| 03 | 安装 Node.js | node、npm、npx、dayjs 测试 | [Node.js](nodejs.md) |
| 04 | 安装 Git 并认证 | 配置提交身份、检查远程、模拟推送 | [Git](git-github.md) |
| 05 | 安装 VS Code | 中文界面、13 项参考扩展、配置模板 | [VS Code](vscode.md) |
| 06 | 检查 PowerShell | npm 与虚拟环境激活成功 | [PowerShell](powershell.md) |
| 07 | 恢复 XAMPP | Apache、MariaDB、PHP 扩展、PATH、浏览器测试 | [XAMPP](xampp-php.md) |
| 08 | 恢复已有项目 | 依赖重建、数据库导入、WordPress 实际运行 | 各专项文档 |
| 09 | 自动检测并人工复核 | 检查 FAIL、WARN 和 SKIP，保留报告 | [检测指南](environment-check.md) |

## 最小终端验收（PowerShell）

逐条执行；如果 PATH 刚修改，关闭并重新启动终端与 VS Code。

```powershell
python --version
python -m pip --version
node --version
npm --version
npx --version
git --version
code --version
php -v
mysql --version
mysqldump --version
```

## 最终检查

- [ ] Python、Node.js 实际代码及依赖测试。
- [ ] Git 身份、远程地址与认证；模拟推送不等于实际推送。
- [ ] VS Code 集成终端及 PHP 保存时错误提示。
- [ ] Apache 与 MariaDB 启动、phpMyAdmin、本地 PHP 页面、Web PHP 参数核验。
- [ ] WordPress 实际项目：后台、页面、数据库、媒体上传与关键插件功能。
- [ ] 在仓库根目录运行以下检测命令，并在 report.html 导入 JSON。

```powershell
.\scripts\check-environment.ps1 -XamppRoot "E:\xampp" -CheckLocalServices -ReportDirectory "$env:TEMP\dev-environment-reports"
```

自动检测不能替代人工验收。Codex 本次安装未成功，属于可选工具，不阻塞恢复。测试完仅删除自己创建的临时项目，正式数据不要删除。
