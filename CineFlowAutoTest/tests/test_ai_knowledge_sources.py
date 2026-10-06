import json
from pathlib import Path

import yaml


AUTOTEST_ROOT = Path(__file__).resolve().parents[1]
PROJECT_ROOT = AUTOTEST_ROOT.parent
KNOWLEDGE_ROOT = AUTOTEST_ROOT / "ai_knowledge"
REQUIRED_FIELDS = {
    "document_id",
    "title",
    "version",
    "updated_at",
    "source",
    "owner",
    "status",
}


def read_front_matter(path: Path) -> dict:
    text = path.read_text(encoding="utf-8")
    assert text.startswith("---\n"), f"{path.name} 缺少 YAML front matter"
    metadata_text, body = text[4:].split("\n---\n", maxsplit=1)
    metadata = yaml.safe_load(metadata_text)
    assert isinstance(metadata, dict)
    assert body.strip(), f"{path.name} 没有正文"
    return metadata


def test_knowledge_manifest_matches_source_documents() -> None:
    manifest = json.loads(
        (KNOWLEDGE_ROOT / "manifest.json").read_text(encoding="utf-8")
    )
    documents = manifest["documents"]

    assert len(documents) == 5
    assert len({item["document_id"] for item in documents}) == len(documents)

    for item in documents:
        document_path = KNOWLEDGE_ROOT / item["file"]
        assert document_path.is_file()

        metadata = read_front_matter(document_path)
        assert REQUIRED_FIELDS <= metadata.keys()
        for field in (
            "document_id",
            "title",
            "version",
            "updated_at",
            "source",
            "status",
        ):
            assert metadata[field] == item[field]

        assert metadata["status"] == "active"
        assert (PROJECT_ROOT / metadata["source"]).is_file()
