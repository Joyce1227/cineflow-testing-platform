# CineFlow 规则知识库

`source` 保存购票、支付、退款、推荐和评论五类经过版本化的业务规则，它们是 RAG 的唯一静态事实来源。文档使用 YAML front matter 描述版本、更新时间和来源，正文用 Markdown 二级标题划分可检索片段。

执行以下命令会重建 `processed/chunks.jsonl` 与索引清单，并使用 `evals/datasets/rag/questions.jsonl` 计算检索、拒答、引用和安全指标：

```powershell
.\.venv\Scripts\python.exe -m rag.run_evaluation
```

`processed` 和 `reports` 均为可再生产物；更新规则时只修改 `source`，同时补充独立评测问题以防知识源与答案标注相互污染。
