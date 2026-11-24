# 重装系统前备份清单

本清单是重装前的人工准备指南，不是本次已经执行的自动备份记录。备份应放在不会被格式化的磁盘和另一个独立介质中；不要只依赖同一硬盘。真实配置、网站数据及报告不得放入公开仓库。

| 检查 | 对象 | 位置示例 | 恢复原则 |
|---|---|---|---|
| [ ] | 开发项目 | `E:\projects`（实际项目路径为准） | 保留隐藏的 `.git`、未提交文件和本地分支 |
| [ ] | Python 项目 | 源码、requirements.txt 或 pyproject.toml 与锁文件 | 重建 .venv，不复制旧解释器环境 |
| [ ] | Node.js 项目 | 源码、package.json、package-lock.json | 按项目要求恢复依赖，不备份 node_modules |
| [ ] | Git | `%USERPROFILE%\.gitconfig`、其他 include 配置 | 检查路径与身份后合并；重新认证 |
| [ ] | VS Code | `%APPDATA%\Code\User\settings.json`、keybindings.json、snippets | 先备份新环境配置，再按需合并 |
| [ ] | VS Code 扩展 | vscode-extensions.txt | 记录 ID，按需重装 |
| [ ] | XAMPP | 程序目录及 Apache、PHP、MariaDB 配置 | 同版本迁移；检查绝对路径、服务与依赖 |
| [ ] | PHP | `E:\xampp\php\php.ini` | 按目标版本合并，不盲目覆盖 |
| [ ] | Apache | `E:\xampp\apache\conf` | 核对虚拟主机、证书路径、端口及 DocumentRoot |
| [ ] | MariaDB | 实际使用的 my.ini、SQL 导出 | 优先逻辑备份，验证可导入 |
| [ ] | WordPress | 网站文件、uploads、wp-config.php、数据库 SQL | 文件和数据库同批次备份，保护密码 |
| [ ] | Windows PATH | 用户和系统 PATH、工具实际路径 | 仅恢复需要且存在的目录 |
| [ ] | 登录与密钥 | GitHub、主机、SSH、API 等 | 使用安全渠道单独保管，重新认证 |

## 实用命令（PowerShell）

在私人备份目录中执行，勿在公开仓库运行导出命令：

```powershell
code --list-extensions | Set-Content -Encoding UTF8 vscode-extensions.txt
[Environment]::GetEnvironmentVariable('Path','User')
[Environment]::GetEnvironmentVariable('Path','Machine')
```

在各 Git 项目根目录使用 `git status`、`git branch -vv` 检查未提交内容与未推送提交。仅远程仓库不能替代这些本地数据的备份。数据库导出方法见 [XAMPP 专项](xampp-php.md)。

## 重装前最终确认

- [ ] 核对安装目标磁盘和分区，避免误格式化数据盘。
- [ ] 在独立介质打开几个实际文件，核对大小和目录数量；重要数据库在独立测试库验证导入。
- [ ] 确认能够登录 GitHub 等必要账户，保留双因素认证恢复方式。
- [ ] 私人配置和密钥加密存放；不要上传完整 phpinfo、数据库 SQL、Token 或真实报告。
- [ ] 记录软件版本、安装路径及项目最低运行版本。

下一步：[重装后快速恢复](quick-start.md)。
