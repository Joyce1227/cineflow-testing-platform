# CineFlow 本机性能监控

这套配置将 CineFlow API 暴露的 Prometheus 指标接入本机 Prometheus 和 Grafana，用于在 JMeter 压测期间观察请求速率、P95 响应时间、5xx 错误率和处理中请求数。

## 1. 启动 API

从仓库根目录执行：

```powershell
docker compose -f .\CineFlowAPI\docker-compose.yml up -d --build
```

确认以下地址可以访问：

- 健康检查：<http://localhost:8000/health>
- 原始指标：<http://localhost:8000/metrics>

## 2. 使用项目配置启动 Prometheus

先关闭当前占用 `9090` 端口的 Prometheus（对应窗口按 `Ctrl+C`），然后执行：

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\monitoring\start-prometheus.ps1
```

打开 <http://localhost:9090/targets>，`cineflow-api` 的状态应为 `UP`。

## 3. 配置 Grafana

1. 打开 <http://localhost:3000>。
2. 进入 **Connections > Data sources > Add data source**，选择 **Prometheus**。
3. Prometheus server URL 填写 `http://localhost:9090`，点击 **Save & test**。
4. 进入 **Dashboards > New > Import**。
5. 上传 `monitoring/grafana/cineflow-api-dashboard.json`，选择刚创建的 Prometheus 数据源并导入。

## 4. 执行压测并观察

保留 API、Prometheus 和 Grafana 运行，然后在新的 PowerShell 窗口执行：

```powershell
.\CineFlowAutoTest\performance\run-performance-suite.ps1 -Profile smoke
```

冒烟通过后再执行标准套件：

```powershell
.\CineFlowAutoTest\performance\run-performance-suite.ps1 -Profile standard
```

Grafana 中选择最近 15 分钟，观察压测期间曲线。JMeter 报告代表客户端视角，Prometheus/Grafana 代表服务端视角，两者应结合分析。

## 常用 PromQL

```promql
# 总请求速率
sum(rate(cineflow_http_requests_total[1m]))

# 全局 P95
histogram_quantile(0.95, sum by (le) (rate(cineflow_http_request_duration_seconds_bucket[5m])))

# 按接口查看 P95
histogram_quantile(0.95, sum by (le, method, route) (rate(cineflow_http_request_duration_seconds_bucket[5m])))

# 5xx 错误率
sum(rate(cineflow_http_requests_total{status=~"5.."}[5m]))
/
clamp_min(sum(rate(cineflow_http_requests_total[5m])), 0.000001)
```
