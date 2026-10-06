# CineFlow Web 自动化测试工程零基础技术文档

> 对应工程：`D:\MovieTicketingAndRecommendationSystem\CineFlowWebTest`
>
> 适合人群：第一次接触 Selenium、pytest、Page Object 和 Web 自动化测试的人。
>
> 阅读原则：先看懂整体流程，再看代码。第一次看不懂 Python 语法没有关系，先明白“每段代码负责什么”。

---

## 1. 这个工程到底是干什么的

一句话解释：

> 它用 Python 控制真实浏览器，自动打开 CineFlow 网站、输入账号、点击按钮、选择座位、创建订单、支付、退款，并自动判断结果是否正确。

平时人工测试购票流程是这样的：

```text
打开浏览器
  -> 输入网站地址
  -> 登录
  -> 选择电影
  -> 选择场次
  -> 选择座位
  -> 创建订单
  -> 支付
  -> 退款
  -> 检查每一步是否正确
```

Web 自动化就是让程序替你做这些操作：

```text
pytest 负责组织和执行测试
  -> Selenium 负责控制浏览器
  -> Page Object 负责告诉 Selenium 去哪里点、输入什么
  -> assert 负责判断实际结果是否符合预期
  -> Allure 和截图负责保存测试证据
```

这个工程不是网站本身。三个工程的关系是：

```text
CineFlowAPI
  后端服务，负责登录、电影、座位、订单、支付等接口

CineFlowWeb
  Vue 前端，负责用户看到和操作的网页

CineFlowWebTest
  Web 自动化测试，负责用浏览器验证前端和后端是否能正确配合
```

可以把它们想象成：

```text
CineFlowAPI      = 餐厅后厨
CineFlowWeb      = 餐厅前台和菜单
CineFlowWebTest  = 假装成顾客来点餐、付款并检查结果的测试员
```

---

## 2. 测试运行时，电脑里发生了什么

运行一条 Selenium 测试时，实际发生的事情是：

```text
你输入 pytest 命令
        |
        v
pytest 找到 test_*.py 文件
        |
        v
conftest.py 创建 Chrome 浏览器
        |
        v
测试用例调用 Page Object
        |
        v
Page Object 使用 data-testid 找到页面元素
        |
        v
Selenium 点击或输入
        |
        v
Vue 页面调用 FastAPI 接口
        |
        v
测试读取页面结果并执行 assert
        |
        +-- 正确：PASSED
        |
        +-- 错误：FAILED，并自动截图
        |
        v
conftest.py 关闭浏览器
```

因此，正常执行测试前必须满足三个条件：

1. FastAPI 后端已经启动。
2. Vue 前端已经启动。
3. Web 自动化工程的 Python 依赖已经安装。

少一个都不行。

---

## 3. 先认识几个必须知道的词

### 3.1 Selenium

Selenium 是浏览器控制工具。

它可以让 Python 执行这些动作：

```python
driver.get("http://127.0.0.1:5173")  # 打开网页
element.click()                       # 点击元素
element.send_keys("test_user")       # 输入文字
driver.quit()                         # 关闭浏览器
```

你可以把 Selenium 理解成一个“机械手”。它不会自己判断业务正确不正确，只负责按照代码操作浏览器。

### 3.2 WebDriver

WebDriver 是 Selenium 和浏览器之间的通信工具。

```text
Python Selenium
      |
      v
ChromeDriver
      |
      v
Chrome 浏览器
```

现在 Selenium 自带 Selenium Manager，通常写：

```python
webdriver.Chrome()
```

Selenium 就会自动寻找适合当前 Chrome 版本的驱动。

### 3.3 pytest

pytest 是 Python 测试框架。

它负责：

- 查找测试用例。
- 按顺序执行测试。
- 提供 fixture。
- 统计通过、失败和跳过数量。
- 执行测试前后的准备与清理。
- 生成测试报告数据。

pytest 默认寻找：

```text
文件名：test_*.py
函数名：test_*
```

例如：

```python
def test_login_success():
    assert 1 + 1 == 2
```

### 3.4 fixture

fixture 可以理解为“测试开始前帮你准备东西，测试结束后帮你收拾东西”。

例如浏览器 fixture：

```python
@pytest.fixture
def driver():
    browser = webdriver.Chrome()
    yield browser
    browser.quit()
```

执行顺序是：

```text
创建 Chrome
  -> yield 把 Chrome 交给测试用例
  -> 测试用例执行
  -> 回到 yield 后面
  -> 关闭 Chrome
```

### 3.5 Page Object

Page Object 是一种代码组织方式。

它的思想是：

> 一个页面写成一个 Python 类，把这个页面的元素位置和操作封装起来。

例如登录页面包含：

- 用户名输入框。
- 密码输入框。
- 登录按钮。
- 错误提示。

因此写成：

```python
class LoginPage:
    USERNAME = ...
    PASSWORD = ...
    SUBMIT = ...
    ERROR = ...

    def login(self, username, password):
        ...
```

测试用例就可以写成接近人话的形式：

```python
page.open()
page.login("test_user", "Test1234")
assert 登录成功
```

### 3.6 DOM

DOM 是浏览器眼中的页面结构。

你看到的是按钮：

```text
[登录]
```

浏览器看到的是 HTML：

```html
<button data-testid="login-submit">登录</button>
```

