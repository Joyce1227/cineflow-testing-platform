"""LLM 连接配置，统一供普通生成、RAG 和 Agent 使用。"""

from __future__ import annotations

import os
from dataclasses import dataclass
from pathlib import Path

from dotenv import load_dotenv


PROJECT_ROOT = Path(__file__).resolve().parents[1]


@dataclass(frozen=True)
class LLMSettings:
    """从本地 .env 读取 DeepSeek 配置，密钥不会写入代码或报告。"""

    api_base: str
    api_key: str
    model: str
    thinking_mode: str

    @classmethod
    def from_env(cls) -> "LLMSettings":
        load_dotenv(PROJECT_ROOT / ".env")
        api_key = os.getenv("LLM_API_KEY", "").strip()
        if not api_key:
            raise ValueError("缺少 LLM_API_KEY，请先在 CineFlowAutoTest/.env 中填写 DeepSeek 密钥")
        thinking_mode = os.getenv("LLM_THINKING_MODE", "disabled").strip().lower()
        if thinking_mode not in {"enabled", "disabled"}:
            raise ValueError("LLM_THINKING_MODE 只能是 enabled 或 disabled")
        return cls(
            api_base=os.getenv("LLM_API_BASE", "https://api.deepseek.com").strip().rstrip("/"),
            api_key=api_key,
            model=os.getenv("LLM_MODEL", "deepseek-flash").strip(),
            thinking_mode=thinking_mode,
        )
