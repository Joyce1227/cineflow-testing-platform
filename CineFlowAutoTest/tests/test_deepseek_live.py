"""真实 DeepSeek 冒烟测试；默认跳过，必须显式授权才会产生费用。"""

import os

import pytest

from agent.model import OpenAICompatibleAgentModel


@pytest.mark.live_llm
def test_deepseek_flash_live_smoke():
    if os.getenv("RUN_LIVE_LLM") != "1":
        pytest.skip("设置 RUN_LIVE_LLM=1 后才执行真实 DeepSeek 调用")

    result = OpenAICompatibleAgentModel.from_env().complete(
        [{"role": "user", "content": "只回复 pong，不要添加其他内容。"}],
        [],
    )

    assert result["content"].strip().lower() == "pong"
