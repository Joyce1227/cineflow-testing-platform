from pathlib import Path

import allure
import pytest

from common.assertions import assert_response
from common.data import load_cases, resolve

ROOT = Path(__file__).resolve().parents[1]
CASE_FILES = [ROOT / "cases" / name for name in ("auth_cases.yaml", "movie_cases.yaml", "stat_cases.yaml")]
CASES = [(path.stem, case) for path in CASE_FILES for case in load_cases(path)]


@pytest.mark.regression
@pytest.mark.parametrize("group,case", CASES, ids=[case["name"] for _, case in CASES])
def test_yaml_case(client, settings, group, case):
    variables = {
        "test_username": settings.test_username,
        "test_password": settings.test_password,
    }
    request = resolve(case["request"], variables)
    allure.dynamic.epic("CineFlow API 自动化测试")
    allure.dynamic.feature(group)
    allure.dynamic.story(case["name"])
    response = client.request(
        request["method"], request["path"],
        **{key: request[key] for key in ("params", "json", "headers") if key in request},
    )
    assert_response(response, case["expect"])
