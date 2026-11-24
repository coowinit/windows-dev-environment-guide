# Python 环境

独立虚拟环境，按项目管理依赖。

## 安装

从 https://www.python.org/downloads/windows/ 获取受支持版本的 Windows x64 安装程序，传统安装器勾选 Add python.exe to PATH。重新打开 CMD。

```cmd
python --version
py --version
where python
python -m pip --version
python -m pip install --upgrade pip
```

## 项目测试（CMD）

在一个新的空测试目录中执行；虚拟环境内 pip 与全局 pip 独立。

```cmd
mkdir D:\dev-test\python-test
cd /d D:\dev-test\python-test
python -m venv .venv
.venv\Scripts\activate
python -m pip install requests
python -c "import requests; print(requests.__version__)"
deactivate
```

## 依赖恢复

已有项目按其依赖清单安装，不提交 .venv 或 __pycache__。

```cmd
python -m pip install -r requirements.txt
```


## 安装与路径判断补充

选择项目支持的 Python 版本；本次使用 3.13.17。传统安装器保留 pip、venv 和 PATH 选项；如果使用新版安装管理器，按官方界面完成安装。安装后新开终端。`py` 启动器是否存在取决于安装方式，并非 Python 必须组件。

```powershell
where.exe python
Get-Command python -All
python -c "import sys; print(sys.executable)"
```

若出现 WindowsApps 路径，可能是 Windows 应用执行别名，不一定是第二套 Python。以 sys.executable 为准；若命令跳转商店，再检查应用执行别名及 PATH 顺序。

## PowerShell 激活及依赖备份

在项目根目录执行；虚拟环境内的 pip 与全局 pip 独立。

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -c "import sys; print(sys.executable)"
python -m pip --version
deactivate
```

若激活受限，见 [PowerShell](powershell.md)，也可以直接使用 `.\.venv\Scripts\python.exe`。

对于没有依赖清单的旧项目，可在确认激活正确环境后执行 `python -m pip freeze > requirements.txt`（CMD；PowerShell 5.1 建议用 `python -m pip freeze | Set-Content -Encoding UTF8 requirements.txt`）。已有依赖文件时不要盲目覆盖。freeze 是环境快照，不等于精简的直接依赖声明。重装后重新创建虚拟环境并安装项目依赖，不复制旧 .venv。
