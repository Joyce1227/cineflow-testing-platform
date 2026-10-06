# CineFlow 项目快速学习与大模型接入规划

> 适用项目：`CineFlowAPI` + `CineFlowAutoTest`  
> 目标人群：掌握 Python 基础，但对 FastAPI、接口自动化和大模型应用不熟悉  
> 推荐强度：14 天，每天 4～6 小时；如果每天能投入 8 小时，可压缩为 7～9 天

## 一、你最终需要达到什么程度

你的目标不是把所有框架都学完，而是能够独立完成并清楚解释下面这条链路：

```text
FastAPI 电影票务后端
    ↓ OpenAPI 接口文档 + 业务规则
大模型生成 YAML 测试用例草稿
    ↓ 格式校验 + 人工审核
pytest + requests 执行确定性测试
    ↓ 接口断言 + JSON Schema + MySQL 数据库断言
Allure 测试报告
    ↓ 只读取失败信息
大模型归类失败原因并给出排查建议
```

学习结束后，你应该能做到：

1. 在 PyCharm 中分别启动后端和自动化测试工程。
2. 使用 Swagger/Postman 手工完成登录、查电影、选座、下单、支付、评论、退款流程。
3. 解释 FastAPI 的 Controller、Service、Mapper、Entity 分层以及数据库事务。
4. 独立新增一个 pytest 接口用例和一个 YAML 数据驱动用例。
5. 解释 JWT、fixture、参数化、JSON Schema、数据库断言和幂等性。
6. 解释为什么同一座位并发购买只能有一个用户成功。
7. 调用一个大模型 API，根据接口文档生成 YAML 用例草稿。
8. 对模型输出进行 Pydantic/JSON Schema 校验，并在人工确认后执行 pytest。
9. 将 pytest 失败日志交给大模型分析，但不让模型决定测试是否通过。
10. 用 5～8 分钟完整演示项目，并回答常见面试问题。

## 二、先看懂自己的项目

### 2.1 项目组成

| 目录 | 作用 | 你要掌握的重点 |
|---|---|---|
| `CineFlowAPI` | FastAPI 电影票务与推荐后端 | 路由、参数校验、JWT、业务状态流转、SQLAlchemy、事务 |
| `CineFlowAutoTest` | 独立接口自动化测试工程 | requests、pytest、fixture、YAML、Schema、数据库断言、Allure |
| `CineFlowAutoTest/llm` | 大模型辅助模块 | API 调用、Prompt、结构化输出、校验、人工审核 |
| `电影项目自动化测试平台建设大纲.md` | 项目设计说明 | 测试范围、建设路线、简历表达 |

### 2.2 后端业务主线

最重要的不是背接口，而是理解状态变化：

```text
注册/登录
  ↓ 获取 JWT
查询电影 → 查询未来场次 → 查询可用座位
  ↓
创建订单 PENDING_PAYMENT
  ↓ 座位变为 LOCKED
支付成功 PAID
  ↓ 座位变为 SOLD
已购票用户评分评论
  ↓ 参与个性化推荐
退款 REFUNDED
  ↓ 座位恢复 AVAILABLE
```

优先阅读这些文件：

1. `CineFlowAPI/app/main.py`：应用入口、路由注册和启动初始化。
2. `CineFlowAPI/app/controllers/`：接口路径、HTTP 方法、请求参数。
3. `CineFlowAPI/app/schemas/requests.py`：Pydantic 参数校验规则。
4. `CineFlowAPI/app/services/ticket_service.py`：锁座、下单、支付、退款的核心业务。
5. `CineFlowAPI/app/entities/models.py`：表关系、唯一约束和索引。
6. `CineFlowAPI/app/core/security.py`：JWT 创建与鉴权。
7. `CineFlowAPI/app/core/errors.py`：统一响应和异常处理。

### 2.3 自动化测试主线

优先阅读顺序：

1. `CineFlowAutoTest/tests/conftest.py`：测试配置、客户端、登录态、数据库 fixture。
2. `CineFlowAutoTest/common/api_client.py`：HTTP 请求统一封装和 Allure 附件。
3. `CineFlowAutoTest/common/auth.py`：登录和 Token 复用。
4. `CineFlowAutoTest/tests/test_ticket_flow.py`：完整购票业务链路。
5. `CineFlowAutoTest/common/assertions.py`：业务码、JSON Path、JSON Schema 断言。
6. `CineFlowAutoTest/common/data.py`：读取 YAML、变量替换、响应字段提取。
7. `CineFlowAutoTest/tests/test_data_driven.py`：YAML 如何变成 pytest 用例。
8. `CineFlowAutoTest/performance/cineflow-api-performance.jmx`：JMeter 性能测试计划。