Selenium 必须通过 HTML 特征找到这个按钮，才能点击。

### 3.7 定位器 Locator

定位器就是“告诉 Selenium 元素在哪里”。

例如：

```python
(By.CSS_SELECTOR, '[data-testid="login-submit"]')
```

它表示：

> 请在页面中找到 `data-testid` 等于 `login-submit` 的元素。

### 3.8 data-testid

`data-testid` 是前端写在 HTML 元素上的测试专用标记。

前端代码：

```html
<button data-testid="pay-order">模拟支付</button>
```

Selenium 定位：

```python
driver.find_element(
    By.CSS_SELECTOR,
    '[data-testid="pay-order"]'
)
```

它类似于给元素贴了一张不会显示给用户的标签：

```text
这个按钮的测试名字叫 pay-order
```

使用 `data-testid` 的好处是页面颜色、文字或布局变化后，自动化代码不容易失效。

### 3.9 显式等待

Vue 页面会异步请求数据。网页打开不代表按钮已经可以点击。

错误做法：

```python
time.sleep(5)
```

这表示无论页面是否加载完成都傻等 5 秒。

项目采用显式等待：

```python
WebDriverWait(driver, 10).until(
    EC.element_to_be_clickable(locator)
)
```

意思是：

> 最多等10秒。按钮一旦可以点击，马上继续；10秒后还不行才报错。

### 3.10 Headless

Headless 表示浏览器在后台运行，不显示窗口。

```text
普通模式：你能看到 Chrome 被打开和点击
Headless：看不到窗口，但测试仍然在真实 Chrome 中执行
```

调试时推荐普通模式，CI 或批量回归时推荐 Headless。

### 3.11 assert

`assert` 是测试最终的判断。

```python
assert order.status_text("PAID") == "已支付"
```

意思是：

> 实际页面显示必须等于“已支付”，否则用例失败。

只点击、不写 assert，不算完整测试。因为程序只完成了操作，没有判断结果是否正确。

---

## 4. 工程目录逐个解释

```text
CineFlowWebTest/
├─ config/
│  └─ test_env.yaml
├─ pages/
│  ├─ base_page.py
│  ├─ login_page.py
│  ├─ home_page.py
│  ├─ movie_detail_page.py
│  ├─ seat_page.py
│  ├─ checkout_page.py
│  ├─ order_page.py
│  └─ admin_page.py
├─ tests/
│  ├─ test_browser_smoke.py
│  ├─ test_login.py
│  ├─ test_permissions.py
│  ├─ test_movie.py
│  ├─ test_seat_selection.py
│  ├─ test_purchase_flow.py
│  └─ test_admin.py
├─ utils/
│  ├─ api_helper.py
│  └─ flows.py
├─ reports/
├─ conftest.py
├─ settings.py
├─ pytest.ini
├─ requirements.txt
└─ README.md
```

### 4.1 `config/test_env.yaml`

保存默认测试环境：

```yaml
base_url: http://127.0.0.1:5173
api_url: http://127.0.0.1:8000/api
browser: chrome
headless: false
timeout: 10
```

还保存演示环境使用的普通用户和管理员账号。

这里只能保存演示账号。公司真实环境的密码不能提交到 Git，应使用环境变量或 CI Secret。

### 4.2 `settings.py`

它负责读取配置，并统一生成一个 `Settings` 对象。

以后代码不需要到处写：

```python
"http://127.0.0.1:5173"
```

而是写：

```python
settings.base_url
```

配置修改一次，所有测试都能使用新值。

配置优先级是：

```text
命令行参数
  高于
环境变量
  高于
config/test_env.yaml 默认值
```

### 4.3 `conftest.py`

这是 pytest 的公共配置中心，主要负责：

1. 增加命令行参数。
2. 读取配置。
3. 测试开始前检查前后端服务。
4. 创建 Chrome、Edge 或 Firefox。
5. 给业务测试准备普通用户或管理员登录态。
6. 测试失败时自动截图。
7. 测试结束时关闭浏览器。

它是整个 Web 自动化工程的“总管”。

### 4.4 `pages/`

这里保存 Page Object。

原则是：

```text
pages 负责“怎么操作页面”
tests 负责“操作后结果对不对”
```

### 4.5 `tests/`

这里是真正的测试用例。

每个文件按业务模块划分：

| 文件 | 覆盖内容 |
|---|---|
| `test_browser_smoke.py` | 浏览器能否打开网站 |
| `test_login.py` | 登录、错误密码、空表单、退出 |
| `test_permissions.py` | 未登录拦截、普通用户访问后台 |
| `test_movie.py` | 电影筛选和详情 |
| `test_seat_selection.py` | 选择、取消选择座位 |
| `test_purchase_flow.py` | 创建订单、支付、退款完整流程 |
| `test_admin.py` | 管理员控制台 |

### 4.6 `utils/api_helper.py`

它不是用来代替 Selenium 测试页面的。

它负责辅助工作：

- 检查 Web 和 API 是否启动。
- 通过接口快速登录。
- 用例失败后取消或退款测试订单。

### 4.7 `utils/flows.py`

它封装跨多个页面的公共业务流程。

例如寻找可购买座位：

```text
打开首页
  -> 收集电影详情地址
  -> 逐个查看电影
  -> 查找可售场次
  -> 打开座位页
  -> 找到第一个有可用座位的场次
```

