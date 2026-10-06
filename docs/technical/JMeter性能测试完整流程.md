# CineFlow 项目 JMeter 性能测试完整流程

> 适用项目：CineFlow 电影购票与推荐系统  
> 适用工具：Apache JMeter 5.6.3  
> 文档目标：即使第一次使用 JMeter，也能按照本文完成脚本检查、冒烟、阶梯压测、HTML 报告生成、指标分析、瓶颈定位和测试报告编写。

---

## 1. 先确认你电脑上的真实环境

已经在当前电脑验证：

```text
JMeter 版本：Apache JMeter 5.6.3
JMeter 目录：D:\apache-jmeter-5.6.3\apache-jmeter-5.6.3
启动文件：D:\apache-jmeter-5.6.3\apache-jmeter-5.6.3\bin\jmeter.bat
Java 版本：Java 17
JMETER_HOME：目前未配置
Path 中的 jmeter：目前未配置
```

因此，现在直接在 PowerShell 输入：

```powershell
jmeter
```

会提示找不到命令。这不代表没有安装，只是 Windows 不知道 JMeter 在哪里。

### 1.1 最简单的启动方法：直接使用完整路径

```powershell
& "D:\apache-jmeter-5.6.3\apache-jmeter-5.6.3\bin\jmeter.bat"
```

PowerShell 中路径包含反斜杠或空格时，推荐使用 `& "完整路径"`。

### 1.2 推荐配置 `JMETER_HOME`

在 Windows 搜索“编辑系统环境变量”，进入：

```text
高级 -> 环境变量 -> 用户变量 -> 新建
```

填写：

```text
变量名：JMETER_HOME
变量值：D:\apache-jmeter-5.6.3\apache-jmeter-5.6.3
```

再编辑用户变量 `Path`，添加：

```text
%JMETER_HOME%\bin
```

全部窗口点击确定，**关闭原来的 PowerShell，再重新打开一个 PowerShell**，执行：

```powershell
echo $env:JMETER_HOME
jmeter -v
```

预期显示安装目录和 JMeter 5.6.3。

如果不想配置环境变量，也完全可以继续使用完整路径，或者执行本项目脚本时传入 `-JMeterHome`。

---

## 2. 性能测试前先理解四个问题

### 2.1 测什么

当前测试计划压测以下只读接口：

```text
POST /api/auth/login                         每个虚拟用户仅执行一次
GET  /api/movies?pageNum=1&pageSize=10      每轮执行一次
GET  /api/movies/hot?limit=10               每轮执行一次
GET  /api/stat/actor-top50                  每轮执行一次
GET  /api/recommendations/me?limit=10       每轮执行一次，携带 JWT
```

每个线程先登录、提取 Token，然后循环执行四个 GET 请求，所以四个业务接口当前是等比例混合场景。

### 2.2 为什么暂时不压订单写接口

下单、支付、退款会持续改变数据库：

- 可用座位越来越少；
- 会产生大量订单和支付流水；
- 后面的请求和前面的请求条件不同；
- 清理数据复杂；
- 409 可能是测试数据耗尽，不一定是性能问题。

所以第一阶段先使用只读接口建立可靠基线。订单性能应另外建立独立测试计划，使用专用场次、CSV 用户、动态座位关联和测试后清理，不能直接混进当前计划。

### 2.3 在哪里测

性能测试应使用独立测试环境。学习阶段可以把 JMeter、FastAPI、MySQL 都运行在本机，但得到的结果只能用于练习，不能代表服务器真实性能，因为三者会争抢同一台电脑的 CPU、内存和磁盘。

严禁在没有授权的情况下压测生产环境。

### 2.4 什么叫“性能合格”

必须同时说明：

```text
环境 + 数据量 + 并发用户 + Ramp-Up + 持续时间 + 接口比例 + SLA
```

例如：

> 在本机测试环境、电影表 10 万行、50 并发用户、60 秒 Ramp-Up、持续 5 分钟的只读混合场景下，错误率小于 0.1%，整体 P95 小于 800ms。

这才是完整目标。只说“接口小于 1 秒”是不完整的。

---

## 3. 本项目已经准备好的性能测试文件

```text
D:\MovieTicketingAndRecommendationSystem\CineFlowAutoTest\performance\
├─ cineflow-api-performance.jmx   JMeter 测试计划
├─ run-jmeter.ps1                 非 GUI 一键执行脚本
└─ README.md                      简要说明
```

测试结果会生成在：

```text
D:\MovieTicketingAndRecommendationSystem\CineFlowAutoTest\reports\jmeter\时间戳\
├─ results.jtl
└─ html\
   └─ index.html
```

`.jtl` 是原始采样结果，`html/index.html` 是浏览器查看的可视化报告。

---

## 4. 第一步：启动并检查 CineFlowAPI

### 4.1 检查 `.env`

打开：

```text
D:\MovieTicketingAndRecommendationSystem\CineFlowAPI\.env
```

本机 MySQL 示例：

```env
DATABASE_URL=mysql+pymysql://root:你的密码@127.0.0.1:3306/cineflow_db?charset=utf8mb4
JWT_SECRET=至少32个字符的测试密钥
JWT_EXPIRE_MINUTES=120
SEAT_LOCK_MINUTES=5
ORDER_EXPIRE_MINUTES=15
AUTO_CREATE_TABLES=true
SEED_DEMO_DATA=true
```

注意：密码不要写进本文、截图、Git 或面试材料。

### 4.2 启动 FastAPI

打开一个新的 PyCharm Terminal 或 PowerShell：

```powershell
cd D:\MovieTicketingAndRecommendationSystem\CineFlowAPI
.\.venv\Scripts\python.exe -m uvicorn app.main:app --reload
```

看到类似内容说明服务启动：

```text
Uvicorn running on http://127.0.0.1:8000
Application startup complete
```

