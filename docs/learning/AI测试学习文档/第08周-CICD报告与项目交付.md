# 第 8 周：CI/CD、报告与项目交付

## 本周目标

前七周已经分别学习了模型 API、结构校验、RAG、Agent、评测、安全和性能。本周把它们连成一套能够持续运行的工程。

最终目标不是得到一堆互不相关的脚本，而是：

```text
开发人员修改代码或 Prompt
  ↓
CI 自动准备环境
  ↓
执行快速、稳定、低成本测试
  ↓
重要版本执行真实模型评测和安全测试
  ↓
生成可追溯报告
  ↓
质量门禁决定能否发布
  ↓
失败结果可以复现、定位和回归
```

## 本周最终产物

完成 CineFlow AI 测试项目的最终交付包：

- 分层测试策略。
- PR、合并、定时和发布流水线设计。
- pytest、AI Eval、AI Security、JMeter 报告。
- 自动化质量门禁。
- 基线与候选版本对比。
- 失败复现包。
- 项目 README、架构图和目录说明。
- 10 分钟项目演示脚本。
- 简历描述和面试问题准备。

---

# 第 1 天：整理完整测试架构

## 1.1 不要让所有测试每次都运行

测试的速度、成本和稳定性不同：

```text
Pydantic 单元测试：毫秒级、稳定、免费
Mock Agent 测试：快、稳定、免费
真实模型 Eval：慢、有费用、有随机性
AI 红队：更慢、请求量多
JMeter 性能测试：占资源、运行时间长
```

如果每次改一个注释都运行完整红队和性能测试，流水线会非常慢且昂贵。

## 1.2 AI 测试金字塔

从底到顶：

```text
                    少量人工探索
                 真实模型端到端评测
              安全红队与受控性能测试
           RAG / Agent 离线回归测试
        API 契约、集成与数据库测试
     Pydantic、评分器、工具策略单元测试
```

底层测试多、快、稳定；上层测试少、慢、成本高，但更接近真实行为。

## 1.3 测试层级

### L0：纯单元测试

- Pydantic 模型
- JSON/YAML 解析
- OpenAPI 路径校验
- 评分器
- 成本公式
- 权限白名单
- 金丝雀扫描

不启动后端，不调用真实模型。

### L1：Mock/Fake 集成测试

- Fake 模型产生固定 Tool Call
- Mock Embedding
- Mock 检索结果
- Mock 429、503、超时
- Agent 循环和 Trace

稳定验证异常路径。

### L2：CineFlow API 集成测试

- 启动 FastAPI 和测试数据库
- 运行现有 pytest 接口回归
- Agent 工具调用真实测试 API
- 不调用生产环境

### L3：真实模型离线评测

- 固定黄金数据集
- 小规模真实模型调用
- Prompt/模型版本对比
- Token 和成本限制

### L4：安全与性能

- 安全红队
- RAG 污染
- 跨用户测试
- JMeter 和 AI 并发
- 稳定性与故障注入

## 1.4 测试标记

可以逐步扩展 pytest markers：

```ini
markers =
    smoke: 核心冒烟测试
    regression: 完整功能回归
    ai_unit: 不调用真实模型的 AI 单元测试
    ai_mock: 使用 Fake/Mock 的 AI 集成测试
    ai_online: 调用真实模型的评测
    ai_security: AI 安全测试
    performance: 性能测试入口
    serial: 必须串行运行
```

这样可以选择：

```powershell
python -m pytest -m "ai_unit or ai_mock"
python -m pytest -m ai_online
python -m pytest -m ai_security
```

## 1.5 依赖方向

测试代码不要反过来依赖某次运行生成的临时报告。推荐：

```text
测试数据 → Runner → 原始结果 → Scorer → 汇总报告 → Gate
```

每一层输入输出明确，失败后可以单独重跑评分，不必重新花钱调用模型。

### 第 1 天验收

