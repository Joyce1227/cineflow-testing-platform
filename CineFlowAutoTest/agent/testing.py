"""供离线 Agent 测试使用的脚本化模型。"""

from copy import deepcopy
from typing import Any


class ScriptedModel:
    def __init__(self, responses: list[dict[str, Any]]) -> None:
        self.responses = deepcopy(responses)
        self.calls = []

    def complete(self, messages, tools):
        self.calls.append((deepcopy(messages), deepcopy(tools)))
        if not self.responses:
            raise AssertionError("脚本化模型没有更多响应")
        return self.responses.pop(0)
