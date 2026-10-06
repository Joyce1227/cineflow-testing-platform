from pathlib import Path

from evals.gates import gate_failures, load_thresholds
from rag.chunking import build_chunks
from rag.evaluation import evaluate, load_questions
from rag.qa import RAGAssistant, validate_citations
from rag.retrieval import EMBEDDING_DIMENSION, LocalRetriever, embed


AUTOTEST_ROOT = Path(__file__).resolve().parents[1]
KNOWLEDGE_ROOT = AUTOTEST_ROOT / "ai_knowledge"


def test_heading_chunking_and_embedding_are_stable() -> None:
    chunks = build_chunks(KNOWLEDGE_ROOT / "source")

    assert len(chunks) == 27
    assert len({chunk.chunk_id for chunk in chunks}) == len(chunks)
    assert all(chunk.metadata["visibility"] == "public" for chunk in chunks)
    assert len(embed("退款成功后座位状态是什么？")) == EMBEDDING_DIMENSION


def test_rag_question_mix_and_offline_metrics() -> None:
    questions = load_questions(
        AUTOTEST_ROOT / "evals" / "datasets" / "rag" / "questions.jsonl"
    )
    kinds = [item["kind"] for item in questions]
    assert kinds.count("answerable") == 15
    assert kinds.count("no_answer") == 3
    assert kinds.count("security") == 2

    chunks = build_chunks(KNOWLEDGE_ROOT / "source")
    retriever = LocalRetriever(chunks)
    report = evaluate(retriever, RAGAssistant(retriever), questions)
    summary = report["summary"]

    thresholds = load_thresholds(AUTOTEST_ROOT / "config" / "ai_quality_gates.yaml", "rag")
    assert gate_failures(summary, thresholds) == []


def test_citation_must_come_from_current_retrieval() -> None:
    errors = validate_citations(
        citations=["refund_rules_v1#section-99"],
        retrieved_chunk_ids={"refund_rules_v1#section-03"},
        require_citation=True,
    )
    assert errors == [
        "引用未出现在本次检索结果中：refund_rules_v1#section-99"
    ]