- [ ] 能画出 AI 测试金字塔。
- [ ] 能区分 L0～L4 的测试内容。
- [ ] 快速测试和真实模型测试不会混在一起。
- [ ] 测试可以通过 marker 分组运行。
- [ ] 原始结果与评分、报告分离。

---

# 第 2 天：设计 CI/CD 流水线

## 2.1 CI 和 CD 是什么

### CI：持续集成

每次提交代码后自动构建和测试，尽早发现问题。

### CD：持续交付或部署

测试通过后，让版本处于可发布状态，或者按流程部署。

当前学习项目重点是 CI 和“发布门禁”，不需要自动部署到真实生产环境。

## 2.2 当前项目已有流水线

`CineFlowAutoTest/.github/workflows/api-tests.yml` 已经完成：

```text
检出代码
→ Docker Compose 构建 API 和测试环境
→ 运行 pytest
→ 上传 Allure 原始结果
→ 清理容器和测试数据卷
```

这是很好的基础，不要推倒重来。

## 2.3 推荐四类流水线

### Pull Request 快速检查

每次 PR 运行：

- 单元测试
- YAML/JSON/Pydantic 校验
- Mock RAG 和 Agent
- 权限与评分器测试
- 不调用真实模型
- 目标：快、稳定、免费

### 主分支回归

合并后运行：

- Docker Compose API 回归
- 测试数据库
- RAG 检索回归
- Agent Fake 集成测试
- 安全确定性测试

### 定时或手动真实模型评测

- 使用 CI Secret
- 有预算和最大用例数
- 固定模型、Prompt、数据集
- 重复执行关键用例
- 上传脱敏结果

### 发布前安全与性能

- 完整黄金集
- AI 安全红队
- 少量真实模型并发
- Mock 大负载
- JMeter 工具接口性能
- 人工风险评审

## 2.4 为什么真实模型测试不适合每个 PR 都跑

- 有费用
- 存在限流
- 输出有随机性
- 外部服务波动会造成假失败
- Fork PR 不能安全获取 Secret
- 大量并发可能违反服务约束

所以 PR 主要使用 Fake/Mock；真实模型用手动、定时或受保护环境运行。

## 2.5 一个教学版 GitHub Actions 分层示例

```yaml
name: CineFlow AI Tests

on:
  pull_request:
  push:
    branches: [main]
  workflow_dispatch:
    inputs:
      run_online_eval:
        description: Run real-model evaluation
        required: true
        default: false
        type: boolean

jobs:
  fast-ai-tests:
    runs-on: ubuntu-latest
    timeout-minutes: 10
    defaults:
      run:
        working-directory: CineFlowAutoTest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.12"
      - run: python -m pip install -r requirements.txt
      - run: python -m pytest -m "ai_unit or ai_mock"
      - name: Upload test artifacts
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: ai-fast-results
          path: CineFlowAutoTest/reports/

  online-eval:
    if: github.event_name == 'workflow_dispatch' && inputs.run_online_eval
    runs-on: ubuntu-latest
    timeout-minutes: 30
    defaults:
      run:
        working-directory: CineFlowAutoTest
    env:
      LLM_API_BASE: ${{ secrets.LLM_API_BASE }}
      LLM_API_KEY: ${{ secrets.LLM_API_KEY }}
      LLM_MODEL: ${{ secrets.LLM_MODEL }}
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.12"
      - run: python -m pip install -r requirements.txt
      - run: python -m pytest -m ai_online
```

这是学习模板，真正接入前要根据实际目录、marker 和 Secret 名称调整。

## 2.6 Secret 安全

- Secret 只放 CI Secret 管理。
- 不在 YAML 中写真实 Key。
- 不打印全部环境变量。
- Fork PR 不运行带 Secret 的不可信代码。
- 上传 Artifact 前扫描 Secret。
- Key 泄露后立即撤销和轮换。

## 2.7 取消旧运行

频繁提交时，旧版本流水线可能没有继续运行价值。可以设计并发组取消旧任务，减少费用和排队，但发布流水线和重要长测是否取消需要单独判断。

### 第 2 天验收

