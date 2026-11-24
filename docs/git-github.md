# Git 与 GitHub

恢复身份、凭据及已有仓库，不重复初始化。

## 安装

https://git-scm.com/download/win 下载 x64 Setup，选择 Git from the command line and also from 3rd-party software，保留 Git Credential Manager。

```text
git --version
where git
```

## 全局配置（CMD）

用户名和邮箱替换为自己的 GitHub 提交信息；公开仓库建议使用 GitHub noreply 邮箱。逐行执行。

```text
git config --global user.name "YOUR_NAME"
git config --global user.email "YOUR_VERIFIED_EMAIL"
git config --global init.defaultBranch main
git config --global core.editor "code --wait"
git config --global core.longpaths true
git config --global --list
```

## 身份认证

使用浏览器授权，不需要把 Token 写入配置。

```text
git config --get credential.helper
git credential-manager --version
git credential-manager github login
git credential-manager github list
```

## 已有仓库验收

进入已有仓库根目录；先检查再同步。模拟推送不修改远程，不能完全证明实际写入成功。

```text
git status
git remote -v
git fetch origin
git branch -vv
git push --dry-run origin main
```
