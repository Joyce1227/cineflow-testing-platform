# CineFlow JMeter 性能测试说明


## 1. 当前压测场景

每个虚拟用户执行以下流程：

1. 仅登录一次：`POST /api/auth/login`。
2. 从 `$.data.token` 提取 JWT。
3. 循环请求电影列表、热门电影、演员 Top50 和个人推荐。
4. 每个请求断言 HTTP 200，并以默认 2000ms 作为单请求最大响应时间。

四个业务接口在每次循环中各执行一次。场景只读，不创建订单、不锁座，也不修改电影数据，适合反复压测开发或专用测试环境。

## 2. 安装与检查

1. 安装 Java 8 或更高版本。
2. 下载并解压 Apache JMeter 5.6.3，例如到 `D:\tools\apache-jmeter-5.6.3`。
3. 新建系统环境变量 `JMETER_HOME`，值为 JMeter 解压目录。
4. 将 `%JMETER_HOME%\bin` 加入 `Path`。
5. 重新打开 PowerShell，执行：

```powershell
java -version
jmeter -v
```

如果不想修改 `Path`，运行脚本时传入 `-JMeterHome` 即可。

## 3. 先用 GUI 检查

启动 CineFlowAPI 后，在 PowerShell 中执行：

```powershell
cd D:\MovieTicketingAndRecommendationSystem\CineFlowAutoTest
jmeter -t performance\cineflow-api-performance.jmx
```

在 JMeter 左侧依次查看：

- `HTTP Request Defaults`：协议、主机和端口。
- `Login Once Per Virtual User`：登录、HTTP 断言、JWT 提取。
- 四个 GET 请求：实际业务压测接口。
- `JWT Authorization Header`：个人推荐接口的 Bearer Token。

GUI 只用于编辑、调试和 1 个用户的小规模验证，不用于正式压测。调试时可临时添加 `View Results Tree`，确认请求后应删除或禁用它，避免监听器占用大量内存。

## 4. 命令行执行并生成报告

推荐直接运行封装脚本：

```powershell
cd D:\MovieTicketingAndRecommendationSystem\CineFlowAutoTest
Set-ExecutionPolicy -Scope Process Bypass
.\performance\run-jmeter.ps1 -Users 10 -RampUp 10 -Duration 60
```

未设置 `JMETER_HOME` 时：

```powershell
.\performance\run-jmeter.ps1 `
  -JMeterHome "D:\tools\apache-jmeter-5.6.3" `
  -Users 10 `
  -RampUp 10 `
  -Duration 60
```

每次运行会新建独立目录：

```text
reports/jmeter/日期时间/
├─ results.jtl
└─ html/index.html
```

压测完成后用浏览器打开 `html/index.html`。时间戳目录避免 JMeter 因 HTML 输出目录非空而拒绝生成报告。

也可以直接使用原生命令：

```powershell
jmeter -n `
  -t performance\cineflow-api-performance.jmx `
  -l reports\jmeter\results.jtl `
  -e `
  -o reports\jmeter\html `
  -Jhost=127.0.0.1 `
  -Jport=8000 `
  -Jusers=10 `
  -Jramp_up=10 `
  -Jduration=60
```

使用原生命令前，`reports\jmeter\html` 必须不存在或为空。

## 5. 可调整参数

| 脚本参数 | JMeter 属性 | 默认值 | 含义 |
|---|---|---:|---|
| `-Protocol` | `protocol` | `http` | HTTP 协议 |
| `-HostName` | `host` | `127.0.0.1` | 后端地址，不包含协议 |
| `-Port` | `port` | `8000` | 后端端口 |
| `-Username` | `username` | `test_user` | 登录用户名 |
| `-Password` | `password` | `Test1234` | 登录密码 |
| `-Users` | `users` | `10` | 并发虚拟用户数 |
| `-RampUp` | `ramp_up` | `10` | 所有用户启动完成所需秒数 |
| `-Duration` | `duration` | `60` | 持续压测秒数 |
| `-ThinkTime` | `think_time` | `500` | 两次请求间隔毫秒数 |
| `-MaxResponseMs` | `max_response_ms` | `2000` | 单请求超时断言阈值毫秒数 |

例如后端使用 `http://192.168.94.130:8000`：

```powershell
.\performance\run-jmeter.ps1 -HostName 192.168.94.130 -Port 8000 -Users 10 -Duration 60
```

## 6. 建议的阶梯压测

不要一开始就使用 100 用户。每档压测前让服务和数据库恢复 1～2 分钟，并保存报告。

```powershell
# 冒烟：确认脚本、账号、断言都正常
.\performance\run-jmeter.ps1 -Users 1 -RampUp 1 -Duration 30

# 基线
.\performance\run-jmeter.ps1 -Users 10 -RampUp 10 -Duration 120

# 中等负载
.\performance\run-jmeter.ps1 -Users 50 -RampUp 30 -Duration 300

# 压力档
.\performance\run-jmeter.ps1 -Users 100 -RampUp 60 -Duration 300
```

至少记录每档的 Throughput、Error %、Average、90th/95th/99th percentile 和服务端 CPU、内存、MySQL 连接数。性能是否合格应以项目需求为准；当前 2000ms 只是脚本默认断言，不等同于最终 SLA。

## 7. 常见失败定位

- 登录为 401：检查 `test_user / Test1234` 是否存在，或传入正确账号。
- 推荐接口为 401：先看 `POST Login` 是否成功，以及 `Extract JWT` 是否得到 `data.token`。
- 大量 2 秒断言失败：先提高 `-MaxResponseMs` 区分“接口失败”和“暂未达到性能目标”，再分析数据库慢查询、连接池和服务资源。
- `Connection refused`：FastAPI 未启动，或主机/端口传错。
- HTML 报告无法生成：输出目录已存在且非空；使用本项目脚本会自动采用新的时间戳目录。
- 本机同时运行 FastAPI、MySQL 和 JMeter 会互相争用资源；正式结论应由独立压测机请求专用测试环境。

严禁直接对生产环境执行压力测试。