- [ ] 能解释 CI 和 CD。
- [ ] PR 默认不调用真实付费模型。
- [ ] 真实模型评测只能在受保护的手动或定时任务运行。
- [ ] Secret 不进入代码、日志和 Artifact。
- [ ] 了解当前 API 流水线可以继续复用。
- [ ] 不会让 Fork PR 获得真实模型 Secret。

---

# 第 3 天：统一测试报告与 Artifact

## 3.1 为什么不能只有控制台输出

控制台输出容易丢失，而且不适合比较版本。完整交付需要：

```text
执行配置
每条用例结果
失败证据
汇总指标
基线对比
趋势
可读结论
```

## 3.2 报告目录建议

```text
CineFlowAutoTest/reports/
├─ allure-results/
├─ ai-eval/
│  └─ run-id/
│     ├─ run.json
│     ├─ case-results.jsonl
│     ├─ failures.jsonl
│     ├─ summary.json
│     └─ report.md
├─ ai-security/
│  └─ run-id/
├─ ai-performance/
│  └─ run-id/
└─ jmeter/
   └─ timestamp/
```

不要把真实 Key、完整 JWT、密码或未脱敏隐私放进报告。

## 3.3 Allure 用来展示什么

现有 pytest 已输出：

```text
reports/allure-results
```

可以在 AI 测试中附加：

- case_id
- category
- model
- prompt_version
- dataset_version
- 输入脱敏摘要
- 工具 Trace 摘要
- 各指标得分
- 失败原因

不要把 30,000 字模型上下文全部塞进 Allure 附件。

## 3.4 报告至少有三层

### 管理摘要

回答：能不能发布？主要风险是什么？

### 指标明细

回答：哪些类别变好或变差？

### 单条证据

回答：具体哪条用例失败，怎样复现？

## 3.5 AI Eval 报告模板

```markdown
# CineFlow AI 评测报告

## 结论
- 发布建议：通过 / 阻止 / 需人工评审
- 核心原因：

## 版本
- 应用：
- 模型：
- Prompt：
- 数据集：
- 知识库：
- 评分器：

## 总体指标
- 任务成功率：
- 事实正确率：
- 引用合法率：
- Tool Selection Accuracy：
- 安全 ASR：
- P95 延迟：
- 平均成功任务成本：

## 与基线比较
| 指标 | 基线 | 候选 | 变化 | 门禁 |

## 分类结果
| 类别 | 通过率 | 失败数 | 主要原因 |

## Critical 失败

## 已知限制

## 下一步
```

## 3.6 Artifact 保留策略

决定：

- 保留多久
- 哪些结果长期保留为基线
- 哪些原始响应必须脱敏
- 谁可以下载
- 超大文件如何处理
- 失败和成功是否使用不同保留周期

报告不是越多越好；要可定位，同时符合隐私和成本要求。

## 3.7 自动摘要不能替代证据

可以让模型生成报告摘要，但摘要必须来自已有结构化指标，且不允许模型改写测试是否通过。

正确关系：

```text
评分器和 Gate 决定通过失败
→ 模型将结果整理成易读文字
```

不是：

```text
模型看完日志后凭感觉决定整个版本通过
```

### 第 3 天验收

- [ ] 报告包含配置、明细、失败和汇总。
- [ ] 管理摘要、指标明细和单条证据分层展示。
- [ ] Allure 附件经过长度限制和脱敏。
- [ ] Artifact 有权限和保留周期。
- [ ] 模型只能摘要，不能覆盖确定性 Gate 结论。

---

# 第 4 天：质量门禁、基线和不稳定测试

## 4.1 Gate 是什么

Gate 是自动决定“是否满足进入下一阶段条件”的规则。

示例：

```text
Pydantic/Schema 成功率 >= 98%
RAG 引用合法率 = 100%
跨用户泄露 = 0
禁止工具真实执行 = 0
Critical ASR = 0%
P95 延迟不比基线退化超过约定比例
平均成功任务成本不比基线上涨超过约定比例
```

## 4.2 门禁分为三类

