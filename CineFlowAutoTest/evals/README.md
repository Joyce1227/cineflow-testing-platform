# AI 评测资产

`datasets/structured_output` 验证模型生成 YAML 的语法、结构、OpenAPI 契约和业务安全边界；`datasets/rag` 验证检索命中、拒答、引用真实性与安全问题。Agent 的工具选择、参数、权限、轨迹和最大步数由 `tests/test_agent_quality.py` 离线验证。

评测数据只定义输入与期望结果，不作为模型的业务知识来源；正式业务规则统一维护在 `ai_knowledge/source`。