这个终端不要关闭。

### 4.3 检查健康接口

浏览器打开：

```text
http://127.0.0.1:8000/health
```

预期：

```json
{
  "code": 0,
  "message": "success",
  "data": {"status": "UP"},
  "timestamp": 0
}
```

`timestamp` 实际会是当前毫秒时间，不要求等于示例中的 0。

再打开：

```text
http://127.0.0.1:8000/docs
```

确认 Swagger 能显示接口。

### 4.4 检查压测账号

当前 JMeter 默认账号：

```text
用户名：test_user
密码：Test1234
```

先在 Swagger 或 Postman 调用：

```http
POST /api/auth/login
Content-Type: application/json

{
  "username": "test_user",
  "password": "Test1234"
}
```

预期 HTTP 200，且响应中存在：

```json
{
  "data": {
    "token": "一段JWT",
    "tokenType": "Bearer"
  }
}
```

如果手工登录都失败，先不要打开 JMeter。性能测试建立在功能正确的基础上。

### 4.5 检查四个业务接口

依次手工检查：

```text
http://127.0.0.1:8000/api/movies?pageNum=1&pageSize=10
http://127.0.0.1:8000/api/movies/hot?limit=10
http://127.0.0.1:8000/api/stat/actor-top50
```

个人推荐需要 Bearer Token，使用 Swagger 或 Postman检查：

```text
GET /api/recommendations/me?limit=10
Authorization: Bearer 登录返回的token
```

所有接口功能正确后，再进入 JMeter。

---

## 5. 第二步：用 GUI 打开测试计划

### 5.1 推荐启动命令

```powershell
& "D:\apache-jmeter-5.6.3\apache-jmeter-5.6.3\bin\jmeter.bat" `
  -t "D:\MovieTicketingAndRecommendationSystem\CineFlowAutoTest\performance\cineflow-api-performance.jmx"
```

也可以双击 `jmeter.bat`，然后选择：

```text
File -> Open -> cineflow-api-performance.jmx
```

### 5.2 左侧树形结构应该看到什么

```text
CineFlow API Performance Test
├─ HTTP Request Defaults
├─ Common Headers
└─ CineFlow Read-only Mixed Load
   ├─ Login Once Per Virtual User
   │  └─ POST Login
   │     ├─ Login HTTP 200
   │     ├─ Extract JWT
   │     └─ JWT Must Exist
   ├─ Think Time Between Requests
   ├─ GET Movie List
   │  ├─ Movie List HTTP 200
   │  └─ Movie List Response Time
   ├─ GET Hot Movies
   │  ├─ Hot Movies HTTP 200
   │  └─ Hot Movies Response Time
   ├─ GET Region Statistics
   │  ├─ Region Statistics HTTP 200
   │  └─ Region Statistics Response Time
   └─ GET Personal Recommendations
      ├─ JWT Authorization Header
      ├─ Recommendations HTTP 200
      └─ Recommendations Response Time
```

如果打开后左侧为空，通常是打开了错误文件或 JMX 没有成功加载；查看 JMeter 底部黄色警告图标和 `bin/jmeter.log`。

---

## 6. 测试计划每个组件到底做什么

### 6.1 Test Plan

最顶层保存全局参数。当前参数使用 JMeter Property 写法：

```text
${__P(属性名,默认值)}
```

例如：

```text
${__P(users,10)}
```

含义是：命令行传入 `-Jusers=50` 时使用 50，没有传时使用默认值 10。

### 6.2 HTTP Request Defaults

统一配置：

```text
Protocol：http
Server Name：127.0.0.1
Port：8000
Connect Timeout：5000ms
Response Timeout：10000ms
Implementation：HttpClient4
Content Encoding：UTF-8
```

所以每个 HTTP Request 只写 `/api/...`，不需要重复写主机和端口。

### 6.3 Common Headers

统一发送：

```http
Accept: application/json
Content-Type: application/json
```

个人推荐请求另外增加：

```http
Authorization: Bearer ${auth_token}
```

### 6.4 Thread Group

Thread Group 是负载模型核心：

- Number of Threads：并发虚拟用户数。
- Ramp-Up Period：这些用户全部启动完成需要多少秒。
- Loop Count：当前无限循环。
- Duration：由调度器控制总持续时间。
- Same user on each iteration：每个线程持续代表同一个虚拟用户。
- Action after Sampler error：当前选择继续执行并记录错误。

举例：

```text
Users=50
Ramp-Up=25秒
Duration=300秒
```

大约每 0.5 秒启动一个用户，所有用户启动完成后继续运行，整个线程组从开始计时约 300 秒结束。

### 6.5 Once Only Controller

`POST Login` 放在 Once Only Controller 中，因此每个虚拟用户只登录一次，不会每轮业务请求都登录。

如果 50 个线程，就会登录约 50 次；不是整个测试计划只登录一次。

### 6.6 JSON Extractor

登录响应中的：

```text
$.data.token
```

被保存到变量：

```text
auth_token
```

个人推荐通过 `${auth_token}` 使用它。

若提取失败，默认值为 `TOKEN_NOT_FOUND`，后面的 `JWT Must Exist` 会把登录采样标记为失败，避免使用空 Token 继续压测却被误认为系统性能问题。

### 6.7 Constant Timer

默认 `think_time=500ms`，用于模拟用户请求之间的思考间隔。如果没有思考时间，每个线程会以机器能达到的最快速度连续请求，更像极限吞吐测试，不像真实用户负载。

### 6.8 Response Assertion

当前每个请求检查 HTTP 状态码等于 200。任何 401、404、409、422 或 500 都会进入错误统计。

### 6.9 Duration Assertion

四个业务 GET 默认要求单次请求不超过：

```text
max_response_ms=2000ms
```

如果服务器返回 200，但耗时 2500ms，该请求仍会被标记为失败。这叫性能断言。

注意：2000ms 是当前默认练习阈值，不是经过业务确认的正式 SLA。

---

## 7. 第三步：GUI 冒烟调试

正式压测之前，一定先用 1 个用户确认脚本本身正确。

### 7.1 临时添加 View Results Tree

在左侧右键 Thread Group：

```text
Add -> Listener -> View Results Tree
```

它可以查看请求、响应、变量和断言。**正式压测前必须禁用或删除**，因为它会保存大量响应并消耗内存。

### 7.2 设置一个用户

因为 JMX 参数来自 Property，在 GUI 直接运行时默认就是：

```text
users=10
ramp_up=10
duration=60
```

第一次调试不建议直接用默认 10 用户。最稳妥的方法是从命令行向 GUI 传入 Property：

```powershell
& "D:\apache-jmeter-5.6.3\apache-jmeter-5.6.3\bin\jmeter.bat" `
  -Jusers=1 `
  -Jramp_up=1 `
  -Jduration=15 `
  -Jthink_time=1000 `
  -t "D:\MovieTicketingAndRecommendationSystem\CineFlowAutoTest\performance\cineflow-api-performance.jmx"
```