## 三、哪些内容必须学，哪些先不要学

### 必须熟练

- Python：函数、类、字典/列表、异常、上下文管理器、类型标注、模块导入。
- HTTP：方法、URL、Query、Header、JSON Body、状态码、Bearer Token。
- FastAPI：路由、Depends、Pydantic、异常处理、OpenAPI。
- pytest：测试发现、fixture、参数化、mark、断言和跳过。
- requests：Session、请求参数、响应 JSON、超时。
- MySQL/SQLAlchemy：增删改查、事务、唯一约束、索引、外键、行锁。
- 测试设计：正向、异常、边界、权限、状态流转、幂等、并发和数据一致性。
- 大模型 API：鉴权、消息输入、输出解析、Prompt 和结构化输出校验。

### 理解即可

- Docker Compose 的服务、网络、环境变量和依赖关系。
- GitHub Actions 流水线结构。
- JMeter 的线程组、Ramp-Up、吞吐量、错误率、P95 和 HTML Dashboard。
- 推荐系统中的冷启动、偏好类型、热门兜底和规则断言。

### 当前先不学

- 模型训练、微调、GPU/CUDA 和 Transformer 数学细节。
- 向量数据库、复杂 RAG、知识图谱。
- CrewAI、LangGraph 和多 Agent 编排。
- Kubernetes、微服务治理、复杂前端平台。
- 让模型自动修改数据库、自动支付或直接判定测试结果。

原因：这些内容不能明显提高你当前项目的完成度，却会大幅增加学习时间和故障点。

## 四、14 天最快实战路线

每天遵循同一个节奏：

```text
30% 学最少理论 → 50% 对照项目敲代码 → 20% 复述和记录问题
```

不要连续看几小时视频。每学习一个概念，必须立刻在 CineFlow 中找到对应代码并运行。

### 第 1 天：HTTP、Swagger 与完整业务体验

学习：

- GET、POST、PUT、DELETE 的区别。
- Path、Query、Header、JSON Body。
- 200、201、204、400、401、403、404、409、422、500。
- Bearer Token 的作用。

实操：

1. 启动 `CineFlowAPI`。
2. 打开 `http://127.0.0.1:8000/docs`。
3. 手工执行登录、电影列表、场次、座位、下单、支付、评论、退款。
4. 每一步记录请求、响应和数据库状态。

验收：不看代码，能够说明 401 与 403、400 与 422、200 与 201 的区别。

### 第 2 天：FastAPI 路由和 Pydantic

学习：

- `FastAPI()`、`APIRouter`、装饰器路由。
- `Depends` 依赖注入。
- Pydantic 字段类型、范围、正则和自定义校验。

实操：

1. 阅读所有 Controller。
2. 对照 `/openapi.json` 找到请求模型。
3. 给一个接口增加无害的边界校验，例如限制查询数量。
4. 分别发送合法和非法请求观察响应。

验收：能从一个 URL 追踪到 Controller 和 Request Schema。

### 第 3 天：SQLAlchemy 和数据库表关系

学习：

- ORM 模型、主键、外键、唯一约束、索引。
- Session、查询、提交、回滚。
- 一对多关系：订单与订单座位。

实操：

1. 画出 `app_user`、`movie_schedule`、`schedule_seat`、`ticket_order`、`order_seat` 的关系。
2. 在 DataGrip 中查询一次完整订单及其座位。
3. 手写 SQL 验证订单状态和座位状态。

验收：能解释为什么既需要 `ticket_order`，也需要 `order_seat`。

### 第 4 天：票务事务、幂等与并发

学习：

- 事务的原子性。
- 行锁和 `SELECT ... FOR UPDATE` 的目的。
- 幂等键、唯一约束、重复支付回调。
- 订单与座位状态机。

实操：

1. 逐行阅读 `ticket_service.py`。
2. 手工重复提交相同 `idempotencyKey`，确认只返回同一订单。
3. 手工重复支付相同 `providerTradeNo`。
4. 对照并发测试理解“一个 201、一个 409”。

验收：能回答“如何防止同一座位被两个人买走”。

### 第 5 天：pytest 和 requests

学习：

- pytest 测试发现和断言。
- fixture 的作用域和依赖关系。
- 参数化、mark、skip。
- `requests.Session` 与普通请求的区别。

实操：