### 必须通过

- Secret 泄露
- 越权
- 支付/退款误执行
- 核心业务规则

失败一次就阻止。

### 阈值通过

- 任务成功率
- Tool Selection Accuracy
- RAG Recall@K
- 延迟和成本

### 人工评审

- 表达风格变化
- 边缘业务需求
- Judge 与人工严重分歧
- 指标刚好接近门槛

## 4.3 基线不能随便覆盖

候选版本没有通过门禁时，不能把它保存为新基线，否则下次比较会掩盖退化。

更新基线至少要：

- 所有关键门禁通过
- 报告经过审核
- 记录变更原因
- 保存原基线以便回滚

## 4.4 AI 随机性和 Flaky Test

真实模型测试有时通过、有时失败。不要简单粗暴地：

```text
失败就无限重跑，直到通过
```

这会隐藏真实不稳定性。

正确处理：

- 记录每次运行结果。
- 固定可固定的参数。
- 关键用例重复运行并统计比例。
- 区分外部服务故障与质量失败。
- 设有限重试，只处理明确的临时网络错误。
- 对不稳定用例调查根因。

## 4.5 门禁伪代码

```python
def evaluate_gates(summary: dict, baseline: dict) -> list[dict]:
    gates = []

    gates.append({
        "name": "no_secret_leak",
        "passed": summary["secret_leak_count"] == 0,
        "actual": summary["secret_leak_count"],
        "expected": 0,
    })

    gates.append({
        "name": "task_success_rate",
        "passed": summary["task_success_rate"] >= 0.90,
        "actual": summary["task_success_rate"],
        "expected": ">= 0.90",
    })

    allowed_p95 = baseline["p95_ms"] * 1.10
    gates.append({
        "name": "p95_regression",
        "passed": summary["p95_ms"] <= allowed_p95,
        "actual": summary["p95_ms"],
        "expected": f"<= {allowed_p95}",
    })

    return gates
```

阈值只是代码示例，应该使用项目实际基线和团队约定。

## 4.6 回滚和证据

发布后发现严重退化时，需要知道：

- 上一个通过门禁的版本是什么
- Prompt、模型、知识库和代码分别是什么版本
- 怎样恢复
- 哪些用户受到影响
- 哪条测试本应发现它

版本不完整就无法可靠回滚。

### 第 4 天验收

- [ ] 知道 Gate 的作用。
- [ ] 能区分必须通过、阈值和人工评审门禁。
- [ ] 未通过的候选不会覆盖基线。
- [ ] 不使用无限重跑掩盖模型不稳定。
- [ ] 回滚所需代码、Prompt、模型和知识库版本都有记录。

---

# 第 5 天：失败复现、缺陷和回归闭环

## 5.1 AI 缺陷报告需要更多上下文

普通 Bug：

```text
接口返回 500
```

AI Bug 还可能与下面内容有关：

- 模型版本
- Prompt 版本
- Temperature
- 对话历史
- 知识库版本
- 检索结果
- Tool Trace
- 随机性
- 外部服务状态

## 5.2 AI 缺陷模板

```text
标题：[AI][退款规则] 模型错误声称退款后座位保持 LOCKED

严重等级：High
环境：本地测试 / CI
应用版本：
模型与参数：
Prompt 版本：
知识库版本：
数据集版本：
case_id：rag_refund_003
trace_id：

输入：脱敏后的用户问题
期望：座位恢复 AVAILABLE，并引用指定规则
实际：回答座位保持 LOCKED

检索结果：
工具轨迹：
评分器证据：
重复次数：5
复现次数：3

初步分类：检索 / 生成 / 工具 / 权限 / 评分器 / 环境
附件：脱敏结果文件
```

## 5.3 最小复现包

包含：

- 单条测试用例
- 必需的最小知识片段
- Fake 模型响应或真实模型参数
- Prompt 版本
- 工具 Mock
- 执行命令
- 预期和实际结果

不要要求排查人员启动整个生产环境才能复现一个评分器错误。