如果每个购票测试都重新写这一大段代码，会产生大量重复，因此放入 `flows.py`。

### 4.8 `reports/`

保存测试输出：

```text
reports/allure-results  Allure原始数据
reports/screenshots     失败截图
```

### 4.9 `requirements.txt`

记录工程需要的 Python 依赖：

```text
selenium       控制浏览器
pytest         执行测试
PyYAML         读取YAML配置
requests       调用辅助接口
allure-pytest  生成Allure结果
```

### 4.10 `pytest.ini`

告诉 pytest：

- 测试文件在哪。
- 测试文件和函数如何命名。
- Allure 结果写到哪里。
- 项目有哪些 marker。

marker 是测试标签：

```text
smoke       冒烟测试
regression  回归测试
e2e         端到端测试
serial      有状态、不要并行的测试
```

---

## 5. 为什么接口自动化和 Web 自动化要分开

当前有两个测试工程：

```text
CineFlowAutoTest  接口自动化
CineFlowWebTest   Web自动化
```

分开的原因：

| 接口自动化 | Web 自动化 |
|---|---|
| 直接发送 HTTP 请求 | 启动真实浏览器 |
| 速度快 | 速度相对慢 |
| 不依赖页面 | 依赖前端页面 |
| 适合大量边界和异常 | 适合关键用户流程 |
| 容易定位后端问题 | 能发现前后端集成和页面问题 |

如果混在一起，运行一个简单接口用例也可能被迫安装 Chrome 和驱动，会让依赖、执行速度和 CI 配置都变得混乱。

---

## 6. 第一次运行：一步一步照着做

不要一次输入所有命令。按照下面的顺序执行，每一步成功后再继续。

### 第一步：启动 FastAPI

打开第一个 PowerShell：

```powershell
cd D:\MovieTicketingAndRecommendationSystem\CineFlowAPI
.\.venv\Scripts\python.exe -m uvicorn app.main:app --reload
```

看到类似内容表示成功：

```text
Uvicorn running on http://127.0.0.1:8000
Application startup complete
```

浏览器访问：

```text
http://127.0.0.1:8000/docs
```

能看到 Swagger 接口文档，说明后端已启动。

这个 PowerShell 不要关闭。

### 第二步：启动 Vue

打开第二个 PowerShell：

```powershell
cd D:\MovieTicketingAndRecommendationSystem\CineFlowWeb
npm run dev
```

看到类似内容表示成功：

```text
Local: http://127.0.0.1:5173/
```

浏览器访问：

```text
http://127.0.0.1:5173
```

能看到 CineFlow 首页，说明前端已启动。

这个 PowerShell也不要关闭。

### 第三步：进入 Web 测试工程

打开第三个 PowerShell：

```powershell
cd D:\MovieTicketingAndRecommendationSystem\CineFlowWebTest
```

### 第四步：创建独立虚拟环境

如果系统能使用 `python`：

```powershell
python -m venv .venv
```

如果你使用 Anaconda，也可以：

```powershell
D:\Anaconda\python.exe -m venv .venv
```

虚拟环境可以理解为这个项目自己的 Python 工具箱，不会把依赖乱装到其他工程里。

### 第五步：安装依赖

```powershell
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
```

安装结束后检查：

```powershell
.\.venv\Scripts\python.exe -c "import selenium, pytest; print('安装成功')"
```

如果输出：

```text
安装成功
```

说明依赖没有问题。

### 第六步：先收集用例，不启动浏览器

```powershell
.\.venv\Scripts\python.exe -m pytest --collect-only --skip-service-check -q
```

正常情况下能看到11个用例。

这一步只是检查 pytest 能否找到用例，不会真正点击网页。

### 第七步：运行一个最简单的冒烟用例

```powershell
.\.venv\Scripts\python.exe -m pytest tests\test_browser_smoke.py -v
```

你会看到 Chrome 被打开，访问首页，然后自动关闭。

成功结果类似：

```text
tests/test_browser_smoke.py::test_browser_can_open_cineflow PASSED
```

### 第八步：运行全部用例

有界面模式：

```powershell
.\.venv\Scripts\python.exe -m pytest -v
```

无界面模式：

```powershell
.\.venv\Scripts\python.exe -m pytest --headless -q
```

本工程已经实测：

```text
11 passed in 57.18s
```

不同电脑的执行时间会不同，耗时不是固定值。

---

## 7. 第一个用例到底怎么运行

打开：

```text
tests/test_browser_smoke.py
```

核心代码：

```python
@pytest.mark.smoke
def test_browser_can_open_cineflow(driver, settings):
    page = HomePage(driver, settings.base_url, settings.timeout).open()

    assert "CineFlow" in page.visible(page.LOGO).text
    assert page.movie_cards(), "演示环境中没有可展示的电影"
```

逐句解释。

### `@pytest.mark.smoke`

给用例贴上“冒烟测试”标签。

以后可以只运行冒烟：

```powershell
pytest -m smoke
```

### `def test_browser_can_open_cineflow(driver, settings)`

定义测试函数。

`driver` 和 `settings` 不需要手动创建，pytest 会去 `conftest.py` 中寻找同名 fixture。

可以理解为 pytest 自动帮你做了：

```python
driver = 创建Chrome浏览器()
settings = 读取配置文件()
```

### `HomePage(...).open()`

