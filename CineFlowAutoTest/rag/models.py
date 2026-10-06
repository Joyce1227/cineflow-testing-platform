from __future__ import annotations

from dataclasses import dataclass, field


@dataclass(frozen=True)
class KnowledgeChunk:
    chunk_id: str
    document_id: str
    title: str
    section: str
    text: str
    metadata: dict[str, str]


@dataclass(frozen=True)
class IndexedChunk:
    chunk: KnowledgeChunk
    vector: list[float]


@dataclass(frozen=True)
class SearchHit:
    chunk: KnowledgeChunk
    score: float
    vector_score: float
    metadata_bonus: float
    intent_bonus: float


@dataclass(frozen=True)
class RAGAnswer:
    answer: str
    citations: list[str]
    refused: bool
    retrieved_chunk_ids: list[str] = field(default_factory=list)
    citation_errors: list[str] = field(default_factory=list)