## 5.4 先分类再修复

```text
语法错误 → 结构化输出或解析
结构错误 → Pydantic/Schema
假接口 → OpenAPI 契约
错误文档 → 知识库
正确文档未召回 → 检索
召回正确但答错 → 生成 Prompt/模型
错误工具 → 工具描述或模型选择
越权执行 → 权限和分发器
评分不合理 → Scorer/Judge Rubric
偶发超时 → 性能和依赖稳定性
```

不要所有问题都通过“再加一句 Prompt”解决。

## 5.5 修复完成的标准

不是只让原始用例通过：

1. 原始失败可复现。
2. 找到根因。
3. 添加最小回归测试。
4. 修复程序或配置。
5. 原始用例通过。
6. 同类用例通过。
7. 正常控制样本没有被误伤。
8. 安全、性能和成本没有不可接受退化。
9. 记录修复版本。

## 5.6 模型升级的缺陷归属

模型升级后出现变化，不应简单写“模型不稳定”。需要判断：

- 提供商模型行为变化
- Prompt 与新模型不兼容
- 结构化输出字段变化
- Tool Calling 格式变化
- Judge 评分变化
- 知识库或测试数据变化

证据越完整，越容易定位。

### 第 5 天验收

- [ ] AI 缺陷记录模型、Prompt、知识库和数据集版本。
- [ ] 能建立最小复现包。
- [ ] 会区分检索、生成、工具、权限、评分和环境问题。
- [ ] 修复后同时运行同类和正常控制测试。
- [ ] 不把所有问题统称为“模型不稳定”。

---

# 第 6 天：项目文档、演示与面试表达

## 6.1 最终 README 应该回答什么

1. 项目解决什么问题？
2. 为什么需要 AI 测试？
3. 系统架构是什么？
4. 怎样启动？
5. 怎样运行不同层测试？
6. 报告在哪里？
7. 有哪些安全边界？
8. 当前已知限制是什么？

## 6.2 最终架构图

可以画成：

```text
用户
 ↓
CineFlow AI Assistant
 ├─ Prompt Registry
 ├─ RAG Retriever ── Knowledge Base
 ├─ Agent Dispatcher
 │   └─ Read-only Tools ── CineFlowAPI ── Test DB
 ├─ Safety Policy
 └─ Trace / Token / Cost Collector

AI Test Platform
 ├─ Golden Dataset
 ├─ Deterministic Scorers
 ├─ LLM Judge
 ├─ Security Red Team
 ├─ Performance Runner
 ├─ Reports
 └─ CI Quality Gates
```

## 6.3 10 分钟演示脚本

### 第 1 分钟：业务背景

说明 CineFlow 是电影票务与推荐系统，AI 功能包括规则问答、电影查询和只读工具调用。

### 第 2～3 分钟：AI 架构

展示 RAG、Agent、只读工具和安全边界。

### 第 4～5 分钟：评测数据和评分

展示一条黄金用例、确定性评分和 LLM Judge 的分工。

### 第 6 分钟：安全失败

演示 Prompt Injection 请求被工具白名单阻止，展示 Trace。

### 第 7 分钟：RAG 失败定位

演示如何区分“没召回正确文档”和“召回正确但模型答错”。

### 第 8 分钟：性能和成本

展示真实生成的 P95、Token 和分阶段耗时报告。没有实测就不要展示虚构数字。

### 第 9 分钟：CI 和 Gate

展示 PR 快速测试、真实模型手动评测和关键门禁。

### 第 10 分钟：总结

说明已知限制和下一步计划。

## 6.4 简历描述模板

只保留你真正完成的内容：

> 基于 FastAPI、pytest 和 OpenAI 兼容模型接口构建 CineFlow AI 质量评测体系，覆盖电影规则 RAG、只读 Tool Calling Agent、黄金数据集、Prompt 回归与安全红队测试。使用 Pydantic、OpenAPI、数据库事实和工具 Trace 完成确定性校验，结合经人工样本校准的 LLM Judge 评估相关性与完整性；通过 Mock 与真实模型分层测试统计任务成功率、RAG Recall@K、工具选择准确率、ASR、P95 延迟和 Token 成本，并在 CI 中设置敏感数据泄露、越权工具调用等发布门禁。

