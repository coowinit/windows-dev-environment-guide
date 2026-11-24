# 故障排查

记录真实问题，优先最小改动。

## 命令无法识别

检查 PATH 和实际安装位置，重新启动终端。两条 Git 命令粘贴成一行会报 no action specified，逐条执行。

```powershell
where.exe git
where.exe code
```

## VS Code 权限冲突

Another instance of Code is already running as administrator：保存文件，关闭所有 VS Code 窗口，必要时结束残留进程，以普通用户重新打开。

## 扩展下载失败

socket hang up / ECONNRESET：取消批量任务，检查网络与代理，通过图形界面逐个安装；不要关闭 TLS 校验。

```powershell
code --list-extensions
```

## 认证取消

User canceled device code authentication：先检查账号列表，再按需重新登录。

```powershell
git credential-manager github list
```

## 临时配置反复出现

设置同步或 Postman 可能重新写入旧配置和临时指令路径。备份后清理，不删除云端数据；检查扩展是否重新生成。

## 路径不存在

测试目录已删除不代表运行环境故障。重新创建空测试目录即可。

## Codex 暂缓

本次安装未成功，未纳入基础验收；不影响其他工具，后续单独研究。

## Apache 检测误报与退出码

`httpd.exe -t` 可将 Syntax OK 写到 stderr；应结合原生程序退出码判定。preview.3 修复后实机返回 Exit 0: Syntax OK。详见 [环境检测](environment-check.md)。


## 实际故障速查

| 现象 | 排查与处理 | 验收 |
|---|---|---|
| Python 出现多个路径 | 检查 WindowsApps 别名、sys.executable | 实际解释器符合预期 |
| npm.ps1 PSSecurityException | 检查执行策略；按需 CurrentUser RemoteSigned 或 npm.cmd | npm / npx 返回版本 |
| 下载 PS1 未签名 | 审阅可信脚本，检查 Zone.Identifier，仅解除该文件锁定 | 脚本正常执行 |
| VS Code 恢复旧扩展 | 暂停同步、人工精简，不清除云端数据 | 核对 13 项参考清单 |
| Postman 临时路径警告 | 备份设置后删除确认失效的指令路径 | 配置无对应警告 |
| PHP 扩展缺失 | 确认加载 php.ini，启用匹配扩展，重启 Apache | CLI 和 Web 分别核验 |
| XAMPP 复制后路径错误 | 核对 ServerRoot、配置和端口，先备份 | httpd -t、Dashboard、phpMyAdmin |
| Apache Syntax OK 却被判 WARN | stderr 不等于失败，检查实际退出码 | preview.3 实机 Exit 0 |
| 多个正常工具突然 FAIL | 检查检测脚本退出码作用域回归，不盲目重装工具 | preview.3 50 PASS / 0 FAIL |

以上包含本次实际问题与针对迁移风险的建议排查；不表示所有潜在异常都已实机复现。