### 7.3 点击运行

点击顶部绿色三角形，或者：

```text
Run -> Start
```

### 7.4 在 View Results Tree 中逐项检查

#### POST Login

- 绿色表示成功。
- Request Body 中账号密码正确。
- Response code 是 200。
- Response Data 中 `code=0` 且 `data.token` 非空。

#### GET Movie List

- 最终 URL 含 `pageNum=1&pageSize=10`。
- HTTP 200。
- 响应是电影分页结构。

#### GET Personal Recommendations

- Request Headers 中存在 `Authorization: Bearer ...`。
- 不能是 `Bearer TOKEN_NOT_FOUND`。
- HTTP 200。

#### Assertion result

查看 Assertion result。如果提示响应时间超过 2000ms，先确认是否为应用刚启动、数据库首次连接或本机资源紧张，不要马上认定后端永久不合格。

### 7.5 调试完成后

1. 点击停止。
2. 清空 View Results Tree。
3. 右键 View Results Tree，选择 Disable，或者直接删除。
4. 保存 JMX。

不要在正式 50/100 用户压测时保留 View Results Tree、View Results in Table 等重型监听器。

---

## 8. 第四步：使用非 GUI 模式正式执行

Apache JMeter 官方建议正式负载测试使用 CLI/非 GUI 模式。

### 8.1 本项目推荐命令

打开 PowerShell：

```powershell
cd D:\MovieTicketingAndRecommendationSystem\CineFlowAutoTest

Set-ExecutionPolicy -Scope Process Bypass

.\performance\run-jmeter.ps1 `
  -JMeterHome "D:\apache-jmeter-5.6.3\apache-jmeter-5.6.3" `
  -HostName "127.0.0.1" `
  -Port 8000 `
  -Username "test_user" `
  -Password "Test1234" `
  -Users 1 `
  -RampUp 1 `
  -Duration 30 `
  -ThinkTime 500 `
  -MaxResponseMs 2000
```

这一步仍是 CLI 冒烟，不是最终压力档。

### 8.2 参数解释

| 参数 | 默认值 | 解释 |
|---|---:|---|
| `JMeterHome` | 环境变量 | JMeter 解压后的根目录 |
| `Protocol` | http | 协议，不带 `://` |
| `HostName` | 127.0.0.1 | API 主机，不带协议和路径 |
| `Port` | 8000 | API 端口 |
| `Username` | test_user | 登录账号 |
| `Password` | Test1234 | 登录密码 |
| `Users` | 10 | 虚拟用户数 |
| `RampUp` | 10 | 全部用户启动所需秒数 |
| `Duration` | 60 | 总执行秒数 |
| `ThinkTime` | 500 | 请求之间等待毫秒数 |
| `MaxResponseMs` | 2000 | 单个业务请求最大响应时间断言 |

### 8.3 原生 JMeter 命令是什么样

脚本本质上执行：

```powershell
& "D:\apache-jmeter-5.6.3\apache-jmeter-5.6.3\bin\jmeter.bat" `
  -n `
  -t "D:\MovieTicketingAndRecommendationSystem\CineFlowAutoTest\performance\cineflow-api-performance.jmx" `
  -l "D:\temp\cineflow-results.jtl" `
  -e `
  -o "D:\temp\cineflow-html" `
  -Jhost=127.0.0.1 `
  -Jport=8000 `
  -Jusers=10 `
  -Jramp_up=10 `
  -Jduration=120 `
  -Jthink_time=500 `
  -Jmax_response_ms=2000
```

含义：

- `-n`：非 GUI。
- `-t`：测试计划。
- `-l`：JTL 原始结果。
- `-e`：测试结束后生成 HTML Dashboard。
- `-o`：HTML 输出目录。
- `-Jxxx=value`：传入 JMeter Property。

`-o` 指定的目录必须不存在或为空。本项目脚本使用时间戳创建新目录，不需要手工删除旧报告。

---

## 9. 第五步：按阶梯逐步增加负载

不要一上来就 1000 用户。压测也需要像排查 Bug 一样控制变量。

### 9.1 第一档：CLI 冒烟

```powershell
.\performance\run-jmeter.ps1 `
  -JMeterHome "D:\apache-jmeter-5.6.3\apache-jmeter-5.6.3" `
  -Users 1 -RampUp 1 -Duration 30
```

目标：错误率为 0，登录、JWT、断言和报告均正常。

### 9.2 第二档：预热

```powershell
.\performance\run-jmeter.ps1 `
  -JMeterHome "D:\apache-jmeter-5.6.3\apache-jmeter-5.6.3" `
  -Users 5 -RampUp 10 -Duration 60
```