创建首页 Page Object，然后打开首页并等待加载完成。

### 第一个 assert

```python
assert "CineFlow" in page.visible(page.LOGO).text
```

检查页面 Logo 中是否包含 `CineFlow`。

### 第二个 assert

```python
assert page.movie_cards()
```

检查页面至少存在一张电影卡片。

如果是空列表，pytest 会让用例失败并显示：

```text
演示环境中没有可展示的电影
```

---

## 8. BasePage 是什么，为什么所有页面都继承它

`BasePage` 是所有 Page Object 的公共父类。

登录页、首页、选座页都会做这些重复动作：

- 打开页面。
- 等待元素出现。
- 等待元素可以点击。
- 点击。
- 输入。
- 读取文字。
- 等待加载结束。

如果每个页面都重新写一遍，会产生大量重复代码。

因此把通用动作集中到：

```text
pages/base_page.py
```

### 8.1 `testid()`

```python
@staticmethod
def testid(value: str):
    return By.CSS_SELECTOR, f'[data-testid="{value}"]'
```

调用：

```python
BasePage.testid("login-submit")
```

得到：

```python
(By.CSS_SELECTOR, '[data-testid="login-submit"]')
```

这样不用在每个页面重复写完整 CSS 选择器。

### 8.2 `visible()`

```python
def visible(self, locator):
    return self.wait.until(
        EC.visibility_of_element_located(locator)
    )
```

意思是等待元素存在并且用户能看见。

### 8.3 `clickable()`

```python
def clickable(self, locator):
    return self.wait.until(
        EC.element_to_be_clickable(locator)
    )
```

不仅要存在，还必须可以点击。

### 8.4 `fill()`

```python
def fill(self, locator, value):
    element = self.visible(locator)
    element.clear()
    element.send_keys(value)
```

执行顺序：

```text
等待输入框出现
  -> 清空旧内容
  -> 输入新内容
```

### 8.5 `click_element()`

项目先滚动到元素，然后正常点击。

如果固定头部或CSS动画短暂挡住元素，捕获 `ElementClickInterceptedException` 后使用 JavaScript 点击作为兜底。

### 8.6 `open_path()`

它负责拼接网站地址。

```python
open_path("/login")
```

最终打开：

```text
http://127.0.0.1:5173/login
```

如果已经在同一个 Vue 网站内，则使用浏览器脚本进行站内跳转，避免无关图片资源长时间阻塞 Selenium。

---

## 9. LoginPage 是怎么工作的

登录页面定义了四个主要元素：

```python
USERNAME = BasePage.testid("login-username")
PASSWORD = BasePage.testid("login-password")
SUBMIT = BasePage.testid("login-submit")
ERROR = BasePage.testid("login-error")
```

它们对应前端 HTML：

```html
<input data-testid="login-username" />
<input data-testid="login-password" />
<button data-testid="login-submit">登录</button>
<p data-testid="login-error">用户名或密码错误</p>
```

登录操作：

```python
def login(self, username, password):
    self.fill(self.USERNAME, username)
    self.fill(self.PASSWORD, password)
    self.click(self.SUBMIT)
    return self
```

翻译成人话：

```text
在用户名输入框输入用户名
  -> 在密码输入框输入密码
  -> 点击登录按钮
```

为什么返回 `self`？

因为这样可以连续调用：

```python
page.login(username, password).wait_for_login_success()
```

这叫链式调用。

---

## 10. 为什么不是每个用例都从登录页面开始

登录页面本身已经有专门测试：

- 正确登录并退出。
- 错误密码。
- 空用户名和空密码。

电影、权限、选座、支付等测试的目标不是再次验证登录页面。如果每个用例都重复走登录：

- 测试更慢。
- 登录接口偶发波动会导致所有业务用例失败。
- 发生失败时难以判断是登录坏了，还是购票坏了。

因此工程采用：

```text
登录功能测试
  -> 真实操作登录页面

其他已登录业务测试
  -> 通过API获得Token
  -> 写入浏览器localStorage
  -> 直接开始目标业务
```

代码位于 `conftest.py`：

```python
def _set_authenticated_state(driver, settings, username, password):
    login = ApiHelper(settings.api_url).login_result(username, password)
    driver.get(settings.base_url)
    driver.execute_script(
        "localStorage.setItem('cineflow_token', arguments[0]);"
        "localStorage.setItem('cineflow_user', JSON.stringify(arguments[1]));",
        login["token"],
        login["user"],
    )
    driver.refresh()
```

这不是作弊，而是自动化测试常用的“通过接口准备测试状态”。

前提是登录页面必须有自己的独立测试，不能完全不测登录UI。

---

## 11. driver、user_driver 和 admin_driver 有什么区别

### `driver`

普通的全新浏览器，没有登录。

适合：

- 登录页面测试。
- 未登录权限测试。
- 首页公开内容测试。

### `user_driver`

已经写入普通用户登录状态的浏览器。

适合：

- 选座。
- 创建订单。
- 支付和退款。
- 普通用户访问后台的权限验证。

### `admin_driver`

已经写入管理员登录状态的浏览器。

适合：

- 管理员控制台。
- 电影、影院和场次管理。

测试函数需要什么状态，就在参数里写什么 fixture：

```python
def test_guest(driver):
    ...

def test_user(user_driver):
    ...

def test_admin(admin_driver):
    ...
```

