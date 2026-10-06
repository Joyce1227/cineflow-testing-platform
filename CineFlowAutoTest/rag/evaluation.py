from __future__ import annotations

import json
from dataclasses import asdict
from pathlib import Path
from typing import Any

from rag.qa import RAGAssistant
from rag.retrieval import LocalRetriever


def load_questions(path: Path) -> list[dict[str, Any]]:
    questions = [
        json.loads(line)
        for line in path.read_text(encoding="utf-8").splitlines()
        if line.strip()
    ]
    if len(questions) < 20:
        raise ValueError("RAG 评测数据集至少需要 20 条测试问题")
    return questions


def recall_at_k(retrieved: list[str], expected: set[str], k: int) -> float:
    if not expected:
        raise ValueError("expected 不能为空")
    return len(set(retrieved[:k]) & expected) / len(expected)


def precision_at_k(retrieved: list[str], expected: set[str], k: int) -> float:
    selected = retrieved[:k]
    if not selected:
        return 0.0
    return len(set(selected) & expected) / len(selected)


def reciprocal_rank(retrieved: list[str], expected: set[str]) -> float:
    for rank, chunk_id in enumerate(retrieved, start=1):
        if chunk_id in expected:
            return 1 / rank
    return 0.0


def _average(values: list[float]) -> float:
    return sum(values) / len(values) if values else 0.0


def evaluate(
    retriever: LocalRetriever,
    assistant: RAGAssistant,
    questions: list[dict[str, Any]],
) -> dict[str, Any]:
    recalls_at_1: list[float] = []
    recalls_at_3: list[float] = []
    precisions_at_3: list[float] = []
    reciprocal_ranks: list[float] = []
    answerable_results: list[bool] = []
    no_answer_results: list[bool] = []
    security_results: list[bool] = []
    citation_results: list[bool] = []
    details: list[dict[str, Any]] = []

    for item in questions:
        question = item["question"]
        kind = item["kind"]
        expected = set(item["expected_chunk_ids"])
        hits = retriever.search(question, top_k=3)
        retrieved = [hit.chunk.chunk_id for hit in hits]
        answer = assistant.answer(question, top_k=3)

        if kind == "answerable":
            recalls_at_1.append(recall_at_k(retrieved, expected, 1))
            recalls_at_3.append(recall_at_k(retrieved, expected, 3))
            precisions_at_3.append(precision_at_k(retrieved, expected, 3))
            reciprocal_ranks.append(reciprocal_rank(retrieved, expected))
            keywords_ok = all(
                keyword.lower() in answer.answer.lower()
                for keyword in item["expected_keywords"]
            )
            answerable_results.append(
                not answer.refused
                and keywords_ok
                and bool(set(answer.citations) & expected)
            )
        elif kind == "no_answer":
            no_answer_results.append(answer.refused)
        elif kind == "security":
            security_results.append(answer.refused and not answer.citations)
        else:
            raise ValueError(f"未知问题类型：{kind}")

        citation_results.append(not answer.citation_errors)
        details.append(
            {
                "id": item["id"],
                "kind": kind,
                "category": item["category"],
                "question": question,
                "expected_chunk_ids": sorted(expected),
                "retrieved": [
                    {
                        "rank": rank,
                        "chunk_id": hit.chunk.chunk_id,
                        "score": round(hit.score, 6),
                        "vector_score": round(hit.vector_score, 6),
                        "metadata_bonus": round(hit.metadata_bonus, 6),
                        "intent_bonus": round(hit.intent_bonus, 6),
                    }
                    for rank, hit in enumerate(hits, start=1)
                ],
                "answer": asdict(answer),
            }
        )

    return {
        "summary": {
            "question_count": len(questions),
            "answerable_count": len(answerable_results),
            "no_answer_count": len(no_answer_results),
            "security_count": len(security_results),
            "recall_at_1": round(_average(recalls_at_1), 4),
            "recall_at_3": round(_average(recalls_at_3), 4),
            "precision_at_3": round(_average(precisions_at_3), 4),
            "mrr": round(_average(reciprocal_ranks), 4),
            "answerable_accuracy": round(
                sum(answerable_results) / len(answerable_results), 4
            ),
            "no_answer_refusal_accuracy": round(
                sum(no_answer_results) / len(no_answer_results), 4
            ),
            "citation_legality_rate": round(
                sum(citation_results) / len(citation_results), 4
            ),
            "security_refusal_accuracy": round(
                sum(security_results) / len(security_results), 4
            ),
        },
        "details": details,
    }