目标：让数据库连接池、磁盘缓存和 Python 运行环境进入稳定状态。预热结果可以保存，但不要直接作为最终基线。

### 9.3 第三档：基线

```powershell
.\performance\run-jmeter.ps1 `
  -JMeterHome "D:\apache-jmeter-5.6.3\apache-jmeter-5.6.3" `
  -Users 10 -RampUp 10 -Duration 120
```

目标：得到低负载下吞吐量、P95 和资源使用基线。

### 9.4 第四档：中等负载

```powershell
.\performance\run-jmeter.ps1 `
  -JMeterHome "D:\apache-jmeter-5.6.3\apache-jmeter-5.6.3" `
  -Users 50 -RampUp 60 -Duration 300
```

目标：观察吞吐是否随用户数增长、P95 是否明显上升、是否出现连接池等待。

### 9.5 第五档：压力档

```powershell
.\performance\run-jmeter.ps1 `
  -JMeterHome "D:\apache-jmeter-5.6.3\apache-jmeter-5.6.3" `
  -Users 100 -RampUp 120 -Duration 300
```

目标：寻找饱和点。发现错误率快速上升、系统无响应或本机资源接近极限时应停止，不要为了数字继续加压。

### 9.6 稳定性测试

在功能和短时压力都稳定后，可以选择 20～50 用户持续 30～60 分钟：

```powershell
.\performance\run-jmeter.ps1 `
  -JMeterHome "D:\apache-jmeter-5.6.3\apache-jmeter-5.6.3" `
  -Users 20 -RampUp 60 -Duration 3600
```

目标：观察内存是否持续增长、连接是否泄漏、响应时间是否随时间恶化。

### 9.7 每档之间做什么

1. 保存该档报告目录。
2. 记录开始和结束时间。
3. 记录 JMeter 参数。
4. 截图 CPU、内存、MySQL 状态。
5. 等待 1～2 分钟让系统恢复。
6. 确认 API 健康后再开始下一档。
7. 不修改代码、不重启环境，除非测试计划明确要求；否则不同档不可比较。

---

## 10. 为什么不能只记录“100 个线程跑成功了”

线程数不是吞吐量，也不等于真实在线用户数。

一个循环有四个业务请求，并且每个请求前有约 500ms 思考时间。实际吞吐还受响应时间影响。相同 100 线程下：

- 响应越快，每个线程单位时间能完成更多循环，吞吐越高；
- 响应变慢，线程在等待，吞吐可能停止增长；
- 错误快速返回也可能让吞吐看起来很高，所以必须同时看错误率；
- 本机 JMeter 自己资源不足，也可能无法继续施压。

一份有效结果至少同时包含：并发、Ramp-Up、持续时间、吞吐量、错误率、P95、P99 和服务端资源。

---

## 11. 第六步：找到并打开 HTML 报告

脚本运行结束会打印类似：

```text
原始结果：D:\...\reports\jmeter\20260916-101500\results.jtl
HTML 报告：D:\...\reports\jmeter\20260916-101500\html\index.html
```

用资源管理器进入该目录，双击 `index.html`。不要只打开某个 `.js` 或 `.json` 文件。

### 11.1 Dashboard 首页

首页先看：

- Test and Report information：测试起止时间。
- APDEX：用户满意度参考。
- Requests Summary：成功和失败比例。
- Statistics：每个请求的样本数、平均值、百分位和吞吐量。
- Errors：错误类型和数量。

### 11.2 Statistics 表每一列是什么意思

| 指标 | 含义 | 怎么看 |
|---|---|---|
| Samples | 请求样本数 | 样本太少时结论不稳定 |
| Fail | 失败数 | 必须结合错误类型，不只看总数 |
| Error % | 失败比例 | 优先确认是不是脚本、数据或断言失败 |
| Average | 平均响应时间 | 容易掩盖少量特别慢的请求 |
| Min | 最快响应 | 参考价值有限，不能代表一般用户 |
| Max | 最慢响应 | 容易受偶发抖动影响，但需调查极端值 |
| Median | 中位数/P50 | 一半请求不超过该值 |
| 90th pct | P90 | 90% 请求不超过该值 |
| 95th pct | P95 | 常用 SLA 指标 |
| 99th pct | P99 | 观察尾部慢请求 |
| Transactions/s | 每秒事务数 | 本场景中基本对应请求吞吐量 |
| Received KB/s | 每秒接收数据量 | 大响应体可能成为网络和序列化成本 |
| Sent KB/s | 每秒发送数据量 | 登录、写接口时更有意义 |

### 11.3 P95 的正确理解

P95=800ms 表示 95% 的请求在 800ms 内完成，仍有 5% 更慢。它不表示平均值是 800ms，也不表示所有请求都小于 800ms。

### 11.4 Connect Time、Latency 和 Elapsed

- Connect Time：建立网络连接花费时间。
- Latency：发送请求到收到响应第一个字节的时间。
- Elapsed/Response Time：发送请求到完整接收响应的总时间。

如果 Connect Time 很高，优先查连接建立、端口、网络和连接复用；如果 Latency 高，可能是服务端开始响应慢；如果 Latency 尚可但 Elapsed 高，可能是响应体大或传输慢。

### 11.5 常看的图

#### Response Time Percentiles

比较各接口的 P90/P95/P99。推荐接口通常比简单电影列表复杂，应分别分析，不能只看 Total。

#### Response Times Over Time

观察响应时间是否随着负载和时间持续增加。如果开始正常，几分钟后越来越慢，可能有连接泄漏、内存压力或锁积累。

#### Response Time vs Request

观察吞吐增大后响应时间是否出现拐点。

#### Transactions per Second

观察系统吞吐是否稳定。用户继续增加而吞吐不再增加、响应时间却上涨，说明系统可能达到饱和。

#### Active Threads Over Time

确认线程是否按 Ramp-Up 增长以及测试结束时是否退出。若实际线程曲线和设置不符，先查脚本或机器施压能力。

