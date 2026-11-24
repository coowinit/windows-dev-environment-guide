# Node.js 环境

优先 LTS，使用项目级 npm 依赖。

## 安装

从 https://nodejs.org/en/download/ 下载 Windows x64 LTS MSI，保留 npm 和 PATH 组件；原生编译工具按需安装。

```text
node -v
npm -v
npx -v
where node
```

## 项目测试（CMD）

在新的空目录执行；成功输出时间并生成 package.json、package-lock.json 和 node_modules。

```text
mkdir D:\dev-test\node-test
cd /d D:\dev-test\node-test
npm init -y
npm install dayjs
node -e "console.log(require('dayjs')().format('YYYY-MM-DD HH:mm:ss'))"
```

## 恢复依赖

已有 lockfile 的项目使用 npm ci；不要提交 node_modules。

```text
npm ci
```
