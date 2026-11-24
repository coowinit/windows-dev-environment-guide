# Git 与 GitHub

恢复身份、凭据及已有仓库，不重复初始化。

## 安装

https://git-scm.com/download/win 下载 x64 Setup，选择 Git from the command line and also from 3rd-party software，保留 Git Credential Manager。

```cmd
git --version
where git
```

## 全局配置（CMD）

用户名和邮箱替换为自己的 GitHub 提交信息；公开仓库建议使用 GitHub noreply 邮箱。逐行执行。

```cmd
git config --global user.name "YOUR_NAME"
git config --global user.email "YOUR_VERIFIED_EMAIL"
git config --global init.defaultBranch main
git config --global core.editor "code --wait"
git config --global core.longpaths true
git config --global --list
```

## 身份认证

使用浏览器授权，不需要把 Token 写入配置。

```cmd
git config --get credential.helper
git credential-manager --version
git credential-manager github login
git credential-manager github list
```

## 已有仓库验收

进入已有仓库根目录；先检查再同步。模拟推送不修改远程，不能完全证明实际写入成功。

```cmd
git status
git remote -v
git fetch origin
git branch -vv
git push --dry-run origin main
```


## 提交身份、认证与远程地址

| 项目 | 含义 |
|---|---|
| user.name / user.email | 提交作者信息，并非登录账号凭据 |
| init.defaultBranch | 新建仓库的默认分支，不修改已有分支 |
| core.editor | Git 需要编辑时调用 VS Code 并等待关闭 |
| core.longpaths | Git for Windows 的长路径支持选项，不改变所有应用的限制 |
| Credential Manager | 管理 HTTPS 访问凭据 |
| remote.origin.url | 当前仓库连接的远程地址 |

GitHub 账户 Settings → Emails 可检查已验证邮箱或选择 noreply 邮箱。登录与提交邮箱不要求相同。公开分享命令输出前隐藏邮箱、用户名及 URL 中可能存在的凭据。

## 认证与本地仓库恢复

安装 Git 时保留命令行 PATH、Git Credential Manager 和正常 TLS 校验；用普通用户打开终端。执行 `git credential-manager github login`，按浏览器提示选择正确账户并授权；取消时先检查 `git credential-manager github list`，再按需重试。Windows 控制面板 → 凭据管理器 → Windows 凭据可检查相关记录，不要随意删除其他应用凭据。

保留原项目及隐藏的 `.git`；不要重新 git init。先确认 `git status`、`git remote -v`、`git branch -vv`，如果使用 SSH 则按项目原有方式恢复密钥和认证，不强行换为 HTTPS。确认远程与分支后再 fetch。示例中的 main 要替换为实际分支；不要盲目 pull、reset 或强制推送。实际写入需独立验证。

`.gitconfig` 可私人备份，恢复时检查 include 路径及 credential.helper；不要复制凭据缓存或把 Token 写进 URL。
