"""CineFlow 的 AI 辅助测试设计与结果分析组件。"""

from typing import Any

__all__ = ["ResultAnalysisAgent", "TestDesignAgent", "TestDesignSourceReader"]


def __getattr__(name: str) -> Any:
    """按需导入，避免运行 ``python -m ai_testing.<module>`` 时重复加载模块。"""
    if name == "ResultAnalysisAgent":
        from ai_testing.result_analyzer import ResultAnalysisAgent

        return ResultAnalysisAgent
    if name in {"TestDesignAgent", "TestDesignSourceReader"}:
        from ai_testing.test_designer import TestDesignAgent, TestDesignSourceReader

        return {"TestDesignAgent": TestDesignAgent, "TestDesignSourceReader": TestDesignSourceReader}[name]
    raise AttributeError(name)
