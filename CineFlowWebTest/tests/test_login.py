import pytest
from selenium.webdriver.common.by import By

from pages.base_page import BasePage
from pages.login_page import LoginPage


@pytest.mark.smoke
def test_user_can_login_and_logout(driver, settings):
    page = LoginPage(driver, settings.base_url, settings.timeout).open()
    page.login(settings.test_username, settings.test_password).wait_for_login_success()

    base = BasePage(driver, settings.base_url, settings.timeout)
    base.click(base.testid("user-menu-button"))
    base.click(base.testid("logout-button"))

    assert base.visible(base.testid("nav-login")).is_displayed()


@pytest.mark.regression
def test_wrong_password_shows_business_error(driver, settings):
    page = LoginPage(driver, settings.base_url, settings.timeout).open()
    page.login(settings.test_username, "WrongPassword123")

    assert "用户名或密码错误" in page.error_message()


@pytest.mark.regression
def test_empty_login_form_shows_field_errors(driver, settings):
    page = LoginPage(driver, settings.base_url, settings.timeout).open()
    page.submit_empty_form()

    assert page.field_errors() == ["请输入用户名", "请输入密码"]