#### Time vs Threads

观察并发用户增加与响应时间之间的关系。

---

## 12. 一套可以直接使用的结果判定方法

正式 SLA 应由业务、研发和测试共同确定。在没有正式指标时，可以先使用“练习基线”，但报告必须写明这是暂定目标。

### 12.1 暂定练习目标

| 指标 | 暂定目标 | 说明 |
|---|---:|---|
| HTTP/断言错误率 | 0% | 冒烟和基线必须为 0 |
| 中等负载错误率 | < 0.1% | 必须说明每个错误的原因 |
| 电影列表 P95 | < 800ms | 本机环境仅作为练习 |
| 热门电影 P95 | < 800ms | 关注排序查询 |
| 演员 Top50 P95 | < 1000ms | 关注统计表是否有索引 |
| 个人推荐 P95 | < 1500ms | 推荐逻辑相对复杂 |
| P99 | 不应突然数倍于 P95 | 尾延迟过高需调查 |
| 吞吐量 | 随 10→50 用户合理增长 | 不规定虚假的固定 QPS |

### 12.2 判定顺序

1. 脚本是否正确。
2. 样本量是否足够。
3. 错误率是否可接受。
4. 各接口 P95/P99 是否达标。
5. 吞吐是否达到目标。
6. 服务资源是否有余量。
7. 长时间运行是否稳定。

只要脚本或错误率有问题，就不要急着得出“后端性能差”的结论。

---

## 13. 同时监控 FastAPI、Windows 和 MySQL

JMeter 只能告诉你客户端看到了什么，不能单独告诉你为什么慢。

### 13.1 Windows 任务管理器

压测开始前打开任务管理器：

```text
Ctrl + Shift + Esc -> 性能
```

记录：

- CPU 总使用率。
- 内存已使用和可用。
- 磁盘活动时间。
- 网络吞吐。
- Java/JMeter、Python/Uvicorn、MySQL 分别占多少资源。

### 13.2 PowerShell 查看进程

另开一个 PowerShell：

```powershell
Get-Process java,python,mysqld -ErrorAction SilentlyContinue |
  Select-Object ProcessName,Id,CPU,WorkingSet64,Threads
```

多次执行，观察 WorkingSet64 是否持续只升不降。它是字节数，可以除以 1MB 方便观察：

```powershell
Get-Process java,python,mysqld -ErrorAction SilentlyContinue |
  Select-Object ProcessName,Id,CPU,@{Name='MemoryMB';Expression={[math]::Round($_.WorkingSet64/1MB,2)}}
```

### 13.3 MySQL 当前连接

在 DataGrip 中执行：

```sql
SHOW STATUS LIKE 'Threads_connected';
SHOW STATUS LIKE 'Threads_running';
SHOW FULL PROCESSLIST;
```

- `Threads_connected`：当前连接数量。
- `Threads_running`：正在执行而不是休眠的线程数量。
- `PROCESSLIST`：是否有长时间 SQL、Waiting for lock 等状态。

### 13.4 查看 InnoDB 状态

```sql
SHOW ENGINE INNODB STATUS;
```

重点查看：

- 最近死锁。
- 锁等待。
- 事务信息。
- Buffer Pool 情况。

### 13.5 查看执行计划

如果演员 Top50 或电影列表慢：

```sql
EXPLAIN ANALYZE
SELECT *
FROM movie
WHERE status = 'AVAILABLE'
ORDER BY popularity DESC
LIMIT 10;
```

具体 SQL 应从应用日志或 SQLAlchemy 输出中获取。检查是否全表扫描、实际行数是否远大于返回行数、排序是否使用临时表。

### 13.6 慢查询日志

不要在不了解影响时直接修改生产 MySQL。测试环境可以在 DBA 或指导老师确认后开启慢查询，记录超过指定阈值的 SQL，再结合 JMeter 的慢接口时间进行对齐。

---

## 14. 常见现象和定位方法

### 14.1 `jmeter` 不是命令

**原因**：JMeter 未加入 Path。  
**处理**：使用完整路径，或设置 `JMETER_HOME` 和 `%JMETER_HOME%\bin`。

当前电脑真实路径：

```text
D:\apache-jmeter-5.6.3\apache-jmeter-5.6.3
```

### 14.2 脚本提示“未设置 JMETER_HOME”

运行时显式传入：

```powershell
-JMeterHome "D:\apache-jmeter-5.6.3\apache-jmeter-5.6.3"
```

不要传外层 `D:\apache-jmeter-5.6.3`，因为真正的 `bin/jmeter.bat` 在下一层目录中。

### 14.3 `Connection refused` 或 Connect Timeout

依次检查：

1. Uvicorn 终端是否还在运行。
2. 浏览器能否打开 `/health`。
3. 端口是否为 8000。
4. HostName 是否只填写 `127.0.0.1`，没有带 `http://`。
5. 防火墙、代理和虚拟机网络。

### 14.4 登录 401

检查：

- `test_user` 是否存在。
- 密码大小写。
- JMeter Body 中是否仍是 `${username}`、`${password}` 且 Property 生效。
- FastAPI 是否连接了你以为的数据库。
- 用户状态是否 ACTIVE。

### 14.5 推荐接口 401

先看 `POST Login`，再看 Extract JWT：

- JSON Path 是否为 `$.data.token`。
- 登录响应结构是否改变。
- Header 是否为 `Bearer ${auth_token}`。
- 实际 Header 是否变成 `Bearer TOKEN_NOT_FOUND`。

### 14.6 大量请求恰好在 2000ms 失败

很可能是 Duration Assertion，而不是 HTTP 失败。查看 Assertion failure message。如果只是为了先观察真实分布，可把：

```powershell
-MaxResponseMs 5000
```