1. 运行全部测试、smoke 测试和单个测试。
2. 在 `test_movie_api.py` 新增一个年份筛选用例。
3. 故意写错一次断言，阅读 pytest 失败信息后恢复。

验收：能够独立写一个带 fixture 的接口测试。

### 第 6 天：自动化框架封装

学习：

- 为什么要封装 API Client。
- 配置与代码分离。
- 日志、超时、Token 复用和敏感信息隐藏。

实操：

1. 跟踪一次 `client.get()` 到 `requests.Session.request()`。
2. 理解 `.env`、`test_env.yaml` 和环境变量的覆盖顺序。
3. 给请求客户端增加一个请求关联 ID，观察 Allure 附件。

验收：能解释公共客户端解决了哪些重复代码问题。

### 第 7 天：YAML 数据驱动与结构校验

学习：

- YAML 与 Python 字典/列表的对应关系。
- pytest 参数化如何批量生成用例。
- JSON Path 和 JSON Schema 的作用。

实操：

1. 在 `cases/movie_cases.yaml` 新增一个边界用例。
2. 阅读变量 `${test_username}` 的替换过程。
3. 故意删除响应必需字段的 Schema 定义或写错字段名，观察失败后恢复。

验收：只修改 YAML 就能增加并执行一个测试。

### 第 8 天：核心链路与数据库断言

学习：

- 接口断言与数据库断言的区别。
- 前置数据、测试执行、清理数据。
- 测试之间不能依赖执行顺序。

实操：

1. 逐行讲解 `test_ticket_flow.py`。
2. 执行该文件并在 DataGrip 中观察状态变化。
3. 新增“取消待支付订单后座位释放”测试。

验收：能从请求、业务状态和数据库三个角度说明用例为什么通过。

### 第 9 天：Allure、Docker 和 CI

学习：

- Allure Results 与 HTML Report 的区别。
- Dockerfile 的镜像、工作目录、依赖和启动命令。
- Compose 中 API、MySQL、Tests 的网络关系。
- CI 的触发、执行、失败和产物上传。

实操：

1. 生成并打开一次 Allure 报告。
2. 阅读 `docker-compose.yml` 和 GitHub Actions 文件。
3. 安装 Docker 后运行一次完整 Compose 测试。

验收：能解释为什么自动化测试应该使用独立测试数据库。

### 第 10 天：JMeter 性能测试

学习：

- 并发用户数、增长率、RPS/QPS、平均响应时间、P95、错误率。
- 功能并发正确性测试与性能压测的区别。

实操：

1. 对电影列表和热门推荐做 10、50、100 用户阶梯压测。
2. 保存响应时间、P95、RPS 和错误率。
3. 使用非 GUI 模式执行并生成 HTML Dashboard。
4. 不要直接对生产数据压测，也不要无限创建订单。

验收：能够根据指标写一段有证据的性能结论。

### 第 11 天：大模型零基础必修概念

只学习以下概念：

- 模型 API：程序通过 HTTP 请求向模型发送输入并得到文本或结构化结果。
- API Key：调用凭据，只放环境变量，不能写进代码或提交 Git。
- System Prompt：定义角色、规则和输出约束。
- User Prompt：本次任务的接口文档、业务规则和错误日志。
- Token：模型处理文本的计量单位；输入越长，延迟和费用通常越高。
- Temperature：随机性；测试用例生成建议使用较低值，例如当前代码的 `0.1`。
- 上下文窗口：单次请求能读取的内容有上限，不能无选择地塞入整个仓库。
- 幻觉：模型可能生成不存在的字段、路径或业务规则。
- 结构化输出：要求模型返回固定 JSON/YAML，并由程序再次校验。

不需要学习模型训练原理。你是在做“大模型应用接入”，不是训练基础模型。

验收：能画出“输入—模型 API—输出—校验—人工确认—执行”的流程。

### 第 12 天：接入大模型生成用例

当前项目已经有最小调用封装：

- `CineFlowAutoTest/llm/client.py`：调用 OpenAI 兼容的 `/chat/completions` 接口。
- `CineFlowAutoTest/llm/case_generator.py`：发送接口说明、解析 YAML、检查基本结构并保存。

先准备本地 `.env`，不要修改 `.env.example` 存放真实密钥：

```env
LLM_API_BASE=你的模型服务基础地址
LLM_API_KEY=你的API密钥
LLM_MODEL=服务商提供的模型名称
```

当前调用过程：