---

## 12. 完整购票测试逐步解释

文件：

```text
tests/test_purchase_flow.py
```

业务流程：

```text
普通用户登录态
  -> 找到有可用座位的场次
  -> 选择第一个可用座位
  -> 锁定座位
  -> 进入结算页
  -> 创建订单
  -> 检查待支付状态
  -> 支付
  -> 检查已支付状态
  -> 退款
  -> 检查已退款状态
  -> 最终兜底清理
```

### 12.1 查找可购买场次

```python
checkout = start_checkout(user_driver, settings)
```

内部会遍历电影和场次，直到找到有 `AVAILABLE` 座位的场次。

没有可用数据时：

```python
pytest.skip("当前演示数据没有可售场次或可用座位")
```

为什么跳过而不是失败？

因为“环境当前没有可售场次”不一定代表自动化代码或产品功能错误。它属于测试前置数据不满足。

### 12.2 检查选择的座位

```python
assert checkout.selected_seats().strip()
```

确保结算页真的显示了座位，不能空着创建订单。

### 12.3 创建订单

```python
checkout.set_agreement(True).submit_order()
```

先勾选购票须知，再提交订单。

### 12.4 检查待支付状态

```python
assert order.status_text("PENDING_PAYMENT") == "待支付"
```

页面必须显示“待支付”。

### 12.5 支付并检查

```python
order.pay()
assert order.status_text("PAID") == "已支付"
assert "支付成功" in order.success_message()
```

这里同时检查：

- 状态变成已支付。
- 页面出现支付成功提示。

### 12.6 退款并检查

```python
order.refund()
assert order.status_text("REFUNDED") == "已退款"
assert "退款成功" in order.success_message()
```

退款按钮会先打开确认弹窗，Page Object 会点击确认按钮，再等待退款状态出现。

### 12.7 为什么使用 `finally`

```python
try:
    执行支付和退款
finally:
    cleanup_order(...)
```

`finally` 的意思是：

> 不管前面成功还是失败，最后都尽量执行订单清理。

如果测试在支付后失败，没有清理就可能留下已支付测试订单或被占用座位，影响下一次测试。

---

## 13. 11个用例分别在测什么

### 13.1 浏览器冒烟

```text
test_browser_can_open_cineflow
```

检查：

- 网站可以打开。
- Logo存在。
- 至少有一张电影卡片。

### 13.2 登录成功并退出

```text
test_user_can_login_and_logout
```

检查：

- 可以输入正确账号密码。
- 登录后出现用户菜单。
- 退出后重新出现登录入口。

### 13.3 错误密码

```text
test_wrong_password_shows_business_error
```

检查页面是否显示“用户名或密码错误”。

### 13.4 空登录表单

```text
test_empty_login_form_shows_field_errors
```

检查是否同时提示：

```text
请输入用户名
请输入密码
```

### 13.5 未登录访问订单页

```text
test_guest_is_redirected_to_login_for_orders
```

检查：

- 自动跳转登录页。
- URL保留 `redirect=/orders`。

### 13.6 普通用户访问后台

```text
test_normal_user_cannot_open_admin
```

检查普通用户是否进入403页面，而不是看到管理员内容。

### 13.7 按类型筛选电影

```text
test_filter_movies_by_genre
```

输入“科幻”，检查筛选结果都包含“科幻”，再点击重置。

### 13.8 打开电影详情

```text
test_open_movie_detail
```

检查电影详情页能打开且电影名不为空。

### 13.9 选择并取消座位

```text
test_available_seat_can_be_selected_and_unselected
```

检查可用座位能选中，再次点击能取消。

### 13.10 完整购票流程

```text
test_purchase_pay_and_refund_full_flow
```

验证创建订单、支付和退款完整业务状态。

### 13.11 管理员控制台

```text
test_admin_can_open_dashboard
```

检查管理员能进入控制台，并看到API服务、电影和影院指标。

---

## 14. 常用运行命令

以下命令都要在：

```text
D:\MovieTicketingAndRecommendationSystem\CineFlowWebTest
```

目录执行。

### 全部测试

```powershell
.\.venv\Scripts\python.exe -m pytest -v
```

### Headless全部测试

```powershell
.\.venv\Scripts\python.exe -m pytest --headless -q
```

### 只运行冒烟

```powershell
.\.venv\Scripts\python.exe -m pytest -m smoke -v
```

### 只运行回归

```powershell
.\.venv\Scripts\python.exe -m pytest -m regression -v
```

### 只运行完整购票

```powershell
.\.venv\Scripts\python.exe -m pytest tests\test_purchase_flow.py -v
```

### 只运行某个函数

```powershell
.\.venv\Scripts\python.exe -m pytest `
  tests\test_login.py::test_wrong_password_shows_business_error `
  -v
```

### 使用Edge

```powershell
.\.venv\Scripts\python.exe -m pytest --browser edge -v
```

### 使用Firefox

```powershell
.\.venv\Scripts\python.exe -m pytest --browser firefox -v
```

### 首次调试时显示输出

```powershell
.\.venv\Scripts\python.exe -m pytest -v -s
```

`-s` 表示不捕获程序打印内容。

### 失败后立即停止

```powershell
.\.venv\Scripts\python.exe -m pytest -x -v
```

### 只重新运行上次失败用例

```powershell
.\.venv\Scripts\python.exe -m pytest --lf -v
```