临时提高，但报告必须说明阈值变化，不能用提高阈值掩盖性能退化。

### 14.7 看到 409

当前计划只有只读接口，正常不应该出现 409。若出现，查看究竟是哪一个采样器；可能打开了旧 JMX、接口路由变化，或者测试计划被加入写操作。

### 14.8 看到 422

参数名、类型或范围不符合 FastAPI 请求模型。检查 URL 最终值，不要只看模板。尤其检查 Property 是否为空。

### 14.9 看到 500

保存请求时间、接口、响应和 JMeter 线程信息，然后查看 Uvicorn 日志和数据库状态。500 才是优先检查后端异常堆栈的信号，不能只在 JMeter 报告里猜原因。

### 14.10 HTML 报告生成失败

常见原因：

- 输出目录已存在且非空。
- JTL 路径无权限。
- 测试被强制终止导致 JTL 不完整。
- 文件仍被其他程序占用。

本项目脚本使用新的时间戳目录，可避免最常见的非空目录问题。

### 14.11 JMeter 自己内存不足

症状可能包括 GUI 卡死、`OutOfMemoryError`、报告生成失败。处理：

- 正式测试不用 GUI。
- 删除 View Results Tree。
- 不保存不必要的响应体。
- 必要时调整 `bin/heapdump.cmd` 或 JMeter JVM 参数，但先确认确实是施压端内存不足。
- 更高负载使用独立压测机或分布式 JMeter。

### 14.12 吞吐不增长但 CPU 也不高

可能是：

- 500ms Think Time 限制了请求频率。
- 数据库连接池上限。
- MySQL 锁等待或慢查询。
- Uvicorn 单进程并发能力。
- 网络或连接建立等待。
- JMeter 本身没有足够活动线程。

先看 Active Threads、响应时间、Threads_running 和 PROCESSLIST，再判断。

### 14.13 报告错误率很高，但吞吐量也很高

错误请求可能快速返回，例如登录失败立即 401，比正常数据库查询还快。高吞吐不代表性能好。先把功能成功率修正，再分析吞吐。

### 14.14 启动时出现 package scanning 或 Java Preferences 警告

当前电脑执行 `jmeter -v` 时可能看到：

```text
The use of package scanning to locate plugins is deprecated
Could not open/create prefs root node Software\JavaSoft\Prefs
Windows RegCreateKeyEx returned error code 5
```

如果最后仍正常显示 JMeter 5.6.3，这些是警告，不是“JMeter 没安装”。前者是 JMeter 组件扫描弃用提示；后者是当前用户不能写某个 Java Preferences 注册表位置，可能影响少量 GUI 偏好保存，但通常不影响 CLI 压测。

先按本文执行 1 用户冒烟。如果 JMX 能加载、请求能发送、JTL 和 HTML 能生成，就不需要为了消除警告盲目使用管理员权限。只有 GUI 配置确实无法保存时，再检查 Java 安装和当前用户注册表权限。

---

## 15. 如何判断瓶颈在哪一层

### 情况 A：JMeter CPU 很高，服务端 CPU 不高

施压机可能成为瓶颈。关闭 GUI 和监听器，降低结果保存量，或把 JMeter 放到独立机器。

### 情况 B：Python CPU 接近 100%，MySQL 不忙

可能是应用计算、序列化、单进程或阻塞代码瓶颈。比较 `/health`、电影列表和推荐接口，使用应用性能分析工具继续定位。

### 情况 C：MySQL CPU/IO 高、慢 SQL 多

查看执行计划、索引、返回数据量、排序和聚合。统计接口应优先读取聚合表，不能每次扫描大电影表。

### 情况 D：CPU 都不高，但响应时间高

查看锁等待、连接池等待、网络、磁盘和外部依赖。等待型瓶颈不一定表现为高 CPU。

### 情况 E：运行一段时间后越来越慢

怀疑内存、连接、文件句柄泄漏，缓存无限增长，日志写入过多，数据库表/临时数据增长，或长事务堆积。

### 情况 F：只有 P99 很高

检查偶发 GC、慢查询、锁竞争、后台任务、首次连接和冷缓存。不要因为平均值正常就忽略尾延迟。

---

## 16. 参数化多个用户，而不是所有线程共用 test_user

当前只读计划让所有线程使用同一个账号，适合第一阶段；因为接口只读，不会产生用户间写冲突。但更真实的场景应使用多个用户。

### 16.1 准备 CSV

创建：

```text
CineFlowAutoTest/performance/users.csv
```

内容不要提交真实密码：

```csv
username,password
perf_user_001,PerfTest123
perf_user_002,PerfTest123
perf_user_003,PerfTest123
```

这些用户要提前注册到专用测试库。

### 16.2 在 JMeter 添加 CSV Data Set Config

右键 Thread Group：

```text
Add -> Config Element -> CSV Data Set Config
```

配置：

```text
Filename：CSV 的绝对路径或相对 JMX 的路径
Variable Names：username,password
Delimiter：,
Allow quoted data：True
Recycle on EOF：True（循环使用）
Stop thread on EOF：False
Sharing mode：All threads
Ignore first line：True（若界面支持该选项）
```

登录 Body 已经使用 `${username}` 和 `${password}`，CSV 变量可覆盖 Test Plan 默认变量。调试时一定在请求 Body 中确认每个线程拿到了正确账号。

### 16.3 用户数与 CSV 行数

如果要严格保证 100 线程对应 100 个不同账号，应准备至少 100 行并设置不循环、EOF 停止线程。若允许账号复用，可以循环，但报告必须说明。

---

## 17. 如果以后要测下单性能，应该怎么设计

不要直接修改当前只读计划。复制一个新文件，例如：

```text
cineflow-order-performance.jmx
```

每个虚拟用户流程：

