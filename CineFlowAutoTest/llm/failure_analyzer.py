"""兼容入口；统一使用受校验的结果分析 Agent。"""

from ai_testing.result_analyzer import main


if __name__ == "__main__":
    raise SystemExit(main())

