"""模型客户端可靠性测试，所有响应均为本地 Mock。"""

from unittest.mock import Mock, call

import pytest
import requests

from llm.client import RequestFailedError, ResponseFormatError, complete_with_retry


def fake_response(status_code: int, body=None, json_error=None):
    response = Mock(status_code=status_code, headers={"x-request-id": "req-test-001"})
    if json_error is not None:
        response.json.side_effect = json_error
    else:
        response.json.return_value = body
    return response


def invoke(post, sleep):
    return complete_with_retry(url="https://fake.example/v1/chat/completions", api_key="fake-key",
        model="fake-model", system="system", user="user", max_retries=2, post=post, sleep=sleep)


def test_client_returns_content_and_observability_fields():
    post = Mock(return_value=fake_response(200, {"model": "fake-model",
        "choices": [{"message": {"content": "回答"}}],
        "usage": {"prompt_tokens": 20, "completion_tokens": 8}}))
    result = invoke(post, Mock())
    assert (result.content, result.attempts, result.request_id) == ("回答", 1, "req-test-001")
    assert result.prompt_tokens == 20


@pytest.mark.parametrize("body,error", [({"choices": []}, "choices 缺失或为空"), (None, "不是合法 JSON")])
def test_client_rejects_invalid_success_response(body, error):
    response = fake_response(200, body, ValueError("bad json") if body is None else None)
    with pytest.raises(ResponseFormatError, match=error):
        invoke(Mock(return_value=response), Mock())


def test_client_retries_timeout_with_exponential_backoff():
    post, sleep = Mock(side_effect=requests.Timeout("timeout")), Mock()
    with pytest.raises(RequestFailedError, match="共尝试 3 次"):
        invoke(post, sleep)
    assert post.call_count == 3
    assert sleep.call_args_list == [call(1), call(2)]


def test_client_retries_429_but_not_401():
    sleep = Mock()
    post = Mock(side_effect=[fake_response(429, {}), fake_response(200, {"choices": [{"message": {"content": "成功"}}]})])
    assert invoke(post, sleep).attempts == 2
    sleep.assert_called_once_with(1)

    with pytest.raises(RequestFailedError, match="HTTP 401.*未自动重试"):
        invoke(Mock(return_value=fake_response(401, {})), Mock())