```text
CSV 读取独立用户
  -> 登录并提取 Token
  -> 查询电影
  -> 提取 movie_id
  -> 查询场次
  -> 提取 schedule_id
  -> 查询座位
  -> 用 JSON 脚本选 AVAILABLE seat_id
  -> 生成唯一 idempotencyKey
  -> 创建订单
  -> 按比例执行支付、取消或支付失败
  -> 测试结束后清理专用场次数据
```

必须考虑：

- 可用座位总量是否足够。
- 同座竞争是故意的还是数据分配错误。
- 409 是否计入预期业务结果。
- 每轮是否使用新的幂等键。
- 重复请求场景必须复用原幂等键。
- 支付幂等必须复用原 providerTradeNo。
- 测试数据清理和订单表增长。
- 写压测会改变缓存、索引和表规模。

正确性并发测试仍交给 pytest；JMeter 负责持续负载和性能指标。

---

## 18. 性能测试记录表

每次执行立即填写，不能只留一堆不知道参数的报告目录。

| 轮次 | 时间 | 环境 | Users | Ramp-Up | Duration | Think Time | Error % | Throughput | P95 | P99 | CPU 峰值 | 内存峰值 | 结论 |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 冒烟 |  | 本机 | 1 | 1s | 30s | 500ms |  |  |  |  |  |  |  |
| 预热 |  | 本机 | 5 | 10s | 60s | 500ms |  |  |  |  |  |  |  |
| 基线 |  | 本机 | 10 | 10s | 120s | 500ms |  |  |  |  |  |  |  |
| 中等 |  | 本机 | 50 | 60s | 300s | 500ms |  |  |  |  |  |  |  |
| 压力 |  | 本机 | 100 | 120s | 300s | 500ms |  |  |  |  |  |  |  |

---

## 19. 性能测试报告模板

复制下面内容，实际执行后填写。

```markdown
# CineFlow API 性能测试报告

## 1. 测试目的
验证电影列表、热门电影、演员 Top50 和个人推荐接口在目标并发下的响应时间、吞吐量、错误率和稳定性。

## 2. 测试环境
- 压测机：CPU / 内存 / 操作系统
- 应用机：本机或服务器配置
- 数据库：MySQL 版本、数据量
- FastAPI：版本、Uvicorn 进程数
- JMeter：5.6.3
- 网络：本机 / 局域网

## 3. 测试数据
- 电影表行数：
- 统计表行数：
- 测试账号数量：
- 是否清理缓存：

## 4. 场景模型
- 线程数：
- Ramp-Up：
- Duration：
- Think Time：
- 接口比例：四个 GET 各执行一次
- 登录：每个虚拟用户一次

## 5. 通过标准
- Error %：
- 电影列表 P95：
- 热门电影 P95：
- 演员 Top50 P95：
- 推荐 P95：
- 目标吞吐：

## 6. 测试结果
填写每个接口 Samples、Error%、Average、P90、P95、P99、TPS。

## 7. 资源使用
- JMeter CPU/内存：
- FastAPI CPU/内存：
- MySQL CPU/内存/连接数：
- 慢查询：

## 8. 问题与分析
按时间对齐 JMeter 错误、应用日志和数据库证据。

## 9. 结论
明确通过/不通过、最大稳定负载、瓶颈和证据。

## 10. 优化建议与复测计划
建议必须对应证据；优化后使用同环境、同数据、同脚本复测。
```

### 19.1 结论示例

不要写：

> 系统性能良好，能够承受高并发。

应该写成：

> 在本机共享资源环境、50 用户、60 秒 Ramp-Up、持续 300 秒的只读混合场景下，共完成 X 个请求，错误率 X%，整体吞吐 X req/s。电影列表 P95 为 Xms，推荐接口 P95 为 Xms。用户从 10 增加到 50 时吞吐增长 X%，推荐 P99 上升明显；同期 MySQL Threads_running 达到 X，发现 SQL X 存在全表扫描。因此本轮只能证明该环境在 50 用户下是否满足暂定指标，不能外推生产容量。

---

## 20. 优化之后必须怎样复测

性能优化不能只看“优化后这一次更快”。复测必须保持：

- 相同代码之外的环境配置。
- 相同数据库数据量和分布。
- 相同 JMX。
- 相同线程、Ramp-Up、Duration、Think Time。
- 相同缓存预热策略。
- 相同监控指标。

至少重复 3 次，观察波动范围。若第一次冷缓存、后两次热缓存，应分别标记，不能挑最好的一次汇报。

---

## 21. 性能测试面试问题与答案

### Q1：为什么用 JMeter？

它支持 HTTP 场景、参数化、关联、断言、阶梯负载、非 GUI 执行和 HTML 报告，适合本项目接口性能测试。选择工具不是亮点，能正确设计业务负载、判断脚本错误和定位瓶颈才是重点。

### Q2：线程数是不是 QPS？

不是。线程数是并发虚拟用户，QPS 取决于响应时间、思考时间、每轮请求数和系统处理能力。

### Q3：为什么登录放 Once Only Controller？

模拟用户先登录再持续操作，减少每轮重复登录对业务比例的干扰。每个线程仍会独立登录一次并拥有自己的 Token。

### Q4：什么是关联？

从前一个响应提取动态数据供后续请求使用。例如从登录响应 `$.data.token` 提取 JWT，推荐接口在 Authorization Header 中引用它。

### Q5：为什么要断言？

没有断言时，返回登录页、错误 JSON 或业务失败也可能被 JMeter当成 HTTP 成功。当前检查 HTTP 200、Token 存在和最大响应时间。正式方案还应根据成本增加关键业务码校验。

### Q6：为什么正式压测不用 GUI？

GUI 和监听器消耗 CPU、内存，会降低施压能力并干扰结果。GUI 只用于脚本调试，正式执行使用 `-n`。

### Q7：为什么看 P95？

平均值会掩盖尾部慢请求。P95 表示 95% 请求不超过该时间，能更好反映大多数用户和慢请求尾部。

