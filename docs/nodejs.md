# Node.js 环境

优先 LTS，使用项目级 npm 依赖。

## 安装

从 https://nodejs.org/en/download/ 下载 Windows x64 LTS MSI，保留 npm 和 PATH 组件；原生编译工具按需安装。

```cmd
node -v
npm -v
npx -v
where node
```

## 项目测试（CMD）

在新的空目录执行；成功输出时间并生成 package.json、package-lock.json 和 node_modules。

```cmd
mkdir D:\dev-test\node-test
cd /d D:\dev-test\node-test
npm init -y
npm install dayjs
node -e "console.log(require('dayjs')().format('YYYY-MM-DD HH:mm:ss'))"
```

## 恢复依赖

已有 lockfile 的项目使用 npm ci；不要提交 node_modules。

```cmd
npm ci
```


## 安装选项与项目文件

MSI 安装时保留 Node.js runtime、npm package manager 和 Add to PATH；原生编译工具按项目需要安装。本次使用 Node.js 24.22.3 LTS。新开终端后检查 `where.exe node`、`where.exe npm`，确认路径来自预期安装位置。

| 文件 | 用途 |
|---|---|
| package.json | 项目元数据、依赖范围、scripts |
| package-lock.json | 记录解析后的依赖版本，通常随项目提交 |
| node_modules | 实际安装依赖，不提交，重装后重建 |

`npm install` 用于添加依赖或按需安装，可能更新锁文件；`npm ci` 要求存在与 package.json 一致的锁文件，会清理现有 node_modules 后按锁文件安装。仅在确认项目需要时执行。无锁文件时按照项目说明安装。

PowerShell 若报 npm.ps1 执行限制，请参阅 [PowerShell](powershell.md)，不必重装 Node.js。