---

## 15. 测试失败后应该先看什么

按这个顺序排查：

### 第一步：看失败类型

常见类型：

```text
ConnectionError          服务没启动或地址错误
NoSuchElementException   找不到元素
TimeoutException         等待条件超时
ElementClickIntercepted  元素被遮挡
AssertionError           实际结果不符合预期
SessionNotCreated        浏览器或驱动启动失败
```

### 第二步：看失败截图

目录：

```text
CineFlowWebTest\reports\screenshots
```

截图能帮助判断：

- 页面是否打开。
- 是否停在登录页。
- 是否有错误弹窗。
- 按钮是否被遮挡。
- 页面是否一直加载。

### 第三步：看当前URL

失败URL会附加到 Allure 结果。

例如预期订单页却停在：

```text
http://127.0.0.1:5173/login
```

说明问题可能是登录态失效，而不是订单按钮定位错误。

### 第四步：手工复现

使用同一账号、同一环境，在浏览器中手工执行相同步骤。

如果手工也失败，倾向于产品或环境问题。

如果手工成功、自动化失败，重点检查：

- 定位器。
- 等待条件。
- 测试数据。
- 页面遮挡。
- 用例之间的状态污染。

---

## 16. 常见报错和解决办法

### 16.1 `No module named selenium`

原因：当前 Python 没安装 Selenium，或者用了错误的 Python。

解决：

```powershell
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
```

检查：

```powershell
.\.venv\Scripts\python.exe -c "import selenium; print(selenium.__version__)"
```

### 16.2 `CineFlowWeb is unavailable`

原因：Vue 没启动。

解决：

```powershell
cd D:\MovieTicketingAndRecommendationSystem\CineFlowWeb
npm run dev
```

### 16.3 `CineFlowAPI is unavailable`

原因：FastAPI 没启动或端口不正确。

解决：

```powershell
cd D:\MovieTicketingAndRecommendationSystem\CineFlowAPI
.\.venv\Scripts\python.exe -m uvicorn app.main:app --reload
```

### 16.4 `SessionNotCreatedException`

常见原因：

- Chrome没有正确安装。
- Chrome与驱动版本不兼容。
- Selenium Manager无法联网下载驱动。
- 浏览器进程残留或用户目录被占用。

项目为每条用例创建临时浏览器 Profile，减少用户目录冲突。

### 16.5 `TimeoutException`

它只表示“等待的条件在规定时间内没有满足”，不等于一定是网络慢。

可能原因：

- 页面没打开。
- 定位器写错。
- 接口失败，目标元素根本没出现。
- 登录态失效跳到其他页面。
- 测试数据不存在。

不要第一反应把10秒改成60秒。先看截图和URL。

### 16.6 `ElementClickInterceptedException`

意思是元素存在，但被其他元素挡住了。

项目会先滚动到元素中间；如果仍被短暂CSS动画或固定头部挡住，会使用JavaScript点击兜底。

如果遮挡是产品真实问题，例如弹窗挡住按钮，就不应该用兜底掩盖，而应修复页面或先关闭弹窗。

### 16.7 测试显示乱码

检查：

- 文件是否使用 UTF-8 保存。
- PowerShell终端编码。
- 数据库字符集。
- Python运行环境是否正确。

### 16.8 Selenium访问本机服务却返回502

有些电脑设置了系统代理，可能把 `localhost` 请求错误地转发到代理服务器。

工程会自动把：

```text
localhost
127.0.0.1
```

加入 `NO_PROXY`，并让辅助 requests Session 不读取系统代理。

---

## 17. Allure 报告怎么看

pytest 执行后会生成：

```text
reports/allure-results
```

这只是原始数据，不是网页报告。

安装 Allure CLI 后执行：

```powershell
allure serve reports\allure-results
```

报告中可以查看：

- 测试通过和失败数量。
- 每条用例耗时。
- 失败堆栈。
- 失败截图。
- 失败时的页面URL。

如果没有安装 Allure CLI，也不影响 pytest 执行，只是不能打开漂亮的 HTML 报告。

---

## 18. 怎样新增一个简单测试

假设要测试“点击导航栏订单入口进入订单页”。

### 第一步：确认前端有稳定标记

前端：

```html
<a data-testid="nav-orders">我的订单</a>
```

### 第二步：决定放在哪个Page Object

它属于公共导航，也可以暂时通过 `BasePage` 操作：

```python
base.click(base.testid("nav-orders"))
```

如果公共导航操作越来越多，应该新建 `HeaderComponent`，不要把所有操作都塞进 `BasePage`。

### 第三步：写测试

```python
def test_user_can_open_orders(user_driver, settings):
    page = BasePage(user_driver, settings.base_url, settings.timeout)

    page.click(page.testid("nav-orders"))
    page.wait_url_contains("/orders")

    assert page.visible(page.testid("orders-page")).is_displayed()
```

### 第四步：单独运行

```powershell
.\.venv\Scripts\python.exe -m pytest `
  tests\test_orders.py::test_user_can_open_orders `
  -v
```

### 第五步：再运行相关回归

单用例通过后，再运行订单模块和完整回归。

---

## 19. 怎样新增一个Page Object

假设要增加注册页面。

新建：

```text
pages/register_page.py
```

示例：