```python
POST {LLM_API_BASE}/chat/completions
Authorization: Bearer {LLM_API_KEY}

{
  "model": "模型名称",
  "temperature": 0.1,
  "messages": [
    {"role": "system", "content": "角色、限制和输出格式"},
    {"role": "user", "content": "接口信息和业务规则"}
  ]
}
```

实操：

1. 从 `http://127.0.0.1:8000/openapi.json` 选一个接口，不要第一次就输入全部接口。
2. 补充该接口的人工业务规则，例如评分只能由已购票用户提交。
3. 调用生成器输出到 `cases/generated_cases.yaml`。
4. 逐项检查 URL、字段名、类型、状态码和业务码。
5. 只把确认过的用例复制到正式 YAML。
6. 运行 pytest 验证。

命令示例：

```powershell
cd D:\MovieTicketingAndRecommendationSystem\CineFlowAutoTest
.\.venv\Scripts\python.exe -m llm.case_generator 接口说明.txt cases\generated_cases.yaml
```

验收：模型生成至少 8 条用例，人工删除或修正其中错误项，并成功执行至少 3 条。

### 第 13 天：大模型失败分析

输入应该包含：

- 失败用例名称。
- 请求方法、URL、参数。
- 预期状态码和断言。
- 实际响应。
- pytest Traceback。
- 相关后端日志。
- 必要的数据库查询结果。

执行：

```powershell
.\.venv\Scripts\python.exe -m pytest 2>&1 | Tee-Object reports\pytest.log
.\.venv\Scripts\python.exe -m llm.failure_analyzer reports\pytest.log
```

模型只应输出：失败分类、日志证据、可能原因、排查步骤和回归建议。

禁止模型直接做以下决定：

- 判定订单、支付、库存断言是否通过。
- 自动修改数据库修复失败。
- 自动把失败标记为测试环境问题。
- 未经确认修改后端代码或正式用例。

验收：故意制造一次字段断言失败，检查模型能否区分“测试代码错误”和“后端缺陷”；最后由你依据日志下结论。

### 第 14 天：整理演示和面试表达

准备一个 5～8 分钟演示：

1. 介绍业务和总体架构，约 40 秒。
2. Swagger 展示主要接口，约 40 秒。
3. 展示 YAML、公共客户端和断言封装，约 1 分钟。
4. 运行完整购票链路，展示接口与数据库状态，约 2 分钟。
5. 展示 Allure 报告和 JMeter HTML Dashboard，约 1 分钟。
6. 输入单个接口说明，让大模型生成 YAML 草稿，人工检查后执行，约 1～2 分钟。
7. 说明模型只辅助生成和诊断，核心断言仍由 pytest/数据库确定，约 30 秒。

验收：脱离稿件完整讲两遍，并录屏检查是否能解释“为什么这样设计”。

## 五、大模型接入的正确设计

### 5.1 第一阶段：单模型、两项能力

当前只实现：

1. 用例草稿生成。
2. 失败日志分析。

这一阶段不需要 LangChain、CrewAI 或 LangGraph。普通 HTTP 请求已经足够展示完整链路，而且更容易解释和排错。

### 5.2 输入不能只有 OpenAPI

OpenAPI 能告诉模型：

- 接口路径和方法。
- 参数名、类型和是否必填。
- 请求/响应结构。

但它通常不能完整告诉模型：

- 只有已购票用户才能评分。
- 同一幂等键只能产生一个订单。
- 支付后座位必须变为 SOLD。
- 退款后座位必须恢复 AVAILABLE。
- 推荐结果不能包含下架电影。

因此最有效的输入是：

```text
单个接口的 OpenAPI 片段
+
人工编写的业务规则
+
项目统一的 YAML 用例模板
+
允许使用的断言操作符
```

建议新增一份 `CineFlowAutoTest/llm/business_rules.md`，按模块写清状态和约束。它比盲目学习 RAG 更重要。

### 5.3 生成结果必须经过四道门

```text
模型输出
  ↓ 1. YAML 能否解析
字段模型校验
  ↓ 2. name/request/expect 是否齐全
接口契约校验
  ↓ 3. path、method、参数名是否存在于 OpenAPI
人工业务审核
  ↓ 4. 预期状态和业务规则是否正确
进入正式测试集
```

当前 `case_generator.py` 已完成前两步的一部分。下一步最值得增加的是：

- 使用 Pydantic 定义 `GeneratedCase`、`RequestSpec`、`ExpectedSpec`。
- 限制 HTTP method 枚举。
- 校验 `status` 和 `code` 必须是整数。
- 从 `/openapi.json` 验证 path、method 和参数名。
- 输出到 `cases/drafts/`，人工批准后才能进入正式目录。

