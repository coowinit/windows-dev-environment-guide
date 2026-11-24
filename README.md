# Windows 开发环境搭建与恢复指南

面向 Windows 开发工作站的标准化搭建、配置、检测、故障排查与备份恢复指南。

**v1.0.0 · 2026-11-24 实践记录**

[在线指南（GitHub Pages 启用后）](https://coowinit.github.io/windows-dev-environment-guide/) · [本地入口](index.html)

## 使用方式

直接打开 index.html，无需构建或安装依赖。GitHub Pages 选择 main 分支根目录即可发布。命令请逐条执行，并按实际路径调整。

## 专项文档

- [环境规划](docs/planning.md)
- [Python 环境](docs/python.md)
- [Node.js 环境](docs/nodejs.md)
- [Git 与 GitHub](docs/git-github.md)
- [VS Code 配置](docs/vscode.md)
- [PowerShell 集成](docs/powershell.md)
- [XAMPP / PHP / MariaDB](docs/xampp-php.md)
- [故障排查](docs/troubleshooting.md)

## 配置模板

- [VS Code settings.json](configs/vscode/settings.json)：PHP 路径按实际修改。
- [扩展清单](configs/vscode/extensions.txt)：13 个核心扩展。
- [Git 配置示例](configs/git/gitconfig.example)：不含真实身份信息。
- [PHP 配置片段](configs/php/development.ini.example)：合并使用，不覆盖完整 php.ini。

## 验收范围

已验证 Python 虚拟环境和依赖、Node.js 项目、GitHub 认证与模拟推送、VS Code 集成终端、Apache/PHP 浏览器运行、MariaDB 与 PHP CLI 扩展。Web PHP 参数逐项核验、VS Code 故意语法报错测试、WordPress 项目兼容性和实际 Git 写入仍待独立验证。Codex 暂缓。

## 后续路线

| 版本 | 规划 |
|---|---|
| v1.0.0 | HTML 指南、专项文档、配置模板 |
| v1.1.0 | 只读环境检测脚本与报告 |
| v1.2.0 | 配置备份及恢复 |
| v1.3.0 | 可选自动安装和初始化 |
| v1.4.0 | Codex 专项指南 |
| v2.0.0 | 按实际需求决定是否建设管理工具 |

## 安全与维护

版本为实测快照，不代表最新版。不要提交真实邮箱、凭据、API Key、数据库密码、完整 phpinfo 或生产数据。配置模板仅面向本地开发，更新前先备份。
