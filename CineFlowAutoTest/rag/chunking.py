from __future__ import annotations

import json
from pathlib import Path

import yaml

from rag.models import KnowledgeChunk


DOMAIN_BY_DOCUMENT = {
    "booking_rules_v1": "booking",
    "payment_rules_v1": "payment",
    "refund_rules_v1": "refund",
    "recommendation_rules_v1": "recommendation",
    "review_rules_v1": "review",
}


def parse_front_matter(path: Path) -> tuple[dict, str]:
    content = path.read_text(encoding="utf-8")
    if not content.startswith("---\n"):
        raise ValueError(f"知识文档缺少 YAML front matter：{path}")
    try:
        metadata_text, body = content[4:].split("\n---\n", maxsplit=1)
    except ValueError as exc:
        raise ValueError(f"知识文档 front matter 没有闭合：{path}") from exc
    metadata = yaml.safe_load(metadata_text)
    if not isinstance(metadata, dict):
        raise ValueError(f"知识文档元数据必须是对象：{path}")
    return metadata, body


def chunk_markdown(path: Path) -> list[KnowledgeChunk]:
    metadata, body = parse_front_matter(path)
    document_id = str(metadata["document_id"])
    domain = DOMAIN_BY_DOCUMENT.get(document_id)
    if domain is None:
        raise ValueError(f"未配置知识领域：{document_id}")

    sections: list[tuple[str, list[str]]] = []
    current_title: str | None = None
    current_lines: list[str] = []

    for line in body.splitlines():
        if line.startswith("## "):
            if current_title is not None:
                sections.append((current_title, current_lines))
            current_title = line[3:].strip()
            current_lines = []
        elif current_title is not None:
            current_lines.append(line)

    if current_title is not None:
        sections.append((current_title, current_lines))

    chunks: list[KnowledgeChunk] = []
    for index, (section, lines) in enumerate(sections, start=1):
        text = "\n".join(line for line in lines).strip()
        if not text:
            continue
        chunks.append(
            KnowledgeChunk(
                chunk_id=f"{document_id}#section-{index:02d}",
                document_id=document_id,
                title=str(metadata["title"]),
                section=section,
                text=f"{section}\n{text}",
                metadata={
                    "domain": domain,
                    "visibility": "public",
                    "version": str(metadata["version"]),
                    "updated_at": str(metadata["updated_at"]),
                    "source": str(metadata["source"]),
                },
            )
        )
    return chunks


def build_chunks(source_dir: Path) -> list[KnowledgeChunk]:
    chunks: list[KnowledgeChunk] = []
    for path in sorted(source_dir.glob("*_rules.md")):
        chunks.extend(chunk_markdown(path))
    if not chunks:
        raise ValueError(f"没有找到知识源文档：{source_dir}")
    return chunks


def write_chunks(chunks: list[KnowledgeChunk], output_path: Path) -> None:
    output_path.parent.mkdir(parents=True, exist_ok=True)
    lines = [
        json.dumps(
            {
                "chunk_id": chunk.chunk_id,
                "document_id": chunk.document_id,
                "title": chunk.title,
                "section": chunk.section,
                "text": chunk.text,
                "metadata": chunk.metadata,
            },
            ensure_ascii=False,
        )
        for chunk in chunks
    ]
    output_path.write_text("\n".join(lines) + "\n", encoding="utf-8")
