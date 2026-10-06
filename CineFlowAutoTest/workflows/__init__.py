"""CineFlow 受控测试工作流。"""

from typing import Any

__all__ = ["FunctionalTestingWorkflow"]


def __getattr__(name: str) -> Any:
    if name == "FunctionalTestingWorkflow":
        from workflows.functional_testing import FunctionalTestingWorkflow

        return FunctionalTestingWorkflow
    raise AttributeError(name)
