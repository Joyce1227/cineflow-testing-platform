from __future__ import annotations

import re
import os
import sys
from datetime import datetime
from pathlib import Path

import allure
import pytest
from selenium import webdriver
from selenium.webdriver.chrome.options import Options as ChromeOptions
from selenium.webdriver.edge.options import Options as EdgeOptions
from selenium.webdriver.firefox.options import Options as FirefoxOptions


ROOT = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT))

from settings import Settings
from utils.api_helper import ApiHelper


def _bypass_proxy_for_local_services() -> None:
    for name in ("NO_PROXY", "no_proxy"):
        values = [item.strip() for item in os.environ.get(name, "").split(",") if item.strip()]
        for host in ("localhost", "127.0.0.1"):
            if host not in values:
                values.append(host)
        os.environ[name] = ",".join(values)


def pytest_addoption(parser: pytest.Parser) -> None:
    group = parser.getgroup("cineflow-web")
    group.addoption("--web-base-url", action="store", default=None, help="CineFlow Web base URL")
    group.addoption("--web-api-url", action="store", default=None, help="CineFlow API base URL")
    group.addoption("--browser", action="store", choices=("chrome", "edge", "firefox"), default=None)
    group.addoption("--headless", action="store_true", default=False, help="Run the browser without a window")
    group.addoption("--skip-service-check", action="store_true", default=False)


@pytest.fixture(scope="session")
def settings(pytestconfig: pytest.Config) -> Settings:
    loaded = Settings.load()
    values = dict(loaded.__dict__)
    if base_url := pytestconfig.getoption("--web-base-url"):
        values["base_url"] = base_url.rstrip("/")
    if api_url := pytestconfig.getoption("--web-api-url"):
        values["api_url"] = api_url.rstrip("/")
    if browser := pytestconfig.getoption("--browser"):
        values["browser"] = browser
    if pytestconfig.getoption("--headless"):
        values["headless"] = True
    return Settings(**values)


@pytest.fixture(scope="session", autouse=True)
def services_ready(settings: Settings, pytestconfig: pytest.Config) -> None:
    if pytestconfig.getoption("--skip-service-check"):
        return
    ApiHelper(settings.api_url).assert_services_ready(settings.base_url)


def _chrome(settings: Settings, profile_dir: Path):
    options = ChromeOptions()
    options.page_load_strategy = "eager"
    if settings.headless:
        options.add_argument("--headless=new")
    options.add_argument(f"--window-size={settings.window_width},{settings.window_height}")
    options.add_argument("--disable-notifications")
    options.add_argument("--disable-gpu")
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument("--no-sandbox")
    options.add_argument("--remote-debugging-pipe")
    options.add_argument(f"--user-data-dir={profile_dir}")
    return webdriver.Chrome(options=options)


def _edge(settings: Settings, profile_dir: Path):
    options = EdgeOptions()
    options.page_load_strategy = "eager"
    if settings.headless:
        options.add_argument("--headless=new")
    options.add_argument(f"--window-size={settings.window_width},{settings.window_height}")
    options.add_argument("--disable-notifications")
    options.add_argument("--disable-gpu")
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument("--no-sandbox")
    options.add_argument("--remote-debugging-pipe")
    options.add_argument(f"--user-data-dir={profile_dir}")
    return webdriver.Edge(options=options)


def _firefox(settings: Settings, _profile_dir: Path):
    options = FirefoxOptions()
    options.page_load_strategy = "eager"
    if settings.headless:
        options.add_argument("-headless")
    driver = webdriver.Firefox(options=options)
    driver.set_window_size(settings.window_width, settings.window_height)
    return driver


@pytest.fixture
def driver(settings: Settings, tmp_path: Path):
    _bypass_proxy_for_local_services()
    factories = {"chrome": _chrome, "edge": _edge, "firefox": _firefox}
    browser = factories[settings.browser](settings, tmp_path / "browser-profile")
    browser.set_page_load_timeout(max(settings.timeout * 3, 30))
    yield browser
    browser.quit()


@pytest.fixture
def user_driver(driver, settings: Settings):
    _set_authenticated_state(driver, settings, settings.test_username, settings.test_password)
    return driver


@pytest.fixture
def admin_driver(driver, settings: Settings):
    _set_authenticated_state(driver, settings, settings.admin_username, settings.admin_password)
    return driver


def _set_authenticated_state(driver, settings: Settings, username: str, password: str) -> None:
    login = ApiHelper(settings.api_url).login_result(username, password)
    driver.get(settings.base_url)
    driver.execute_script(
        "localStorage.setItem('cineflow_token', arguments[0]);"
        "localStorage.setItem('cineflow_user', JSON.stringify(arguments[1]));",
        login["token"],
        login["user"],
    )
    driver.refresh()


@pytest.hookimpl(hookwrapper=True)
def pytest_runtest_makereport(item: pytest.Item, call: pytest.CallInfo):
    outcome = yield
    report = outcome.get_result()
    if report.when != "call" or not report.failed:
        return
    browser = item.funcargs.get("driver")
    if browser is None:
        return
    screenshot_dir = ROOT / "reports" / "screenshots"
    screenshot_dir.mkdir(parents=True, exist_ok=True)
    safe_name = re.sub(r"[^A-Za-z0-9_.-]+", "_", item.nodeid)
    path = screenshot_dir / f"{safe_name}-{datetime.now():%Y%m%d-%H%M%S}.png"
    browser.save_screenshot(str(path))
    allure.attach.file(str(path), name="failure-screenshot", attachment_type=allure.attachment_type.PNG)
    allure.attach(browser.current_url, name="failure-url", attachment_type=allure.attachment_type.TEXT)
