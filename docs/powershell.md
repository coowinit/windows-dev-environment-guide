# PowerShell 集成

处理 npm.ps1 与虚拟环境脚本限制。

## 执行策略

如果 npm 在 CMD 正常、PowerShell 报 PSSecurityException，先检查策略。个人开发机可选择 CurrentUser RemoteSigned；组织策略不可绕过。不想改变策略时使用 npm.cmd。

```text
Get-ExecutionPolicy -List
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
npm --version
npx --version
```

## 集成终端

在 VS Code 终端执行。

```text
python -c "print('Python environment OK')"
node -e "console.log('Node.js environment OK')"
git --version
```

## 虚拟环境（PowerShell）

进入已有测试目录，若已删除则重新建立空目录。

```text
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -c "import sys; print(sys.executable)"
deactivate
```
