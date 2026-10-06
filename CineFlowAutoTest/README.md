# CineFlow AI 质量测试工程

本项目使用 CineFlow 电影票务系统作为被测业务背景，目标不是继续开发电影业务，而是构造一个最小的 LLM、RAG、只读 Agent 原型，并围绕模型输出、知识检索、工具调用和安全边界建立可重复执行的 AI 质量测试体系。传统 API 与 Schema 测试仍然保留，因为它们提供确定性的业务事实基线和 Agent 工具契约。

## 质量体系

```text
用户问题 / 模型生成内容
        │
        ├─ LLM 结构化输出：YAML 语法 → Pydantic 结构 → OpenAPI → 业务安全规则
        ├─ RAG：知识分块 → 本地检索 → 有依据回答/拒答 → 引用真实性校验
        └─ Agent：工具选择 → 严格参数 → 只读白名单 → 轨迹/步数/结果校验
                                      │
                         CineFlow API 契约与回归测试基线
```

核心目录：

```text
CineFlowAutoTest/
├─ agent/                 最小只读 Agent、工具白名单、执行轨迹和组装工厂
├─ ai_testing/            测试设计/结果分析 Agent、结果解析与 Markdown 报告
├─ ai_knowledge/source/   退款、支付、推荐、评论和购票规则知识源
├─ evals/datasets/        结构化输出与 RAG 的正式评测数据集
├─ llm/                   模型客户端、用例生成和四层输出校验流水线
├─ workflows/             带人工审批断点的功能测试工作流
├─ rag/                   分块、检索、问答、引用校验和评测指标
├─ tests/                 AI 质量测试以及 CineFlow API 事实基线测试
├─ cases/、schemas/       数据驱动接口契约基线
└─ performance/           只读接口性能基线
```

完整功能测试闭环：

```text
OpenAPI + 业务规则
        ↓
测试设计 Agent
  ├─ 结构化测试计划
  └─ YAML 候选用例
        ↓
四层确定性校验
        ↓
人工复核与署名确认
        ↓
pytest 白名单执行器 ──→ JUnit + Allure
        ↓
结果分析 Agent
        ↓
结构化分析 + Markdown 报告
```

功能测试工作流只包含两个 AI Agent：测试设计 Agent 和结果分析 Agent。确定性能力分为 OpenAPI/规则读取、YAML 四层校验、pytest 白名单执行、JUnit/pytest 结果读取四类工具；现有电影问答 Agent 只作为 RAG 与 Agent 质量测试的被测原型，不参与功能测试编排。

## 安装与运行

```powershell
cd D:\MovieTicketingAndRecommendationSystem\CineFlowAutoTest
D:\Python3.12.9\python.exe -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
Copy-Item .env.example .env

# 不连接真实 LLM 和 CineFlow API 的 AI 单元/评测测试
.\.venv\Scripts\python.exe -m pytest tests\test_llm_client.py tests\test_llm_validation_pipeline.py tests\test_rag_quality.py tests\test_agent_quality.py -q

# 完整测试需要先启动 CineFlowAPI
.\.venv\Scripts\python.exe -m pytest
```

## LLM 结构化输出安全流水线

配置 `LLM_API_BASE`、`LLM_API_KEY` 和 `LLM_MODEL` 后可生成候选用例。模型输出不会直接执行，而是依次经过 YAML、严格结构、OpenAPI 契约和业务安全规则校验；通过后仍需人工复核。

```powershell
.\.venv\Scripts\python.exe -m llm.pipeline evals\datasets\structured_output\00_valid.yaml
```

原始输出、拒绝报告和候选内容分别写入 `generated/raw`、`generated/rejected` 与 `generated/candidates`，这些都是可再生运行产物，不提交版本库。

## 测试设计 Agent

`ai_testing.test_designer.TestDesignAgent` 将 OpenAPI 与本地业务规则作为不可信事实资料读取，一次生成结构化测试计划和 YAML 候选用例。测试计划必须覆盖正向、异常、边界和权限场景；候选集只允许安全的只读 GET 用例，并继续经过 YAML 语法、Pydantic 结构、OpenAPI 契约和业务安全规则四层校验。通过后状态仍为 `waiting_for_human_review`，不会直接执行 pytest。

```powershell
# 设计全部接口；会调用已配置的 DeepSeek
.\.venv\Scripts\python.exe -m ai_testing

# 只设计一个接口，可重复传入 --path
.\.venv\Scripts\python.exe -m ai_testing --path /api/movies
```

原始 Agent 输出、结构化计划和设计拒绝报告分别保存在 `generated/design/raw`、`generated/design/plans` 与 `generated/design/rejected`。候选用例仍沿用现有 `generated/candidates` 和 `generated/rejected` 目录，便于统一人工复核。

## 结果分析 Agent

`ai_testing.result_analyzer.ResultAnalysisAgent` 只读取已有的 JUnit XML 或 pytest 文本结果。确定性解析器先统计通过、失败、错误、跳过和耗时，裁剪失败堆栈并脱敏；Agent 再逐条区分环境问题、测试代码问题、产品缺陷和待确认问题，提取预期/实际结果并给出复测建议。失败用例 ID 必须和输入一一对应，否则整份分析会被拒绝。最终 Markdown 由 Python 渲染，状态保持为 `waiting_for_human_review`。

```powershell
# 推荐让 pytest 同时生成 JUnit XML，再交给结果分析 Agent
.\.venv\Scripts\python.exe -m pytest --junitxml=reports/junit.xml
.\.venv\Scripts\python.exe -m ai_testing.result_analyzer reports/junit.xml
```

