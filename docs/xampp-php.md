# XAMPP / PHP / MariaDB

从服务到 CLI，再到实际项目。

## 迁移与服务

本次从其他电脑复制 E:\xampp，先备份 htdocs 和数据库（优先逻辑导出，物理复制须停库且版本兼容）。启动 Apache、MySQL；访问 http://localhost/dashboard/ 和 http://localhost/phpmyadmin/。路径不同才考虑备份后运行 setup_xampp.bat。

```powershell
& "E:\xampp\apache\bin\httpd.exe" -t
& "E:\xampp\php\php.exe" -v
& "E:\xampp\php\php.exe" --ini
& "E:\xampp\php\php.exe" -m
```

## PATH 配置

Win+R 输入 sysdm.cpl → 高级 → 环境变量 → 用户 Path，新增 E:\xampp\php 和 E:\xampp\mysql\bin。重启终端与 VS Code。

```powershell
php -v
where.exe php
php --ini
mysql --version
mysqldump --version
```

## 扩展及参数

备份 php.ini 后按 configs/php/development.ini.example 修改已有项，不覆盖整个文件。启用 gd、intl、sqlite3、zip；重启 Apache。CLI 的执行时间可能与 Web 不同，使用本地 PHPInfo 核对 Web 值。

```powershell
php -m
php -i | Select-String '^(memory_limit|upload_max_filesize|post_max_size|max_execution_time|max_input_time|max_input_vars|date.timezone|display_errors|log_errors|error_reporting|extension_dir) =>'
```

## PHP 实测

在 E:\xampp\htdocs\php-test 创建 test.php，写入以下代码并保存。

```php
<?php
echo "PHP environment OK";
```

## 终端与浏览器

用 VS Code 打开 php-test 文件夹，新建终端执行；浏览器访问 http://localhost/php-test/test.php，应显示 PHP environment OK。故意删除分号并保存，检查问题面板，再恢复。测试完删除临时目录。

```powershell
php -l test.php
php test.php
```

## 兼容性与安全

PHP 8.5 本地运行不代表旧生产版本兼容。按项目设置最低 PHP 版本，恢复 WordPress 后检查后台、图片上传、插件和数据库。XAMPP 仅供本地开发，不对公网开放；PHPInfo 不公开。


## 安装及迁移条件

官方入口：https://www.apachefriends.org/ 。选择与项目兼容且来源可信的版本；本次实际采用从另一台电脑复制的 E:\xampp 完整程序目录，不代表所有版本都可以无条件复制。复制前关闭服务、备份配置及数据；目标机器应满足运行库要求，检查 Windows 服务、端口和绝对路径。路径相同时先测试；路径不同时备份后检查 setup_xampp.bat 是否适用于该发行包，不盲目执行。配置测试可显式指定根目录：

```powershell
& "E:\xampp\apache\bin\httpd.exe" -d "E:\xampp\apache" -f "E:\xampp\apache\conf\httpd.conf" -t
```

控制面板启动 Apache 与 MySQL（本次实际为 MariaDB）。默认端口 80/443/3306；自定义端口以实际配置为准。Dashboard 与 phpMyAdmin 能访问是基础验收，不等于网站数据库已恢复。不要对公网暴露本地开发服务。

## PHP 扩展和参数精修

本次 PHP CLI 中 gd、intl、sqlite3、zip 原未启用。先备份 `E:\xampp\php\php.ini`，搜索对应 `;extension=...`，去掉分号（已启用的不重复添加）。若没有配置或 DLL，先核对 PHP 发行包和扩展兼容性，不下载来源不明的 DLL。

```ini
extension=gd
extension=intl
extension=sqlite3
extension=zip
```

保存后重启 Apache，CLI 检测：

```powershell
php -m | Select-String '^(gd|intl|sqlite3|zip)$'
```

四项实机加载成功：gd 用于图片处理，intl 用于国际化，sqlite3 用于原生 SQLite 接口，zip 用于压缩文件。PDO SQLite 已有。

| 参数 | 修改前 CLI 实测 | 本地开发目标 | 作用 |
|---|---|---|---|
| memory_limit | 512M | 512M | 内存限制 |
| upload_max_filesize | 40M | 256M | 单文件上传 |
| post_max_size | 40M | 300M | 请求体上限 |
| max_input_vars | 1000 | 5000 | 表单输入数量 |
| date.timezone | Europe/Berlin | Asia/Shanghai | 默认时区 |
| max_execution_time | 0 | 300（Web） | 脚本执行时限 |
| max_input_time | -1 | 300（Web） | 输入解析时限 |
| error_reporting | 22527 | E_ALL | 错误报告 |
| log_errors | On | On | 错误日志 |
| display_errors | STDOUT（CLI） | On（Web） | 本地错误显示 |
| display_startup_errors | 未单独记录 | On（本地） | 启动错误显示 |

按 [PHP 配置片段](../configs/php/development.ini.example) 修改已有项，不能覆盖完整 php.ini。CLI 与 Web 值可能不同；通过本地 Dashboard 的 PHPInfo 检查 Loaded Configuration File、Local Value 与扩展。截图仅确认 PHPInfo 可访问，逐项 Web 核验仍需人工确认。错误显示仅限本地开发。

## PHP 项目测试详细流程

在 htdocs 创建一个新的 php-test 目录，VS Code 打开该文件夹，创建 test.php 并保存。终端 → 新建终端，确认路径为该目录，执行 `php -l test.php`（小写 L）及 `php test.php`。预期分别为 No syntax errors detected 和 PHP environment OK。Apache 启动后打开 http://localhost/php-test/test.php，显示相同文本。以上三项已实机通过。故意删除分号、保存并观察问题面板，再恢复，属于尚待独立确认的编辑器自动检测。完成后仅删除自己创建的测试目录。

## 数据库及 WordPress 恢复（建议流程，非本次实测）

优先通过 phpMyAdmin 导出 SQL，或使用与服务器兼容的 mysqldump；重要数据库备份应验证可导入。以下为 CMD 示例，替换用户名、库名与备份路径，不在命令中填写密码：

```cmd
mysqldump -u YOUR_USER -p --single-transaction YOUR_DATABASE > "D:\private-backups\site.sql"
```

先创建独立测试库，再使用对应权限账户导入（不要覆盖原生产库）：

```cmd
mysql -u YOUR_USER -p YOUR_TEST_DATABASE < "D:\private-backups\site.sql"
```

确保备份目录存在、导出命令成功，检查 SQL 文件与导入结果。`--single-transaction` 主要保证事务型表的一致性；非事务表或并发 DDL 需单独考虑停写等措施。Windows PowerShell 5.1 的重定向编码可能改变 SQL 文件，以上命令使用 CMD。

WordPress 网站文件与数据库成套恢复，核对 wp-config.php、数据库账号权限、站点 URL、固定链接、媒体、插件及主题；迁移 URL 时避免直接替换序列化数据。不要盲目覆盖 mysql/data，也不要将数据库或完整 phpinfo 上传 GitHub。生产 PHP 版本与本地 8.5 不同的项目需独立兼容测试。