不要写没有实际完成或没有报告证据的指标。

## 6.5 面试讲述结构

使用 STAR 或“问题—方案—证据—改进”：

```text
问题：大模型输出随机，传统字符串断言不适用。
方案：黄金集 + 硬规则 + Judge + 重复运行。
证据：版本对比报告和失败样本。
改进：扩大安全与无答案测试集，增加线上反馈闭环。
```

## 6.6 必须敢于说明限制

可以诚实说明：

- 当前主要使用测试数据，不代表生产流量。
- Agent 只开放只读工具。
- Judge 仍可能有偏差，所以有人工作为校准。
- 本机性能结果只用于相同环境回归。
- 知识库规模有限。

能明确边界比夸大项目更专业。

### 第 6 天验收

- [ ] README 能指导陌生人运行项目。
- [ ] 架构图显示模型、RAG、Tool 和测试平台关系。
- [ ] 有可在 10 分钟完成的演示脚本。
- [ ] 简历只写实际完成且有证据的内容。
- [ ] 能用问题、方案、证据和改进讲项目。
- [ ] 敢于说明当前限制。

---

# 第 7 天：最终毕业项目

## 7.1 最终交付清单

### AI 应用

- [ ] OpenAI 兼容模型客户端。
- [ ] Prompt 版本管理。
- [ ] 结构化输出。
- [ ] CineFlow 规则 RAG。
- [ ] 只读 Agent 和工具白名单。
- [ ] Trace、Token、延迟和成本记录。

### 数据和评测

- [ ] 至少 60 条黄金测试数据。
- [ ] dev、regression、holdout 分开。
- [ ] 至少 5 个确定性评分器。
- [ ] 一个经过人工样本校准的 Judge Rubric。
- [ ] 基线与候选版本对比。
- [ ] 重要用例重复执行。

### 安全

- [ ] 威胁模型和风险登记表。
- [ ] 至少 60 条安全与正常控制样本。
- [ ] 直接和间接 Prompt Injection。
- [ ] 工具越权和跨用户隔离。
- [ ] 测试金丝雀泄露检测。
- [ ] 输出和日志安全。
- [ ] Critical 一票否决。

### 性能

- [ ] TTFT 和总延迟。
- [ ] P50/P95/P99。
- [ ] 分阶段耗时。
- [ ] Mock 阶梯并发。
- [ ] 少量真实模型验证。
- [ ] JMeter 业务工具接口测试。
- [ ] 故障注入和重试验证。
- [ ] 成功任务成本。

### 工程化

- [ ] 快速 PR 测试。
- [ ] Docker Compose API 回归。
- [ ] 手动或定时真实模型 Eval。
- [ ] 报告 Artifact。
- [ ] 自动化质量 Gate。
- [ ] 失败最小复现包。
- [ ] README、架构图和演示脚本。

## 7.2 推荐执行顺序

```text
1. 启动测试数据库和 CineFlowAPI
2. 运行普通 API smoke
3. 运行 AI unit 和 mock
4. 运行 API regression
5. 运行 RAG 和 Agent 离线 Eval
6. 在有授权和预算时运行真实模型 Eval
7. 运行 AI Security
8. 运行 Mock 性能和 JMeter
9. 汇总报告
10. 执行 Gate
11. 人工检查 Critical 失败和已知限制
```

## 7.3 项目答辩时必须能现场解释

- 为什么不直接比较模型回答字符串？
- 为什么硬事实不用 LLM Judge 判断？
- RAG 的检索错误和生成错误怎样区分？
- 为什么 Tool Call 不能直接执行？
- 如何防止模型查询其他用户订单？
- 为什么安全测试还要测误拒绝？
- 为什么大并发使用 Mock 模型？
- 如何计算一次 Agent 的总成本？
- 为什么 PR 不默认调用真实模型？
- 候选版本总分上升，为什么仍可能阻止发布？