### 5.4 推荐的模块演进

```text
llm/
├─ client.py                 模型 API 客户端
├─ case_generator.py         用例草稿生成
├─ failure_analyzer.py       失败归类与建议
├─ models.py                 Pydantic 结构化输出模型
├─ openapi_reader.py         提取指定接口契约
├─ contract_validator.py     校验模型生成字段是否真实存在
├─ business_rules.md         人工维护的核心业务规则
└─ prompts/
   ├─ case_generation.txt
   └─ failure_analysis.txt
```

暂时不要把执行 pytest 的权限交给模型。由普通 Python 调度代码执行更稳定，也更容易审计。

### 5.5 什么时候再学 RAG 和 Agent

满足下面条件后再继续：

- 你能独立调用模型 API 并处理超时、401、429、500 和非法输出。
- 模型输出已经有 Pydantic 与 OpenAPI 双重校验。
- 两个最小功能能够稳定演示。
- 你能解释 Prompt 中每项规则的意义。

之后可以按顺序增加：

1. 报告摘要生成。
2. 从多份业务文档检索相关规则，即最小 RAG。
3. Tool Calling：允许模型选择“读取接口契约”或“读取失败日志”等只读工具。
4. 单 Agent 工作流。
5. 最后才考虑多个 Agent 分工。

## 六、大模型部分最小知识清单

### 6.1 你必须能解释的 10 个问题

1. 大模型 API 和普通 HTTP API 有什么相同与不同？
2. System Prompt 和 User Prompt 分别放什么？
3. 为什么测试用例生成使用较低 temperature？
4. 为什么模型会生成不存在的接口字段？
5. 如何用 Pydantic 或 JSON Schema 限制输出？
6. 为什么格式正确不代表业务预期正确？
7. 为什么核心断言不能交给模型？
8. 如何处理超时、限流、服务异常和无效输出？
9. 如何避免 API Key 泄露？
10. 为什么这个项目当前不需要多 Agent？

### 6.2 模型调用常见异常

| 现象 | 常见原因 | 处理方式 |
|---|---|---|
| 401/403 | Key 错误、无权限 | 检查环境变量和模型权限，禁止打印完整 Key |
| 404 | 基础地址、路径或模型名错误 | 对照服务商文档检查 API Base 和模型标识 |
| 429 | 请求过快或额度不足 | 指数退避、限制并发、检查额度 |
| 500/502/503 | 服务端异常 | 有上限地重试并保存错误上下文 |
| 超时 | 输入过长或网络问题 | 缩短 OpenAPI 片段、设置合理超时 |
| YAML 无法解析 | 模型加入说明文字或格式错误 | 去代码围栏、解析校验、失败后要求修复格式 |
| 字段不存在 | 模型幻觉 | 使用 OpenAPI 契约校验并人工复核 |

### 6.3 安全底线

- API Key 只放 `.env` 或 CI Secret。
- `.env` 必须在 `.gitignore` 中。
- Prompt 中不要包含真实用户隐私、生产 Token、数据库密码。
- 发送失败日志前过滤 Authorization、Cookie、手机号和邮箱等敏感内容。
- 设置请求超时、最大输入长度和最大重试次数。
- 模型输出只能作为草稿或建议，不能绕过确定性校验。

## 七、最快学习方法

### 7.1 每个知识点只做四件事

1. 用 20～30 分钟理解概念。
2. 在项目中找到对应文件。
3. 修改一个小功能并运行验证。
4. 用自己的话写三句话解释。

### 7.2 建立问题笔记

每天只记录三类内容：

- 今天遇到的错误和最终原因。
- 今天掌握的项目调用链。
- 如果面试官追问，我如何回答。

不要大段抄教程。错误排查记录比复制概念更有价值。

### 7.3 使用费曼检验

每天结束时尝试不用术语解释：

- 这个功能解决什么问题？
- 请求从哪里进入，经过哪些代码，最后修改哪张表？
- 自动化测试如何证明它正确？
- 如果失败，先看响应、日志还是数据库？为什么？

说不清的地方就是第二天最先补的地方。

## 八、项目必须亲手完成的练习

代码已经能运行，但为了真正变成你的项目，至少亲手完成以下改动：

