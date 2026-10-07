# CineFlow 性能测试工程

本目录提供可重复执行的 JMeter 性能测试，而不是只用于演示的单接口脚本。正式测试前必须启动 CineFlow API 和 MySQL，并且只能对已授权的测试环境执行。

## 场景

| 场景 | JMX | 验证目标 |
|---|---|---|
| `readonly` | `cineflow-api-performance.jmx` | 登录一次后循环执行电影列表、热门电影、演员统计和个人推荐 |
| `booking` | `cineflow-booking-performance.jmx` | 每用户独立座位，循环执行查询、下单幂等、支付回调幂等和退款 |
| `contention` | `cineflow-seat-contention.jmx` | 所有用户同时购买同一座位，必须恰好一个 `201`，其余均为 `409` |

`booking` 和 `contention` 会自动创建隔离的电影、影院、场次、座位和用户，不使用日常测试数据。JMeter CSV 中每个线程有独立账号；购票场景使用不同座位，争抢场景使用同一个座位。

## 文件说明

```text
performance/
├─ cineflow-api-performance.jmx
├─ cineflow-booking-performance.jmx
├─ cineflow-seat-contention.jmx
├─ prepare_performance_data.py
├─ cleanup_performance_data.py
├─ summarize_jtl.py
├─ run-performance.ps1
├─ run-performance-suite.ps1
├─ cleanup-performance-data.ps1
└─ PERFORMANCE_REPORT_TEMPLATE.md
```

## 环境检查

```powershell
java -version
& "D:\apache-jmeter-5.6.3\apache-jmeter-5.6.3\bin\jmeter.bat" -v
python -m pip install -r CineFlowAutoTest\requirements.txt
```

不要使用 JMeter GUI 正式压测。GUI 只用于脚本调试，正式测试必须使用非 GUI 命令。

## 一键冒烟

从仓库根目录执行：

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\CineFlowAutoTest\performance\run-performance-suite.ps1 -Profile smoke
```

冒烟套件依次运行：

- 1 用户只读场景，15 秒。
- 2 用户混合购票场景，15 秒。
- 5 用户同座位争抢，单轮。

## 标准与稳定性套件

```powershell
# 标准测试，约 5 分钟
.\CineFlowAutoTest\performance\run-performance-suite.ps1 -Profile standard

# 30 分钟稳定性测试，运行前确保电脑空闲
.\CineFlowAutoTest\performance\run-performance-suite.ps1 -Profile stability
```

## 单独运行场景

```powershell
# 只读查询基线
.\CineFlowAutoTest\performance\run-performance.ps1 `
  -Scenario readonly -Users 10 -RampUp 10 -Duration 120

# 混合购票链路；自动准备 20 个用户和独立座位
.\CineFlowAutoTest\performance\run-performance.ps1 `
  -Scenario booking -Users 20 -RampUp 20 -Duration 120

# 50 个用户同时抢同一座位
.\CineFlowAutoTest\performance\run-performance.ps1 `
  -Scenario contention -Users 50 -RampUp 0 -Duration 1
```

如果 JMeter 不在默认目录，也没有设置 `JMETER_HOME`：

```powershell
.\CineFlowAutoTest\performance\run-performance.ps1 `
  -JMeterHome "D:\tools\apache-jmeter-5.6.3" `
  -Scenario readonly -Users 10 -Duration 60
```

## 测试报告

每次运行生成独立目录：

```text
CineFlowAutoTest/reports/jmeter/场景-时间戳/
├─ results.jtl
├─ jmeter.log
├─ summary.json
├─ summary.md
└─ html/index.html
```

`summarize_jtl.py` 会计算样本数、错误率、吞吐量、Average、P90、P95、P99 和 Max。默认错误率门禁为 0%；可以使用 `-MaxErrorRate` 明确调整，但不能为了让报告变绿而掩盖未知错误。

同座位竞争中的 `409` 是预期业务结果，JMX 会将它标记为成功；任何 `500`、超时或“成功买到座位的人数不等于 1”都会使质量门禁失败。

## 清理测试数据

每次写场景都会生成 `data/metadata.json`。清理脚本只删除该文件记录的用户、场次和订单，并默认拒绝远程数据库：

```powershell
.\CineFlowAutoTest\performance\cleanup-performance-data.ps1 `
  -Metadata ".\CineFlowAutoTest\reports\jmeter\suite-smoke-时间戳\data\metadata.json" `
  -DatabaseUrl "mysql+pymysql://root:root@127.0.0.1:3307/cineflow_test?charset=utf8mb4"
```

远程测试库必须确认已授权后显式传入 `-AllowRemote`。禁止对生产数据库运行清理脚本。

## 建议执行顺序

1. 运行 `smoke`，确认脚本、账号、断言和数据清理正常。
2. 运行 `standard`，获取只读、购票和竞争场景基线。
3. 分别执行 10、30、50、100 用户阶梯压测，关键档位重复三次。
4. 找到 P95 或错误率明显恶化的性能拐点。
5. 在电脑空闲时执行 `stability`。
6. 结合服务端 CPU、内存、数据库连接数和慢 SQL 定位瓶颈。
7. 优化后用完全相同参数复测，并填写 `PERFORMANCE_REPORT_TEMPLATE.md`。

本机同时运行 JMeter、API 和 MySQL 时会争抢资源，得到的数据只能代表当前本机环境，不能直接等同于生产容量。
