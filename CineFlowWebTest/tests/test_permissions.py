import pytest

from pages.base_page import BasePage
from pages.login_page import LoginPage


@pytest.mark.smoke
def test_guest_is_redirected_to_login_for_orders(driver, settings):
    driver.get(f"{settings.base_url}/orders")
    page = LoginPage(driver, settings.base_url, settings.timeout)

    assert page.visible(page.PAGE).is_displayed()
    assert "/login" in driver.current_url
    assert "redirect=/orders" in driver.current_url


@pytest.mark.regression
def test_normal_user_cannot_open_admin(user_driver, settings):
    page = BasePage(user_driver, settings.base_url, settings.timeout)
    page.open_path("/admin")

    assert page.visible(page.testid("forbidden-page")).is_displayed()
    assert user_driver.current_url.endswith("/forbidden")
