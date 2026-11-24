# XAMPP / PHP / MariaDB

从服务到 CLI，再到实际项目。

## 迁移与服务

本次从其他电脑复制 E:\xampp，先备份 htdocs 和数据库（优先逻辑导出，物理复制须停库且版本兼容）。启动 Apache、MySQL；访问 http://localhost/dashboard/ 和 http://localhost/phpmyadmin/。路径不同才考虑备份后运行 setup_xampp.bat。

```text
& "E:\xampp\apache\bin\httpd.exe" -t
& "E:\xampp\php\php.exe" -v
& "E:\xampp\php\php.exe" --ini
& "E:\xampp\php\php.exe" -m
```

## PATH 配置

Win+R 输入 sysdm.cpl → 高级 → 环境变量 → 用户 Path，新增 E:\xampp\php 和 E:\xampp\mysql\bin。重启终端与 VS Code。

```text
php -v
where.exe php
php --ini
mysql --version
mysqldump --version
```

## 扩展及参数

备份 php.ini 后按 configs/php/development.ini.example 修改已有项，不覆盖整个文件。启用 gd、intl、sqlite3、zip；重启 Apache。CLI 的执行时间可能与 Web 不同，使用本地 PHPInfo 核对 Web 值。

```text
php -m
php -i | Select-String '^(memory_limit|upload_max_filesize|post_max_size|max_execution_time|max_input_time|max_input_vars|date.timezone|display_errors|log_errors|error_reporting|extension_dir) =>'
```

## PHP 实测

在 E:\xampp\htdocs\php-test 创建 test.php，写入以下代码并保存。

```text
<?php
echo "PHP environment OK";
```

## 终端与浏览器

用 VS Code 打开 php-test 文件夹，新建终端执行；浏览器访问 http://localhost/php-test/test.php，应显示 PHP environment OK。故意删除分号并保存，检查问题面板，再恢复。测试完删除临时目录。

```text
php -l test.php
php test.php
```

## 兼容性与安全

PHP 8.5 本地运行不代表旧生产版本兼容。按项目设置最低 PHP 版本，恢复 WordPress 后检查后台、图片上传、插件和数据库。XAMPP 仅供本地开发，不对公网开放；PHPInfo 不公开。
