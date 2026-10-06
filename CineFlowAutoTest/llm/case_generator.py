from __future__ import annotations

import argparse
import json
from pathlib import Path

from llm.client import complete
from llm.pipeline import ValidationPipeline


def main() -> None:
    parser = argparse.ArgumentParser(description="根据接口说明生成待人工复核的 YAML DDT 用例")
    parser.add_argument("spec", type=Path, help="接口说明文本文件")
    parser.add_argument("--output-root", type=Path, default=None, help="生成物目录")
    args = parser.parse_args()
    result = complete(
        "你是接口测试专家。只输出YAML，根节点必须是cases。每条用例包含name、request、expect；"
        "request包含method/path及可选params/json，expect至少包含status和code。覆盖正向、边界和异常。",
        args.spec.read_text(encoding="utf-8"),
    )
    validation = ValidationPipeline(output_root=args.output_root).validate(result)
    print(json.dumps(validation, ensure_ascii=False, indent=2))
    if not validation["valid"]:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
