# v1.1.0 发布前回归测试

## 自动化数据层测试

在仓库根目录执行 `node tests/report-parser.test.cjs`（不需要 npm install）。测试直接读取现有 report.js 中的解析、分类和统计函数；不覆盖 DOM、拖放、打印渲染或 PowerShell 执行。可传入本地真实报告路径作为额外参数，勿提交实际报告。

## 浏览器人工测试

打开 report.html 并逐个导入 tests/fixtures 下的模拟报告（不代表真实机器故障）。

| 文件 | 预期 |
|---|---|
| mixed-status.json | PASS 48、WARN 1、FAIL 1、SKIP 3；警告及失败各可筛选出一项 |
| summary-mismatch.json | 提示统计不一致，以实际明细重算为 48/1/1/3 |
| invalid-report.json | 拒绝导入，原报告保持不变 |

再点击重置筛选、清空、示例报告、打印预览，确认功能正常。检查窄屏布局。

## Windows 只读异常测试

不停止服务、不改 PATH、不卸载工具、不修改 Apache 配置。在仓库根目录运行：

```powershell
$missingRoot = Join-Path $env:TEMP ('xampp-missing-' + [guid]::NewGuid().ToString())
.\scripts\check-environment.ps1 -XamppRoot $missingRoot
$LASTEXITCODE
```

预期 XAMPP directory 为 WARN，Apache configuration 不执行，Local service ports 为 SKIP，其余正常工具仍通过；当前基线预计 PASS=46 WARN=1 FAIL=0 SKIP=4，退出码 0。实际数值随机器而变。随后运行正常路径命令，确认恢复到实测基线（50/0/0/3）。

本测试仅覆盖路径不存在的分支，不代表已覆盖全部非零退出码、缺失工具、端口关闭或 PowerShell 7 场景。

## 已验证记录

- Windows PowerShell 5.1 正常场景：50 PASS、0 WARN、0 FAIL、3 SKIP（用户实机）。
- 报告页面布局：用户确认符合预期。
- Node 数据层测试：13 项内置测试及 1 项真实报告测试通过。
- Windows 不存在的 XAMPP 路径：46 PASS、1 WARN、0 FAIL、4 SKIP（用户实机）。
- 混合状态 PDF 与脱敏示例 PDF 已由用户导出；统计不一致与非法导入提示仍待人工确认。
- 浏览器自动化：当前执行环境限制本地页面访问，未完成；请按上述步骤人工验证。
