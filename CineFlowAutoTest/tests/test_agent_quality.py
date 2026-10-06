"""Agent 工具选择、参数、安全边界、轨迹和步数限制测试。"""

from unittest.mock import Mock

from agent.factory import build_read_only_agent
from agent.model import OpenAICompatibleAgentModel
from agent.runner import ReadOnlyAgent
from agent.testing import ScriptedModel
from agent.tools import CineFlowReadOnlyTools, sanitize_tool_result


def fake_response(data, status_code=200, code=0):
    response = Mock(status_code=status_code)
    response.json.return_value = {"code": code, "message": "success", "data": data}
    return response


def tool_call(name, arguments, call_id="call-1"):
    return {"content": None, "tool_calls": [{"id": call_id, "name": name, "arguments": arguments}]}


def test_agent_selects_search_tool_and_records_trace():
    get = Mock(return_value=fake_response({"list": [{"id": 1, "name": "星际穿越"}]}))
    model = ScriptedModel([tool_call("search_movies", '{"genre":"科幻","limit":3}'),
                           {"content": "找到《星际穿越》。", "tool_calls": []}])
    result = ReadOnlyAgent(model, CineFlowReadOnlyTools("http://cineflow.test", get=get)).run("推荐三部科幻片")

    assert result.status == "completed"
    assert result.answer == "找到《星际穿越》。"
    assert result.steps[0].tool_name == "search_movies"
    assert result.steps[0].arguments == {"genre": "科幻", "limit": 3}
    get.assert_called_once_with("http://cineflow.test/api/movies",
                                params={"genre": "科幻", "pageNum": 1, "pageSize": 3}, timeout=10)


def test_agent_filters_unavailable_seats_before_returning_to_model():
    get = Mock(return_value=fake_response([{"id": 1, "status": "AVAILABLE"}, {"id": 2, "status": "LOCKED"}]))
    model = ScriptedModel([tool_call("get_available_seats", {"schedule_id": 8}),
                           {"content": "1 号座位可用。", "tool_calls": []}])
    result = ReadOnlyAgent(model, CineFlowReadOnlyTools("http://cineflow.test", get=get)).run("场次 8 有哪些座位？")

    assert result.steps[0].result == [{"id": 1, "status": "AVAILABLE"}]


def test_agent_blocks_write_tool_without_calling_backend():
    get = Mock()
    model = ScriptedModel([tool_call("refund_order", {"order_id": 99})])
    result = ReadOnlyAgent(model, CineFlowReadOnlyTools("http://cineflow.test", get=get)).run("退款订单 99")

    assert result.status == "blocked"
    assert result.steps[0].outcome == "blocked"
    get.assert_not_called()


def test_agent_blocks_unknown_or_out_of_range_arguments():
    get = Mock()
    model = ScriptedModel([tool_call("search_movies", {"limit": 999, "sql": "drop table movie"})])
    result = ReadOnlyAgent(model, CineFlowReadOnlyTools("http://cineflow.test", get=get)).run("查电影")

    assert result.status == "blocked"
    get.assert_not_called()


def test_agent_blocks_malformed_tool_call():
    model = ScriptedModel([{"content": None, "tool_calls": [{"name": "search_movies"}]}])
    result = ReadOnlyAgent(model, CineFlowReadOnlyTools("http://cineflow.test")).run("查电影")

    assert result.status == "blocked"
    assert result.steps[0].tool_name == "search_movies"


def test_agent_stops_at_configured_step_limit():
    get = Mock(return_value=fake_response([]))
    calls = [tool_call("get_hot_recommendations", {"limit": 1}, f"call-{index}") for index in range(3)]
    result = ReadOnlyAgent(ScriptedModel(calls), CineFlowReadOnlyTools("http://cineflow.test", get=get), max_steps=3).run("一直查")

    assert result.status == "step_limit"
    assert len(result.steps) == 3


def test_agent_routes_policy_question_to_rag_lookup():
    lookup = Mock(return_value={"answer": "开场前可按规则退款。", "citations": ["refund#1"]})
    model = ScriptedModel([tool_call("get_refund_policy", {}),
                           {"content": "开场前可按规则退款。", "tool_calls": []}])
    result = ReadOnlyAgent(model, CineFlowReadOnlyTools("http://cineflow.test", refund_policy_lookup=lookup)).run("退款规则是什么？")

    assert result.status == "completed"
    lookup.assert_called_once()


def test_factory_connects_agent_to_real_local_rag():
    """覆盖 Agent→工具→RAGAnswer dataclass→工具结果的完整序列化链路。"""
    model = ScriptedModel([
        tool_call("get_refund_policy", {}),
        {"content": "退款规则已经依据知识库给出。", "tool_calls": []},
    ])

    result = build_read_only_agent(model, "http://cineflow.test").run("讲解退款规则")

    assert result.status == "completed"
    assert result.steps[0].outcome == "success"
    assert isinstance(result.steps[0].result, dict)
    assert result.steps[0].result["citations"]
    assert result.steps[0].result["refused"] is False


def test_tool_result_is_bounded_and_redacts_secrets():
    result = sanitize_tool_result({"token": "secret", "description": "x" * 3000,
                                   "items": list(range(150))})

    assert result["token"] == "<redacted>"
    assert len(result["description"]) == 2000
    assert len(result["items"]) == 100


def test_openai_adapter_normalizes_nested_function_call():
    response = Mock(status_code=200)
    response.json.return_value = {"choices": [{"message": {"content": None, "tool_calls": [
        {"id": "call-1", "type": "function", "function": {"name": "search_movies", "arguments": '{"limit":3}'}}
    ]}}]}
    post = Mock(return_value=response)
    model = OpenAICompatibleAgentModel("https://fake.example/v1", "fake-key", "fake-model", post=post)

    tools = [{"type": "function", "function": {"name": "search_movies", "parameters": {"type": "object"}}}]
    messages = [
        {"role": "user", "content": "推荐电影"},
        {"role": "assistant", "content": "", "tool_calls": [
            {"id": "old-call", "name": "search_movies", "arguments": '{"limit":3}'}
        ]},
        {"role": "tool", "tool_call_id": "old-call", "name": "search_movies", "content": "[]"},
    ]

    result = model.complete(messages, tools)

    assert result["tool_calls"] == [{"id": "call-1", "name": "search_movies", "arguments": '{"limit":3}'}]
    payload = post.call_args.kwargs["json"]
    assert payload["tool_choice"] == "auto"
    assert payload["thinking"] == {"type": "disabled"}
    assert payload["messages"][1]["tool_calls"][0] == {
        "id": "old-call", "type": "function",
        "function": {"name": "search_movies", "arguments": '{"limit":3}'},
    }
    assert "name" not in payload["messages"][2]


def test_openai_adapter_omits_tool_fields_when_no_tools_are_available():
    response = Mock(status_code=200)
    response.json.return_value = {"choices": [{"message": {"content": "pong"}}]}
    post = Mock(return_value=response)
    model = OpenAICompatibleAgentModel("https://api.deepseek.com", "fake-key", "deepseek-flash", post=post)

    result = model.complete([{"role": "user", "content": "ping"}], [])

    assert result == {"content": "pong", "tool_calls": []}
    payload = post.call_args.kwargs["json"]
    assert "tools" not in payload
    assert "tool_choice" not in payload
