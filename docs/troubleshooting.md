# 故障排查

记录真实问题，优先最小改动。

## 命令无法识别

检查 PATH 和实际安装位置，重新启动终端。两条 Git 命令粘贴成一行会报 no action specified，逐条执行。

```text
where.exe git
where.exe code
```

## VS Code 权限冲突

Another instance of Code is already running as administrator：保存文件，关闭所有 VS Code 窗口，必要时结束残留进程，以普通用户重新打开。

## 扩展下载失败

socket hang up / ECONNRESET：取消批量任务，检查网络与代理，通过图形界面逐个安装；不要关闭 TLS 校验。

```text
code --list-extensions
```

## 认证取消

User canceled device code authentication：先检查账号列表，再按需重新登录。

```text
git credential-manager github list
```

## 临时配置反复出现

设置同步或 Postman 可能重新写入旧配置和临时指令路径。备份后清理，不删除云端数据；检查扩展是否重新生成。

## 路径不存在

测试目录已删除不代表运行环境故障。重新创建空测试目录即可。

## Codex 暂缓

本次安装未成功，未纳入基础验收；不影响其他工具，后续单独研究。
