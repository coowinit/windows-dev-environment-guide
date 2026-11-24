# 环境自动检测与报告

v1.1.0保留实机验证通过的 `1.1.0-preview.3` PowerShell 脚本，不修改其源码或报告协议。Windows PowerShell 5.1 正常环境与不存在的 XAMPP 路径已验证；PowerShell 7 仍待验证。

## 使用方法

在仓库根目录运行：

```powershell
.\scripts\check-environment.ps1 -XamppRoot "E:\xampp" -CheckLocalServices -ReportDirectory "$env:TEMP\dev-environment-reports"
```

`-XamppRoot` 按实际路径调整；`-CheckLocalServices` 为可选参数，探测默认 80/3306 TCP 端口，不鉴别服务；`-ReportDirectory` 指定输出目录，不传则只显示终端结果。脚本不安装软件、不调整系统配置、不启动服务。存在 FAIL 时退出码为 1，否则为 0（WARN 需人工复核）。

下载脚本若被 RemoteSigned 拒绝，审阅源码并确认可信后，可在个人机器上执行 `Unblock-File -LiteralPath ".\scripts\check-environment.ps1"`；不改变全局策略，不绕过组织策略。

打开 `report.html`，选择生成的 JSON。可按模块、状态和关键词筛选，打印输出完整明细（不受筛选影响）。示例已内置，可离线浏览；原始报告不上传、不持久化。分享前检查路径及诊断信息。Markdown 供人工归档。打印建议 A4、100% 缩放、关闭浏览器页眉页脚；新版打印样式仅作用于打印，不改变屏幕布局。

## 数据协议

Version、GeneratedAt、Summary、Results；每项包含 Name、Status、Detail、Advice。页面依据明细重新计算统计，支持 UTF-8 BOM，未知模块归入其他，未知状态或缺失字段拒绝导入。报告大小限制 5 MB、最多 10000 条。PASS/WARN/FAIL/SKIP 分别为通过/警告/失败/跳过。

## 实机记录与边界

2026-11-24 Windows PowerShell 5.1：preview.1 的 Apache 检测误报，preview.2 的退出码为空导致大量误报，preview.3 修复退出码作用域后获得 50 PASS、0 WARN、0 FAIL、3 SKIP。实际跳过 GitHub 实际推送、Web PHP/WordPress 验证和 Codex。PHP 模块检测限 CLI；不能替代生产环境兼容性测试。不存在的 XAMPP 路径实测 46 PASS、1 WARN、0 FAIL、4 SKIP；其他异常场景与 PowerShell 7 尚未全面验收。详见 [实测记录](validation.md)。
