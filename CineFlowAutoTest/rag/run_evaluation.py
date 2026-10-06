from __future__ import annotations

import argparse
import json
import sys
from datetime import datetime, timezone
from pathlib import Path

from rag.chunking import build_chunks, write_chunks
from rag.evaluation import evaluate, load_questions
from rag.qa import RAGAssistant
from rag.retrieval import (
    CHUNK_STRATEGY,
    EMBEDDING_DIMENSION,
    EMBEDDING_MODEL,
    LocalRetriever,
)


AUTOTEST_ROOT = Path(__file__).resolve().parents[1]
KNOWLEDGE_ROOT = AUTOTEST_ROOT / "ai_knowledge"
SOURCE_DIR = KNOWLEDGE_ROOT / "source"
PROCESSED_DIR = KNOWLEDGE_ROOT / "processed"
# 评测数据与知识源分离：知识库负责提供事实，evals 负责提出问题和判定质量。
QUESTIONS_PATH = AUTOTEST_ROOT / "evals" / "datasets" / "rag" / "questions.jsonl"
REPORT_PATH = AUTOTEST_ROOT / "reports" / "rag" / "evaluation.json"


def write_index_manifest(chunk_count: int) -> Path:
    manifest_path = PROCESSED_DIR / "index_manifest.json"
    manifest = {
        "embedding_model": EMBEDDING_MODEL,
        "embedding_dimension": EMBEDDING_DIMENSION,
        "chunk_strategy": CHUNK_STRATEGY,
        "knowledge_version": "2026-09-28",
        "chunk_count": chunk_count,
        "created_at": datetime.now(timezone.utc).isoformat(),
    }
    manifest_path.write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2), encoding="utf-8"
    )
    return manifest_path


def main() -> None:
    parser = argparse.ArgumentParser(description="运行 CineFlow 规则问答 RAG 质量评测")
    parser.add_argument(
        "--use-llm",
        action="store_true",
        help="使用环境变量配置的真实 LLM；默认使用确定性摘录回答器",
    )
    parser.add_argument("--report", type=Path, default=REPORT_PATH)
    args = parser.parse_args()

    chunks = build_chunks(SOURCE_DIR)
    chunks_path = PROCESSED_DIR / "chunks.jsonl"
    write_chunks(chunks, chunks_path)
    manifest_path = write_index_manifest(len(chunks))

    retriever = LocalRetriever(chunks)
    assistant = RAGAssistant(retriever, use_llm=args.use_llm)
    questions = load_questions(QUESTIONS_PATH)
    report = evaluate(retriever, assistant, questions)

    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(
        json.dumps(report, ensure_ascii=False, indent=2), encoding="utf-8"
    )

    print(f"规则文档：5")
    print(f"Chunk 数量：{len(chunks)}")
    print(f"测试问题：{len(questions)}")
    print(f"Chunks：{chunks_path}")
    print(f"索引信息：{manifest_path}")
    print(f"评测报告：{args.report}")
    print(json.dumps(report["summary"], ensure_ascii=False, indent=2))


if __name__ == "__main__":
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8")
    main()
