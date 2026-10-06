# CineFlow CI/CD 与质量门禁

根目录 `.github/workflows/quality-gates.yml` 是主流水线，推送、拉取请求及手动触发时运行。

## 门禁内容

| 门禁 | 自动化内容 | 失败条件 | 产物 |
|---|---|---|---|
| API 测试与覆盖率 | SQLite 下运行全部 API 测试并统计分支覆盖率 | 测试失败或总覆盖率低于 80% | Coverage XML、JUnit XML |
| 安全自动化 | 令牌伪造/过期、RBAC 权限矩阵、订单与评论 IDOR | 任一越权行为未被阻止 | Security JUnit XML |
| 静态与依赖安全 | Bandit 源码扫描、pip-audit 依赖漏洞扫描 | 检出未处理的安全问题 | Actions 日志 |
| AI 质量 | 离线运行 LLM、RAG、Agent 确定性评测 | 质量断言失败 | Allure 原始结果 |
| 前端交付 | 锁定依赖安装并执行生产构建 | TypeScript/Vite 构建失败 | `cineflow-web-dist` |
| 集成回归 | Docker Compose 启动 MySQL、API 与测试容器，执行全量接口及并发测试 | 任一集成测试失败 | Allure、JUnit XML |
| 持续交付 | 默认分支全部门禁通过后构建并推送 API 镜像到 GHCR | 上游门禁或镜像发布失败 | `latest` 与提交 SHA 双标签镜像 |

## 本地执行

```powershell
cd CineFlowAPI
python -m pip install -r requirements-dev.txt
python -m pytest --cov=app --cov-config=.coveragerc --cov-report=term-missing --cov-fail-under=80
python -m pytest -m security
python -m bandit -q -r app
python -m pip_audit -r requirements.txt
```

```powershell
cd CineFlowAutoTest
docker compose up --build --abort-on-container-exit --exit-code-from tests tests
docker compose down -v
```

建议在 GitHub 分支保护中把以下检查设为合并必需：`API tests and coverage gate`、`Security automation`、`Offline AI quality gates`、`Frontend build`、`MySQL integration and concurrency tests`。