## 7.4 毕业标准

不是文档全部读完，而是你能够：

1. 从零解释 CineFlow AI 应用的数据流。
2. 独立运行一条 RAG 和一条 Agent 测试。
3. 展示一条失败的完整证据。
4. 说明失败属于检索、生成、工具、权限还是环境。
5. 比较两个 Prompt 或模型版本。
6. 证明危险工具没有被执行。
7. 展示真实生成的性能和成本报告。
8. 通过 CI 重复得到相同类型结果。
9. 诚实说明项目限制和下一步。

## 7.5 下一步方向

完成八周后，可以继续选择一个方向深入：

### AI 测试开发

- 扩展评测平台
- 自定义 Scorer
- 数据集管理
- CI 门禁
- 线上质量监控

### AI 安全测试

- 更系统的红队数据集
- Agent 权限和沙箱
- RAG 污染检测
- 安全事件响应

### 推荐系统测试

- Precision@K、Recall@K、NDCG
- 覆盖率、多样性、新颖性
- 热门偏置和冷启动
- 数据漂移

### AI 性能工程

- 流式输出
- 队列和并发控制
- 模型路由
- 缓存与成本优化
- 全链路 Trace

---

# 本周自测题

## 题目

1. 为什么不能让完整真实模型红队测试在每个 PR 都运行？
2. PR 最适合运行哪些 AI 测试？
3. 为什么原始结果和评分应该分开保存？
4. 模型生成的报告摘要能不能决定发布？
5. 候选版本未通过时，为什么不能把它覆盖成新基线？
6. AI 测试偶发失败时，为什么不能无限重跑直到通过？
7. 一个可复现的 AI 缺陷需要记录哪些版本？
8. 为什么架构图中要同时画 AI 应用和 AI 测试平台？
9. 本机性能数字应该怎样表述？
10. 项目简历为什么不能写没有实际执行的数据？

## 参考答案

1. 成本高、速度慢、有随机性、依赖外部服务，也涉及 Secret 安全。
2. Pydantic、评分器、权限、Mock RAG 和 Fake Agent 等快速稳定测试。
3. 可以在不重新调用模型的情况下修复或更换评分器，并保留审计证据。
4. 不能，发布结论应由确定性 Gate 和明确阈值决定，模型只负责整理文字。
5. 会掩盖退化，让后续比较失去可信参考。
6. 会隐藏真实不稳定性，还可能造成选择性保留最好结果。
7. 代码、模型、Prompt、知识库、数据集和评分器版本，以及参数和 Trace。
8. 展示被测系统和测试系统的边界、数据流及责任分工。
9. 明确是特定本机与测试环境下的基线，只用于同环境比较，不代表生产容量。
10. 无证据指标容易在面试追问中暴露，也是不诚实的工程结论。

---

# 最终面试总结

可以用下面这段作为项目总述，再根据真实完成内容删减：

> CineFlow 原本是一套电影票务、推荐和自动化测试系统。我在此基础上增加了电影规则 RAG 与只读 Tool Calling Agent，并围绕大模型非确定性建立 AI 质量评测体系。测试数据采用版本化黄金集，覆盖事实问答、推荐、无答案、多轮、工具调用和安全场景；评测上将 Pydantic、OpenAPI、数据库事实、RAG 引用和工具 Trace 等确定性判断，与经过人工校准的 LLM Judge 分开。安全侧通过身份上下文、工具白名单、参数校验和知识权限阻止注入、越权与跨用户泄露；性能侧记录 TTFT、P95、分阶段耗时、Token 和成功任务成本。最后将快速 Mock 测试、API 回归、真实模型 Eval、安全红队和性能测试分层接入 CI，并以关键安全项一票否决和基线回归作为发布门禁。

# 八周最重要的一句话

> 一个可信的 AI 项目，不是“模型能回答”，而是质量、安全、性能、成本和每次变更都有可复现的证据。

