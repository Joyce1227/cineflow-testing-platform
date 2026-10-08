# CineFlow Testing Platform

[![CineFlow Quality Gates](https://github.com/Joyce1227/cineflow-testing-platform/actions/workflows/quality-gates.yml/badge.svg)](https://github.com/Joyce1227/cineflow-testing-platform/actions/workflows/quality-gates.yml)

以电影票务系统为业务背景构建的测试开发实践项目，包含完整的 Web/API 被测系统、接口自动化、Selenium UI 自动化、JMeter 性能测试、Prometheus/Grafana 监控，以及面向 LLM、RAG、Agent 的 AI 质量测试工作流。

项目重点不是单纯实现电影业务，而是展示如何围绕真实业务链路建立可重复执行、可观测、可追溯的测试体系。

## 项目亮点

- 基于 `pytest + requests + YAML + JSON Schema` 构建分层接口自动化框架。
- 基于 `Selenium + Page Object` 覆盖登录、筛选、选座、下单、支付和退款等 Web 流程。
- 使用 JMeter 实现只读查询、混合购票和同座位并发争抢测试，并自动生成 JTL、HTML、JSON 和 Markdown 报告。
- 通过并发用例发现并修复 InnoDB 锁竞争导致的接口 500，验证多人争抢同一座位时仅一人成功。
- FastAPI 暴露 Prometheus 指标，Grafana 展示请求速率、P95、5xx 错误率和处理中请求数。
- 将 DeepSeek 用于测试设计与失败分析，并通过确定性校验、人工审批和执行白名单控制模型输出风险。
- 使用 Git、Docker Compose 和 GitHub Actions 实现测试环境复现、自动检查及容器镜像交付。

## 整体架构

```text
                         ┌───────────────────────────┐
                         │       CineFlow Web        │
                         │      Vue 3 + TypeScript   │
                         └─────────────┬─────────────┘
                                       │ HTTP
                         ┌─────────────▼─────────────┐
                         │       CineFlow API        │
                         │ FastAPI + SQLAlchemy + JWT│
                         └─────────────┬─────────────┘
                                       │
                                  MySQL / SQLite

      ┌─────────────────────── 测试与质量工程 ───────────────────────┐
      │                                                              │
      │  pytest 接口测试   Selenium UI 测试   JMeter 性能测试          │
      │  Allure/JUnit      Prometheus/Grafana  Docker Compose        │
      │                                                              │
      │  LLM 输出校验  ──  RAG 评测  ──  Agent 工具与安全边界测试      │
      └──────────────────────────────────────────────────────────────┘
```

## 仓库模块

| 目录 | 作用 |
|---|---|
| [`CineFlowAPI`](CineFlowAPI/) | FastAPI 后端、MySQL 数据模型、鉴权、订单及推荐业务 |
| [`CineFlowWeb`](CineFlowWeb/) | Vue 3 用户端与管理端 |
| [`CineFlowAutoTest`](CineFlowAutoTest/) | 接口自动化、并发测试、性能脚本及 AI 质量测试 |
| [`CineFlowWebTest`](CineFlowWebTest/) | Selenium Page Object UI 自动化工程 |
| [`monitoring`](monitoring/) | Prometheus 采集配置、启动脚本及 Grafana 仪表盘 |
| [`.github/workflows`](.github/workflows/) | 自动测试、构建及镜像交付流程 |
| [`docs/api`](docs/api/) | OpenAPI 接口规范 |

## 一、传统自动化测试平台

### 接口与业务测试

接口测试覆盖以下核心模块：

- 注册登录、JWT 过期及伪造校验、RBAC 权限控制。
- 电影分页、筛选、详情、热门榜单及个性化推荐。
- 场次查询、座位状态、锁座及超时释放。
- 幂等下单、支付回调、取消和退款。
- 评论评分、对象级权限校验和统计接口。
- “登录 → 查询 → 选座 → 下单 → 支付 → 评论 → 退款”完整业务链路。

测试代码使用公共 API Client、认证 Fixture、数据驱动用例和 JSON Schema 校验，并结合数据库状态验证订单、座位及支付结果。

### Web UI 自动化

UI 测试采用 Page Object 模式，支持 Chrome、Edge、Firefox 以及 Headless 运行，主要覆盖：

- 登录、错误密码、空表单和退出登录。
- 未登录访问拦截及普通用户访问管理端的权限验证。
- 电影筛选、详情、场次和座位选择。
- 登录、选座、创建订单、支付、退款完整流程。
- 失败自动截图并附加至 Allure 结果。
- 通过 API 注入登录态和清理遗留订单，降低 UI 用例波动。

详细说明见 [`CineFlowWebTest/README.md`](CineFlowWebTest/README.md)。

### 并发与性能测试

JMeter 场景包括：

| 场景 | 验证目标 |
|---|---|
| 只读查询 | 电影列表、热门电影、演员统计及个人推荐 |
| 混合购票 | 查询、下单幂等、支付回调幂等及退款 |
| 同座位争抢 | 多名用户同时购买同一座位，必须恰好一人成功 |

已核验的本机 Docker 稳定性测试结果：

| 场景 | 并发用户 | 持续时间 | 样本数 | 吞吐量 | P95 | P99 | 错误率 |
|---|---:|---:|---:|---:|---:|---:|---:|
| 只读查询 | 50 | 30 分钟 | 168,974 | 93.90 req/s | 39 ms | 61 ms | 0% |
| 混合购票 | 30 | 30 分钟 | 88,494 | 49.21 req/s | 48 ms | 75 ms | 0% |
| 同座位争抢 | 50 | 单轮 | 100 | 66.67 req/s | 700 ms | 734 ms | 0% |

> 测试在单机 Docker 环境中运行，结果用于回归对比和工程能力展示，不代表生产环境容量。同座位场景的整体统计包含登录请求；争抢下单接口本身的 P95 为 448 ms。

性能测试使用说明见 [`CineFlowAutoTest/performance/README.md`](CineFlowAutoTest/performance/README.md)。

### 服务端监控

FastAPI 中间件记录以下 Prometheus 指标：

- HTTP 请求总数及状态码。
- 按接口模板聚合的响应时间直方图。
- 当前正在处理的请求数。

Grafana 仪表盘展示总请求速率、全局及分接口 P95、5xx 错误率和并发处理中请求数。配置方法见 [`monitoring/README.md`](monitoring/README.md)。

## 二、AI 智能接口测试工作流

AI 测试部分将大模型用于测试设计和失败分析，但不会直接执行未经校验的模型输出。

```text
OpenAPI + 业务规则
        ↓
测试设计 Agent
        ↓
YAML 语法 → Pydantic 结构 → OpenAPI 契约 → 业务安全规则
        ↓
人工复核与署名确认
        ↓
pytest 白名单执行器
        ↓
JUnit / pytest 结果解析
        ↓
结果分析 Agent → Markdown 报告
```

### 确定性安全控制

- 模型生成内容必须依次通过四层校验，失败样本进入拒绝报告。
- 测试执行器只允许选择代码内预定义的 `smoke`、`movie`、`regression` 套件。
- 执行命令使用参数数组和 `shell=False`，并设置人工确认人与超时限制。
- 结果分析必须与失败用例 ID 一一对应，否则整份分析结果被拒绝。
- 密钥仅通过本地 `.env` 或 CI Secret 提供，不进入仓库。

### RAG 与 Agent 评测

- RAG：检索召回、Precision@K、拒答准确率、引用有效率及提示注入拒答。
- Agent：工具选择、严格参数校验、只读白名单、轨迹记录和最大执行步数。
- 常规回归使用固定数据与 Scripted/Mock Model，不依赖真实模型费用和网络稳定性。
- 真实 DeepSeek 测试使用独立标记，默认不进入普通测试执行。

完整说明见 [`CineFlowAutoTest/README.md`](CineFlowAutoTest/README.md)。

## 快速开始

### 环境要求

- Python 3.12
- Node.js 22
- Docker Desktop
- 可选：JMeter 5.6.3、Prometheus、Grafana、Allure CLI

### 1. 使用 Docker 启动 API 和 MySQL

```powershell
docker compose -f .\CineFlowAPI\docker-compose.yml up -d --build
```

启动后访问：

- API 健康检查：<http://localhost:8000/health>
- Swagger 文档：<http://localhost:8000/docs>
- Prometheus 原始指标：<http://localhost:8000/metrics>

### 2. 启动 Web

```powershell
Set-Location CineFlowWeb
npm ci
npm run dev
```

浏览器访问 <http://localhost:5173>。

演示账号：

| 角色 | 用户名 | 密码 |
|---|---|---|
| 管理员 | `admin` | `Admin123` |
| 普通用户 | `test_user` | `Test1234` |

账号仅用于本地演示，不应用于真实环境。

## 执行测试

### API 单元与安全测试

```powershell
Set-Location CineFlowAPI
python -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements-dev.txt
.\.venv\Scripts\python.exe -m pytest
```

### Docker 全量接口与集成测试

从仓库根目录执行：

```powershell
docker compose -f .\CineFlowAutoTest\docker-compose.yml `
  up --build --abort-on-container-exit --exit-code-from tests tests
```

完成后清理测试容器和临时数据：

```powershell
docker compose -f .\CineFlowAutoTest\docker-compose.yml down -v
```

### Selenium UI 测试

先确保 API 和 Web 已启动：

```powershell
Set-Location CineFlowWebTest
python -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
.\.venv\Scripts\python.exe -m pytest --headless
```

### JMeter 冒烟套件

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\CineFlowAutoTest\performance\run-performance-suite.ps1 -Profile smoke
```

还可以使用 `standard` 和 `stability` Profile。正式压测应使用非 GUI 模式，并仅针对已授权的测试环境。

### 离线 AI 质量测试

```powershell
Set-Location CineFlowAutoTest
python -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
.\.venv\Scripts\python.exe -m pytest `
  tests/test_llm_client.py `
  tests/test_llm_validation_pipeline.py `
  tests/test_rag_quality.py `
  tests/test_agent_quality.py -q
```

该命令不需要 DeepSeek Key，也不会产生模型调用费用。

## 自动化流程

GitHub Actions 在 push、Pull Request 或手动触发时执行：

1. API 测试及分支覆盖率检查。
2. 认证、RBAC、IDOR 测试以及源码、依赖扫描。
3. 离线 LLM、RAG、Agent 回归测试。
4. Vue 前端构建。
5. MySQL 环境接口与并发集成测试。
6. 默认分支验证通过后构建并发布 API 镜像至 GHCR。

当前流程完成持续集成和容器镜像交付，不包含自动部署到生产环境。

## 测试设计原则

- 模型生成的测试内容不能绕过确定性校验和人工复核。
- 并发测试同时验证响应结果和数据库最终状态。
- UI 页面优先使用稳定的 `data-testid`，动态内容使用显式等待。
- 性能测试数据与日常数据隔离，并提供定向清理脚本。
- 测试报告、缓存、虚拟环境、本地密钥和 Prometheus 时序数据不提交仓库。
- 不对生产数据库执行测试数据清理或未经授权的压力测试。

## 更多文档

- [FastAPI 后端说明](CineFlowAPI/README.md)
- [接口与 AI 测试说明](CineFlowAutoTest/README.md)
- [Web 前端说明](CineFlowWeb/README.md)
- [Selenium UI 测试说明](CineFlowWebTest/README.md)
- [性能测试说明](CineFlowAutoTest/performance/README.md)
- [Prometheus/Grafana 监控说明](monitoring/README.md)

## 项目定位

本仓库用于测试开发、自动化测试、性能测试和 AI 质量工程学习与实践。所有演示账号、测试数据和默认密钥仅适用于本地环境；部署到共享或生产环境前必须替换密钥、关闭自动造数并使用正式的数据库迁移和凭证管理方案。