```python
from pages.base_page import BasePage


class RegisterPage(BasePage):
    PAGE = BasePage.testid("register-page")
    USERNAME = BasePage.testid("register-username")
    PHONE = BasePage.testid("register-phone")
    EMAIL = BasePage.testid("register-email")
    PASSWORD = BasePage.testid("register-password")
    SUBMIT = BasePage.testid("register-submit")

    def open(self):
        self.open_path("/register")
        self.visible(self.PAGE)
        return self

    def register(self, username, phone, email, password):
        self.fill(self.USERNAME, username)
        self.fill(self.PHONE, phone)
        self.fill(self.EMAIL, email)
        self.fill(self.PASSWORD, password)
        self.click(self.SUBMIT)
        return self
```

再新建：

```text
tests/test_register.py
```

测试断言放在测试文件中，不要直接放进 Page Object。

---

## 20. Page Object 编写规则

### 推荐做法

```python
class OrderPage(BasePage):
    PAY = BasePage.testid("pay-order")

    def pay(self):
        self.click(self.PAY)
        return self
```

测试：

```python
order.pay()
assert order.status_text("PAID") == "已支付"
```

### 不推荐做法

```python
class OrderPage(BasePage):
    def pay_and_assert_success(self):
        self.click(...)
        assert self.text(...) == "已支付"
```

为什么不推荐？

因为页面对象应该负责提供操作和读取结果，测试用例负责判断业务是否正确。两者混在一起会降低复用性。

### 方法名称应该表达业务动作

推荐：

```python
login()
select_first_available()
submit_order()
pay()
refund()
```

不推荐：

```python
click_button_1()
click_blue_button()
do_step_3()
```

颜色或步骤编号变化后，方法名就失去意义。

---

## 21. 为什么不应该大量使用XPath

绝对 XPath：

```python
/html/body/div[1]/main/div/div[2]/button
```

页面多增加一层 `div`，定位就可能失效。

当前工程优先使用：

```python
[data-testid="create-order-submit"]
```

如果必须使用 XPath，应尽量使用相对且有业务含义的写法，而不是完整 DOM 路径。

---

## 22. 为什么选座和购票用例不能随便并行

购票会改变系统状态：

```text
座位 AVAILABLE
  -> LOCKED
  -> SOLD
  -> 退款后 AVAILABLE
```

如果两个用例同时选择同一个座位，它们可能互相干扰。

因此完整购票用例标记：

```python
@pytest.mark.serial
```

当前 marker 是分类说明。如果以后使用 `pytest-xdist` 并行执行，还需要在 CI 或并行调度规则中明确让 `serial` 用例单独运行。

不要看到 pytest 支持并行，就直接把所有 Web 用例都并行。

---

## 23. 测试数据为什么很重要

Web 自动化经常不是代码坏了，而是数据不满足。

完整购票需要：

- 有可售电影。
- 电影有未来场次。
- 场次状态为 `ON_SALE`。
- 场次至少有一个 `AVAILABLE` 座位。
- 普通测试账号可登录。

工程不写死电影ID、场次ID和座位ID，而是动态寻找可用数据。

这样比写死：

```python
movie_id = 2001
schedule_id = 4001
seat_id = 5001
```

更稳定，因为固定座位可能已经售出或场次已经过期。

---

## 24. 冒烟、回归和E2E的区别

### 冒烟测试 smoke

目的：快速判断系统是否具备继续测试的基本条件。

例如：

- 网站能打开。
- 用户能登录。
- 电影详情能打开。
- 管理员控制台能打开。

### 回归测试 regression

目的：版本修改后，检查已有功能是否被破坏。

例如：

- 错误密码。
- 空表单。
- 权限拦截。
- 电影筛选。
- 座位选择和取消。

### 端到端测试 e2e

目的：从用户入口开始，验证跨多个页面和接口的完整流程。

例如：

```text
登录 -> 电影 -> 场次 -> 座位 -> 订单 -> 支付 -> 退款
```

E2E价值高，但速度慢、依赖多，因此不应该把所有边界场景都写成E2E。

---

## 25. 当前工程的实际数据

截至本文档生成时：

```text
Web自动化用例：11个
业务Page Object：7个
公共BasePage：1个
支持浏览器配置：Chrome、Edge、Firefox
真实验证浏览器：Chrome Headless
最近一次完整结果：11 passed
最近一次完整耗时：57.18秒
```

“支持浏览器配置”和“已经全部实测”不是同一个概念。

当前可以说：

> 工程支持 Chrome、Edge 和 Firefox 配置，已在 Chrome Headless 环境完成11个用例全量验证。

不要说：

> 三种浏览器已经全部兼容验证通过。

除非你真的分别执行并保存了三种浏览器的报告。

---

## 26. 面试时怎么介绍这个工程

### 30秒版本

> 我使用 Python、pytest 和 Selenium WebDriver 搭建了独立的 Web UI 自动化工程，采用 Page Object 分层，将通用等待和点击封装在 BasePage，将登录、电影、选座、结算、订单和管理端分别封装为页面对象。元素优先使用 data-testid 定位，并通过显式等待处理 Vue 异步渲染。目前共有11个用例，覆盖登录、权限、电影筛选、选座、购票、支付退款和管理端，已在 Chrome Headless 环境全部通过。

### 详细版本

