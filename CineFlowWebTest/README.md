# CineFlow Web UI 自动化测试工程

这是面向 `CineFlowWeb` 的独立 Selenium + pytest 自动化工程。接口自动化仍位于 `CineFlowAutoTest`，两套测试可以单独安装、执行和接入 CI，避免浏览器依赖影响快速接口回归。

## 已覆盖场景

- Chrome、Edge、Firefox 可配置启动，支持有界面与 headless 模式。
- 浏览器与页面冒烟检查。
- 用户登录、错误密码、空表单校验和退出登录。
- 未登录访问订单页、普通用户访问管理端的权限校验。
- 电影类型筛选、重置筛选和电影详情。
- 动态寻找可售场次和可用座位，验证座位选择与取消。
- 完整“登录—选场次—选座—创建订单—支付—退款”流程。
- 管理员控制台冒烟检查。
- 失败时自动截图并附加到 Allure 结果。
- 通过 API 做状态型订单的兜底清理，减少失败用例遗留数据。
- 登录页由专门用例真实操作；其他业务用例通过 API 注入登录态，降低重复登录造成的波动。

## 目录结构

```text
CineFlowWebTest/
├─ config/test_env.yaml       测试环境和演示账号
├─ pages/                     Page Object
├─ tests/                     pytest 测试用例
├─ utils/api_helper.py        环境检查和订单清理
├─ utils/flows.py             可复用购票流程
├─ reports/                   Allure 原始结果和失败截图
├─ conftest.py                浏览器、登录态和截图 fixture
├─ settings.py                YAML/环境变量配置加载
├─ pytest.ini
└─ requirements.txt
```

## 1. 启动被测系统

启动 FastAPI：

```powershell
cd D:\MovieTicketingAndRecommendationSystem\CineFlowAPI
.\.venv\Scripts\python.exe -m uvicorn app.main:app --reload
```

另开一个 PowerShell 启动 Vue：

```powershell
cd D:\MovieTicketingAndRecommendationSystem\CineFlowWeb
npm run dev
```

确认以下地址可以访问：

- Web：`http://127.0.0.1:5173`
- API：`http://127.0.0.1:8000/api/movies`

## 2. 安装依赖

```powershell
cd D:\MovieTicketingAndRecommendationSystem\CineFlowWebTest
py -3.12 -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
```

Selenium 4 会通过 Selenium Manager 自动匹配浏览器驱动。首次运行时需要能够访问浏览器厂商的驱动下载地址；受限网络环境可以预先安装驱动并加入 `Path`。

## 3. 运行测试

全部测试：

```powershell
.\.venv\Scripts\python.exe -m pytest -v
```

只运行冒烟：

```powershell
.\.venv\Scripts\python.exe -m pytest -m smoke -v
```

无界面 Chrome：

```powershell
.\.venv\Scripts\python.exe -m pytest --headless
```

Edge 或 Firefox：

```powershell
.\.venv\Scripts\python.exe -m pytest --browser edge
.\.venv\Scripts\python.exe -m pytest --browser firefox
```

指定环境：

```powershell
.\.venv\Scripts\python.exe -m pytest `
  --web-base-url http://127.0.0.1:5173 `
  --web-api-url http://127.0.0.1:8000/api
```

如果只想收集或调试代码、暂不检查服务状态：

```powershell
.\.venv\Scripts\python.exe -m pytest --collect-only --skip-service-check
```

## 4. 查看报告

pytest 会把 Allure 原始数据写入 `reports/allure-results`，失败截图写入 `reports/screenshots`。

安装 Allure CLI 后执行：

```powershell
allure serve reports\allure-results
```

## 5. 配置方式

默认值位于 `config/test_env.yaml`。也可以用环境变量覆盖：

```text
WEB_BASE_URL
WEB_API_URL
WEB_BROWSER
WEB_HEADLESS
WEB_TIMEOUT
WEB_TEST_USER
WEB_TEST_PASSWORD
WEB_ADMIN_USER
WEB_ADMIN_PASSWORD
```

演示账号可以保存在本地配置中，真实环境密码应通过 CI Secret 注入，不要提交到仓库。

## 6. Page Object 约定

- `pages` 只保存元素定位、等待和页面操作。
- 业务断言放在 `tests` 中，不放入 Page Object。
- 优先使用前端已有的 `data-testid`，避免绝对 XPath 和易变化的 CSS 样式类。
- Vue 异步渲染使用显式等待，不使用固定 `time.sleep()`。
- 状态型 E2E 用例带 `serial` 标记，不建议与其他购票用例并行执行。
