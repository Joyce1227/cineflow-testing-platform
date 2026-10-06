"""把真实 CineFlow API、规则 RAG 与只读 Agent 组装在一起。"""

from dataclasses import asdict
from pathlib import Path

from agent.runner import AgentModel, ReadOnlyAgent
from agent.model import OpenAICompatibleAgentModel
from agent.tools import CineFlowReadOnlyTools
from rag.chunking import build_chunks
from rag.qa import RAGAssistant
from rag.retrieval import LocalRetriever


PROJECT_ROOT = Path(__file__).resolve().parents[1]


def build_read_only_agent(model: AgentModel, base_url: str, *, use_llm_rag: bool = False) -> ReadOnlyAgent:
    """构造可运行原型；规则走 RAG，实时业务数据走 CineFlow GET API。"""
    chunks = build_chunks(PROJECT_ROOT / "ai_knowledge" / "source")
    rag = RAGAssistant(LocalRetriever(chunks), use_llm=use_llm_rag)

    def lookup(question: str) -> dict:
        # RAGAnswer 是 dataclass；转成普通字典后才能安全写入工具消息。
        return asdict(rag.answer(question))

    tools = CineFlowReadOnlyTools(base_url, refund_policy_lookup=lookup)
    return ReadOnlyAgent(model, tools)


def build_default_agent(base_url: str) -> ReadOnlyAgent:
    """使用环境变量中的 OpenAI 兼容配置构造可直接运行的 Agent。"""
    return build_read_only_agent(OpenAICompatibleAgentModel.from_env(), base_url)