> 框架中 conftest.py 负责多浏览器创建、配置读取、服务检查、登录态注入和失败截图。登录页面由独立用例真实验证，其他业务用例通过接口获取 Token 并写入 localStorage，减少重复登录带来的波动。完整购票用例会动态寻找可售场次和可用座位，完成创建订单、支付和退款，并通过 finally 调用接口进行兜底清理。工程支持 Allure 原始结果、失败截图、Headless以及 Chrome、Edge、Firefox参数化执行。

### 面试官问“为什么使用Page Object”

> 为了分离页面结构和测试业务。元素定位集中在 Page Object，测试用例只描述业务流程和断言。页面元素修改时通常只需要调整对应页面类，避免多个测试重复修改。

### 面试官问“为什么使用data-testid”

> CSS类主要服务样式，文本可能变化，绝对XPath又依赖DOM层级。data-testid是前端与测试约定的稳定定位标识，可以降低页面改版造成的自动化维护成本。

### 面试官问“为什么不用sleep”

> 固定sleep太短会不稳定，太长会浪费时间。显式等待会轮询具体条件，例如元素可见、可点击或URL变化，条件满足后立即继续。

### 面试官问“为什么其他业务用例不走UI登录”

> 登录功能已经由专门用例覆盖。其他业务用例通过API创建登录状态，可以减少重复步骤、提升速度并降低登录波动对业务用例的影响，同时让失败更容易定位到目标模块。

---

## 27. 推荐学习顺序

不要一开始就研究完整购票流程。按下面顺序学习：

### 第一阶段：会运行

1. 启动API。
2. 启动Vue。
3. 安装Web测试依赖。
4. 运行浏览器冒烟。
5. 运行登录测试。

### 第二阶段：会看代码

1. 看 `test_browser_smoke.py`。
2. 看 `login_page.py`。
3. 看 `base_page.py`。
4. 看 `conftest.py` 中的 driver fixture。
5. 看 `test_login.py`。

### 第三阶段：会改代码

1. 修改超时时间。
2. 增加一个简单页面断言。
3. 新增一个 `data-testid` 定位。
4. 新增一个测试函数。
5. 故意写错断言，观察失败截图。

### 第四阶段：理解完整流程

1. 看 `flows.py` 如何寻找数据。
2. 看 `seat_page.py` 如何选座。
3. 看 `checkout_page.py` 如何下单。
4. 看 `order_page.py` 如何支付退款。
5. 看 `test_purchase_flow.py` 如何组合页面并清理数据。

---

## 28. 建议亲手完成的练习

### 练习1：让错误密码测试失败一次

把：

```python
assert "用户名或密码错误" in page.error_message()
```

临时改成：

```python
assert "登录成功" in page.error_message()
```

运行后观察：

- pytest失败信息。
- `reports/screenshots`。
- Allure原始结果。

观察完再改回来。

### 练习2：增加一个首页标题断言

在浏览器冒烟测试中增加：

```python
assert "CineFlow" in driver.title
```

如果实际页面标题不是这个值，根据真实标题调整。

### 练习3：增加订单页导航测试

使用 `user_driver` 点击 `nav-orders`，验证 `orders-page` 出现。

### 练习4：用有界面和Headless分别运行

有界面：

```powershell
pytest tests\test_login.py -v
```

无界面：

```powershell
pytest tests\test_login.py --headless -v
```

比较两种模式的体验和速度。

### 练习5：分别运行marker

```powershell
pytest -m smoke -v
pytest -m regression -v
pytest -m e2e -v
```

观察每组用例数量和用途。

---

## 29. 最容易产生的错误理解

### 错误理解1：Selenium就是测试框架

不完全正确。

```text
Selenium 负责操作浏览器
pytest 负责组织和执行测试
```

### 错误理解2：能点击成功就算测试通过

不正确。必须有断言判断结果。

### 错误理解3：Page Object就是每个页面写一个测试

不正确。

```text
Page Object 是页面操作层
test_*.py 是测试用例层
```

### 错误理解4：data-testid会显示在页面上

不会。它只存在于HTML结构中，用户看不到。

### 错误理解5：Headless不是真实浏览器

Headless仍然是真实浏览器引擎，只是不显示窗口。

### 错误理解6：等待时间越长越稳定

不一定。定位器错误时，等60秒也不会出现。稳定性来自正确的条件、数据隔离和清晰的页面状态，不只是加长时间。

### 错误理解7：UI自动化越多越好

不一定。大量边界测试更适合接口层，Web自动化应该优先覆盖用户关键流程和页面集成。

---

## 30. 一张最终记忆图

只需要记住下面这张关系图：

```text
测试用例 tests/
  负责：我要验证什么，结果应该是什么
        |
        v
页面对象 pages/
  负责：页面元素在哪里，应该怎么操作
        |
        v
BasePage
  负责：等待、点击、输入、读取、跳转等公共动作
        |
        v
Selenium WebDriver
  负责：真正控制Chrome/Edge/Firefox
        |
        v
CineFlowWeb
  负责：展示Vue页面并调用接口
        |
        v
CineFlowAPI
  负责：登录、电影、座位、订单、支付和退款
```

`conftest.py` 在旁边负责准备浏览器、配置和登录态；`utils/`负责测试数据与辅助流程；`assert`负责最后判定是否正确；失败截图和Allure负责保存证据。

如果你已经能解释这张图，就已经理解了整个工程最重要的设计。

