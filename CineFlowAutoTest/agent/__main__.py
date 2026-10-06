"""命令行运行入口：``python -m agent "推荐三部科幻电影"``。"""

from __future__ import annotations

import argparse
import json
import sys

from agent.factory import build_default_agent
from common.config import Settings


def main() -> int:
    parser = argparse.ArgumentParser(description="运行接入 DeepSeek 的 CineFlow 只读 Agent")
    parser.add_argument("question", help="要询问 CineFlow 助手的问题")
    parser.add_argument("--trace", action="store_true", help="输出工具调用轨迹，便于调试和测试")
    args = parser.parse_args()

    try:
        # Settings.load 和模型工厂都会从项目根目录加载 .env。
        agent = build_default_agent(Settings.load().base_url)
        result = agent.run(args.question)
    except ValueError as exc:
        print(f"配置错误：{exc}", file=sys.stderr)
        return 2

    print(result.answer)
    if args.trace:
        print(json.dumps([step.model_dump() for step in result.steps], ensure_ascii=False, indent=2, default=str))
    return 0 if result.status == "completed" else 1


if __name__ == "__main__":
    raise SystemExit(main())