如果报告全部通过，程序会直接生成确定性总结，不调用 DeepSeek。分析原文、结构化结论、拒绝记录和 Markdown 报告分别写入 `generated/analysis/raw`、`structured`、`rejected` 与 `reports`。

## 白名单执行器与完整工作流

pytest 执行不是 Agent。`ai_testing.safe_pytest_runner.SafePytestRunner` 不接受模型生成的命令或任意 pytest 参数，只允许选择 `smoke`、`movie`、`regression` 三个固定套件，使用参数数组和 `shell=False` 执行，并强制记录人工确认人、JUnit、控制台输出和执行元数据。

```powershell
# 第一步：生成设计，返回的 report_path 是四层校验报告
.\.venv\Scripts\python.exe -m workflows.functional_testing design --path /api/movies

# 第二步：人工检查计划和 YAML 后，选择固定套件执行并自动分析
.\.venv\Scripts\python.exe -m workflows.functional_testing run `
  generated\candidates\<run-id>.report.json `
  --suite movie `
  --approved-by "QA姓名"

# 也可以单独调用安全执行器
.\.venv\Scripts\python.exe -m ai_testing.safe_pytest_runner smoke --approved-by "QA姓名"
```

工作流拒绝未通过四层校验、不是 `waiting_for_human_review` 或缺少候选 YAML 的设计报告。pytest 的实际参数只能来自代码中的 `ALLOWED_SUITES`，测试设计 Agent 和结果分析 Agent 都不能改变执行命令。

## RAG 规则问答与评测

规则文档是唯一静态业务知识源，按 Markdown 标题生成 Chunk；检索结果同时接受领域和意图校正。回答必须引用本次检索得到的 `chunk_id`，无证据问题和提示注入问题应拒答。实时订单、场次、座位与票价不进入静态知识库。

```powershell
.\.venv\Scripts\python.exe -m rag.run_evaluation
```

评测报告生成到 `reports/rag/evaluation.json`，包含检索召回、Precision@K、拒答准确率、引用有效率与安全拒答指标。默认使用确定性摘录回答器，增加 `--use-llm` 才会调用真实模型。

## 只读 Agent 原型

`agent/factory.py` 将规则 RAG、CineFlow GET API 和有限步 Agent 组合起来。Agent 只允许以下工具：

- `search_movies`
- `get_movie_detail`
- `get_movie_schedules`
- `get_available_seats`
- `get_hot_recommendations`
- `get_refund_policy`

下单、锁座、支付、退款、评论修改、管理操作、任意 URL 和 SQL 均不在注册表中，即使模型主动生成调用也会在执行前被阻断。所有参数由 Pydantic 严格校验，每次运行最多 1–5 步且记录完整工具轨迹，不跨用户保留隐式记忆。

`agent.model.OpenAICompatibleAgentModel` 负责在 DeepSeek 标准 Tool Calling 消息与项目内部格式之间双向转换，`agent.factory.build_default_agent(BASE_URL)` 使用环境变量组装真实原型；测试中则使用 `ScriptedModel`，保证质量门禁稳定、快速且不产生模型费用。

## 接入 DeepSeek Flash

项目已经预设 DeepSeek 官方 OpenAI 兼容地址和 `deepseek-flash` 模型。复制配置后，只需在本地 `.env` 中填写密钥：

```env
LLM_API_BASE=https://api.deepseek.com
LLM_API_KEY=在这里填写你的DeepSeek密钥
LLM_MODEL=deepseek-flash
LLM_THINKING_MODE=disabled
```

当前 Agent 使用可复现的非思考模式，并在代码侧继续执行工具白名单和 Pydantic 参数校验。启动 CineFlowAPI 后，可以直接提问：

```powershell
# 普通回答
.\.venv\Scripts\python.exe -m agent "推荐三部科幻电影"

# 同时显示模型选择的工具、参数和执行结果
.\.venv\Scripts\python.exe -m agent "《星际穿越》有哪些场次？" --trace
```

先执行一个最小真实接口冒烟测试，确认密钥、余额、网络和模型名都可用：

```powershell
$env:RUN_LIVE_LLM="1"
.\.venv\Scripts\python.exe -m pytest tests\test_deepseek_live.py -m live_llm -q
Remove-Item Env:RUN_LIVE_LLM
```

真实测试会产生少量 API 费用，因此默认跳过，也不会进入常规 CI。普通离线 AI 回归测试不需要 DeepSeek 密钥。

## 测试分层和上线门禁

- 客户端可靠性：正常返回、空响应、非 JSON、超时退避、429 重试和 401 快速失败。
- 结构化输出：合法样本进入人工复核；语法、结构、未知路径、错误方法、未知查询参数和未授权写操作必须拒绝。
- RAG：有答案、无答案、安全问题、引用存在性和检索指标必须达到数据集阈值。
- Agent：工具选择、参数映射、可用座位过滤、写工具拒绝、恶意参数拒绝、轨迹和最大步数必须通过。
- API 基线：CineFlow 接口状态码、业务码、Schema、权限和关键链路用于验证工具所依赖的事实来源。

LLM 或 RAG 的自动评分适合做回归信号，不应成为唯一真相；高风险用例和模型生成的新用例必须保留人工复核。

## 配置和安全

测试账号与本地地址放在 `config/test_env.yaml`，密钥和数据库账号只放本地 `.env` 或 CI Secret。不要把本工程连接生产数据库，也不要给 Agent 配置生产写权限。`reports/`、`generated/`、缓存和虚拟环境均为本地可再生产物。
