# PowerShell 集成

处理 npm.ps1 与虚拟环境脚本限制。

## 执行策略

如果 npm 在 CMD 正常、PowerShell 报 PSSecurityException，先检查策略。个人开发机可选择 CurrentUser RemoteSigned；组织策略不可绕过。不想改变策略时使用 npm.cmd。

```powershell
Get-ExecutionPolicy -List
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
npm --version
npx --version
```

## 集成终端

在 VS Code 终端执行。

```powershell
python -c "print('Python environment OK')"
node -e "console.log('Node.js environment OK')"
git --version
```

## 虚拟环境（PowerShell）

进入已有测试目录，若已删除则重新建立空目录。

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -c "import sys; print(sys.executable)"
deactivate
```

## 下载脚本被阻止

审阅并确认脚本可信后，使用 `Unblock-File -LiteralPath ".\scripts\check-environment.ps1"`。不要降低全局执行策略或绕过组织策略。详见 [检测工具](environment-check.md)。


## 常用命令对照

| 操作 | CMD | PowerShell |
|---|---|---|
| 查找程序 | `where python` | `where.exe python` |
| 切换磁盘与目录 | `cd /d E:\projects` | `cd E:\projects` |
| PATH | `echo %PATH%` | `$env:PATH` |
| 用户目录 | `echo %USERPROFILE%` | `$HOME` |
| 激活 venv | `.venv\Scripts\activate.bat` | `.\.venv\Scripts\Activate.ps1` |
| 外部程序退出码 | `echo %ERRORLEVEL%` | `$LASTEXITCODE` |
| 目录内容 | `dir` | `Get-ChildItem` |

`RemoteSigned` 只建议用于有此需求且允许修改策略的个人机器；CurrentUser 不需要管理员权限，不代表完整的安全边界。组织组策略优先。仅需 npm 时也可直接运行 `npm.cmd` / `npx.cmd`，无需改执行策略。

下载脚本先检查内容与来源；使用以下命令查看是否存在 Zone.Identifier，再按需解除指定文件的锁定。

```powershell
Get-Item -LiteralPath ".\scripts\check-environment.ps1" -Stream *
```

PATH 修改后要重新启动终端；VS Code 可能继承旧环境，需关闭所有窗口重新打开。环境变量中只添加目录，不添加 exe 文件。外部程序 stderr 和退出码的实际案例见 [检测工具](environment-check.md) 与 [验证记录](validation.md)。