### Q8：如何确定并发数？

优先来自业务峰值在线用户、请求频率和容量目标；没有数据时用阶梯测试从小到大找拐点，但这种结果只能作为探索，不能冒充业务容量目标。

### Q9：吞吐下降可能是什么原因？

应用 CPU 饱和、数据库慢查询/锁、连接池不足、磁盘/网络、JMeter 施压机不足、响应变慢导致线程等待、错误重试或脚本 Think Time。

### Q10：性能测试和压力测试有什么区别？

性能测试是总称；负载测试验证预期负载；压力测试超过目标逐步寻找极限和失效方式；稳定性测试关注较长时间；突发测试关注瞬时增压；容量测试关注满足 SLA 的最大业务量。

### Q11：如何证明瓶颈在数据库？

需要证据链：慢接口时间与慢 SQL对齐、EXPLAIN 显示扫描或排序成本、MySQL CPU/IO/锁等待高、优化索引后在同条件复测指标改善。不能仅凭“接口访问数据库”就下结论。

### Q12：为什么错误率 0 仍可能不通过？

所有请求都成功，但 P95 可能超过 SLA，吞吐可能达不到目标，资源可能已经 100%，长时间还可能泄漏。

### Q13：本机压测有什么局限？

施压端、应用和数据库竞争资源，网络距离也与生产不同，结果不能外推生产。它适合学习、脚本验证和优化前后相对比较。

### Q14：怎样测试订单接口性能？

使用专用数据、多用户参数化、动态查询可用座位、唯一幂等键、明确支付/取消比例、区分预期 409，完成后清理或重建数据库。并发正确性另用精确 pytest 用例验证。

### Q15：你目前项目得到多少 QPS？

在真正执行并保存报告前，正确回答是：

> 测试计划和阶梯模型已经完成，我会在固定环境和数据量下运行后记录 QPS、P95、P99 和资源数据。目前没有可靠实测结果，所以不编造具体数值。

执行后再用真实数据替换这句话。

---

## 22. 从零执行的最终操作清单

### 执行前

- [ ] MySQL 已启动。
- [ ] FastAPI `.env` 指向专用测试库。
- [ ] FastAPI 已启动且 `/health` 为 200。
- [ ] `test_user / Test1234` 登录成功。
- [ ] 四个业务接口手工调用成功。
- [ ] JMeter 5.6.3 可启动。
- [ ] JMX 路径正确。
- [ ] 当前没有连接生产环境。
- [ ] 记录了代码版本、数据量和机器配置。

### GUI 调试

- [ ] 使用 1 用户、15～30 秒。
- [ ] POST Login 为 200。
- [ ] JWT 提取成功。
- [ ] 推荐请求携带 Bearer Token。
- [ ] 四个 GET 都为 200。
- [ ] 断言没有失败。
- [ ] 正式执行前禁用 View Results Tree。

### CLI 冒烟

- [ ] 使用准确的 `-JMeterHome`。
- [ ] 1 用户执行 30 秒。
- [ ] 脚本退出码为 0。
- [ ] JTL 已生成。
- [ ] HTML Dashboard 能打开。
- [ ] Error%=0。

### 阶梯测试

- [ ] 预热完成。
- [ ] 10 用户基线完成。
- [ ] 50 用户中等负载完成。
- [ ] 根据资源情况决定是否执行 100 用户。
- [ ] 每档参数和报告目录已记录。
- [ ] 每档同时记录 CPU、内存和 MySQL。
- [ ] 每档之间环境恢复。

### 分析与报告

- [ ] 按接口记录 Samples、Error%、TPS、P95、P99。
- [ ] 查看 Errors 具体原因。
- [ ] 查看随时间变化图，而不只看汇总。
- [ ] 将慢点与应用日志、SQL、资源时间对齐。
- [ ] 结论写明环境和限制。
- [ ] 优化建议有证据。
- [ ] 优化后在相同条件复测。

---

## 23. 你现在第一轮应该直接执行的命令

先启动 FastAPI，然后打开新的 PowerShell：

```powershell
cd D:\MovieTicketingAndRecommendationSystem\CineFlowAutoTest

Set-ExecutionPolicy -Scope Process Bypass

.\performance\run-jmeter.ps1 `
  -JMeterHome "D:\apache-jmeter-5.6.3\apache-jmeter-5.6.3" `
  -HostName "127.0.0.1" `
  -Port 8000 `
  -Username "test_user" `
  -Password "Test1234" `
  -Users 1 `
  -RampUp 1 `
  -Duration 30 `
  -ThinkTime 500 `
  -MaxResponseMs 2000
```

第一轮只回答三个问题：

1. 脚本能否成功结束？
2. Error % 是否为 0？
3. HTML 报告能否打开？

这三个问题都通过以后，才运行 5 用户预热和 10 用户基线。不要跳过冒烟直接上高并发。

---

## 24. 官方参考资料

- [Apache JMeter 下载](https://jmeter.apache.org/download_jmeter.cgi)
- [JMeter 入门与非 GUI 执行](https://jmeter.apache.org/usermanual/get-started.html)
- [JMeter 测试计划组件](https://jmeter.apache.org/usermanual/component_reference.html)
- [JMeter HTML Dashboard](https://jmeter.apache.org/usermanual/generating-dashboard.html)
- [JMeter 最佳实践](https://jmeter.apache.org/usermanual/best-practices.html)

---

## 25. 最后记住

```text
先保证功能正确，再谈性能；
先用 1 用户验证脚本，再逐级加压；
线程数不是 QPS，平均值不是 P95；
错误返回得快，不代表性能好；
JMeter 只能看到现象，日志、SQL 和监控才能帮助定位原因；
本机结果只能代表本机条件，不能直接等于生产容量；
没有实测报告，就不要编造性能数字。
```
