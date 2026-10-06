from __future__ import annotations

import hashlib
import math
import re
from collections import Counter

from rag.models import IndexedChunk, KnowledgeChunk, SearchHit


EMBEDDING_MODEL = "local-char-ngram-v1"
EMBEDDING_DIMENSION = 512
CHUNK_STRATEGY = "markdown-h2-v1"

SYNONYMS = {
    "退票": "退款",
    "席位": "座位",
    "影评": "评论",
    "打分": "评分",
    "买票": "购票",
    "付款": "支付",
}

DOMAIN_RULES = (
    ("refund", ("退款", "退票", "退还", "refunded")),
    ("recommendation", ("推荐", "热门", "偏好")),
    ("review", ("评论", "评分", "影评", "删除评论")),
    ("booking", ("购票", "锁座", "场次", "取消", "过期")),
    ("payment", ("支付", "付款", "交易号", "回调", "幂等")),
    ("booking", ("座位", "订单")),
)

INTENT_SIGNALS = (
    (("过期",), ("过期", "EXPIRED"), 0.18),
    (("幂等", "providertradeno"), ("幂等", "不重复修改"), 0.18),
    (("重复退款", "再次退款"), ("重复退款", "再次请求退款"), 0.20),
    (("有资格", "什么用户"), ("只有拥有", "已购票用户", "PAID 订单"), 0.18),
    (("排列", "排序", "顺序"), ("排列", "排序", "降序"), 0.12),
)


def normalize(text: str) -> str:
    value = text.lower()
    for source, target in SYNONYMS.items():
        value = value.replace(source, target)
    return re.sub(r"\s+", "", value)


def tokens(text: str) -> list[str]:
    normalized = normalize(text)
    chinese = "".join(re.findall(r"[\u4e00-\u9fff]", normalized))
    ngrams = [chinese[index : index + 2] for index in range(len(chinese) - 1)]
    words = re.findall(r"[a-z_][a-z0-9_\-]*|\d+(?:\.\d+)?", normalized)
    return ngrams + words


def embed(text: str, dimension: int = EMBEDDING_DIMENSION) -> list[float]:
    vector = [0.0] * dimension
    for token, count in Counter(tokens(text)).items():
        digest = hashlib.sha256(token.encode("utf-8")).digest()
        position = int.from_bytes(digest[:4], "big") % dimension
        vector[position] += float(count)
    return vector


def cosine_similarity(left: list[float], right: list[float]) -> float:
    if len(left) != len(right):
        raise ValueError("向量维度不同")
    dot = sum(a * b for a, b in zip(left, right))
    left_length = math.sqrt(sum(value * value for value in left))
    right_length = math.sqrt(sum(value * value for value in right))
    if left_length == 0 or right_length == 0:
        return 0.0
    return dot / (left_length * right_length)


def detect_domain(query: str) -> str | None:
    normalized = normalize(query)
    for domain, terms in DOMAIN_RULES:
        if any(term.lower() in normalized for term in terms):
            return domain
    return None


def intent_bonus(query: str, section: str, text: str) -> float:
    query_lower = query.lower()
    section_lower = section.lower()
    text_lower = text.lower()
    score = 0.0
    for query_terms, text_terms, bonus in INTENT_SIGNALS:
        if not any(term.lower() in query_lower for term in query_terms):
            continue
        if any(term.lower() in section_lower for term in text_terms):
            score += bonus
        elif any(term.lower() in text_lower for term in text_terms):
            score += bonus * 0.5
    return score


class LocalRetriever:
    def __init__(self, chunks: list[KnowledgeChunk]) -> None:
        self.index = [IndexedChunk(chunk, embed(chunk.text)) for chunk in chunks]

    def search(
        self,
        query: str,
        top_k: int = 3,
        metadata_filter: dict[str, str] | None = None,
    ) -> list[SearchHit]:
        if top_k < 1:
            raise ValueError("top_k 必须大于等于 1")
        query_vector = embed(query)
        query_domain = detect_domain(query)
        hits: list[SearchHit] = []

        for indexed in self.index:
            chunk = indexed.chunk
            if metadata_filter and not all(
                chunk.metadata.get(key) == value
                for key, value in metadata_filter.items()
            ):
                continue
            vector_score = cosine_similarity(query_vector, indexed.vector)
            metadata_bonus = 0.15 if query_domain == chunk.metadata["domain"] else 0.0
            section_intent_bonus = intent_bonus(query, chunk.section, chunk.text)
            hits.append(
                SearchHit(
                    chunk=chunk,
                    score=vector_score + metadata_bonus + section_intent_bonus,
                    vector_score=vector_score,
                    metadata_bonus=metadata_bonus,
                    intent_bonus=section_intent_bonus,
                )
            )

        hits.sort(key=lambda hit: (-hit.score, hit.chunk.chunk_id))
        return hits[:top_k]