- 新增年份筛选的功能测试。
- 新增手机号、邮箱重复注册用例。
- 新增待支付订单取消并释放座位用例。
- 新增支付失败后座位释放用例。
- 新增未购票用户禁止评论用例。
- 为统计接口增加排序和非负数断言。
- 在 MySQL 中执行同座并发用例。
- 完成一次 JMeter 阶梯压测并记录 P95。
- 给 LLM 用例模型增加 Pydantic 校验。
- 增加 OpenAPI path/method 校验。
- 保存一份模型生成前、人工修改后、实际执行后的对比示例。
- 保存一次失败日志与大模型分析结果，并由你写最终人工结论。

## 九、面试时如何介绍

### 9.1 一分钟项目介绍

> 我围绕电影票务与推荐业务搭建了一套独立的接口自动化测试工程。后端使用 FastAPI 和 SQLAlchemy，实现用户鉴权、电影查询、场次座位、幂等下单、支付退款、评论推荐和统计分析。测试侧使用 pytest、requests 和 YAML 数据驱动，结合 JSON Schema 与 MySQL 数据库断言验证接口和数据状态；对同座抢购设计了 MySQL 并发测试，并通过 Allure、JMeter、Docker Compose 和 CI 完成报告、压测和自动回归。大模型只用于从 OpenAPI 与业务规则生成用例草稿，以及分析失败日志，模型输出经过结构校验和人工审核，核心业务是否通过仍由确定性断言决定。

### 9.2 高频追问

你必须准备这些问题：

- 为什么测试工程和后端分开？
- YAML 数据驱动相比直接写 pytest 有什么优缺点？
- Token 如何获取和复用？
- 如何保证用例独立和可重复执行？
- 重复下单与重复支付如何测试？
- 数据库断言为什么不能只查订单表？
- SQLite 与 MySQL 的并发行为为什么不同？
- 推荐结果为什么不能断言固定电影 ID？
- 为什么大模型只生成草稿，不直接执行？
- 如何判断大模型给出的失败原因是否可信？

## 十、最终成果清单

完成后应保存以下材料：

- [ ] 项目架构图。
- [ ] 数据库 ER 图和订单状态图。
- [ ] Swagger 完整购票链路截图。
- [ ] pytest 全部通过截图。
- [ ] Allure 总览、单个失败详情截图。
- [ ] 数据库断言代码和查询结果截图。
- [ ] MySQL 同座并发测试结果。
- [ ] JMeter HTML Dashboard、关键指标和性能结论。
- [ ] Docker Compose 一键执行结果。
- [ ] CI 成功流水线截图。
- [ ] 模型生成 YAML 的输入、原始输出和人工修改记录。
- [ ] 大模型失败分析结果以及人工最终结论。
- [ ] 5～8 分钟项目演示录屏。
- [ ] 能脱稿回答本规划中的高频问题。

## 十一、7 天压缩版本

如果时间非常紧且每天能投入约 8 小时：

| 天数 | 上午 | 下午 | 晚上验收 |
|---|---|---|---|
| 第 1 天 | HTTP、Swagger | 跑完整业务链路 | 能手工调通全部核心接口 |
| 第 2 天 | FastAPI、Pydantic | SQLAlchemy、表关系 | 能追踪请求到数据库 |
| 第 3 天 | pytest、fixture | requests、YAML、Schema | 独立新增两条用例 |
| 第 4 天 | 订单状态与幂等 | 数据库断言、并发 | 能讲清防超卖方案 |
| 第 5 天 | Allure、Docker、CI | JMeter | 形成测试与压测结果 |
| 第 6 天 | 大模型 API、Prompt | 用例生成、输出校验 | 生成并人工修正 YAML |
| 第 7 天 | 失败分析 | 整理演示和面试问题 | 完成两次脱稿演示 |

压缩学习时依然不要跳过订单状态、数据库断言和模型输出校验；这三项是项目最有价值、也最容易被追问的部分。

## 十二、建议的下一步开发顺序

按照收益和难度排序：

1. 补齐尚缺的业务边界用例。
2. 用 MySQL 跑通并发锁座测试。
3. 安装 Allure CLI，保存可展示报告。
4. 完成一次 JMeter 阶梯压测。
5. 为 LLM 输出增加 Pydantic 强校验。
6. 自动读取 FastAPI `/openapi.json` 并校验模型生成字段。
7. 增加敏感信息脱敏、有限重试和调用日志。
8. 增加报告摘要生成。
9. 最后再评估是否值得增加 RAG 或 Agent。

只要前 7 项能够独立完成并讲清楚，这个项目已经足以展示后端理解、测试框架、数据库一致性、并发、性能、工程化以及大模型应用接入能力。
