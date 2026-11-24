# Python 环境

独立虚拟环境，按项目管理依赖。

## 安装

从 https://www.python.org/downloads/windows/ 获取受支持版本的 Windows x64 安装程序，传统安装器勾选 Add python.exe to PATH。重新打开 CMD。

```text
python --version
py --version
where python
python -m pip --version
python -m pip install --upgrade pip
```

## 项目测试（CMD）

在一个新的空测试目录中执行；虚拟环境内 pip 与全局 pip 独立。

```text
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

```text
python -m pip install -r requirements.txt
```
