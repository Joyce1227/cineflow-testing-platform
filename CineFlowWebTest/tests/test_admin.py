import pytest

from pages.admin_page import AdminPage


@pytest.mark.smoke
def test_admin_can_open_dashboard(admin_driver, settings):
    page = AdminPage(admin_driver, settings.base_url, settings.timeout).open().wait_loaded()

    assert "运行正常" in page.health_text()
    assert page.visible(page.MOVIES).is_displayed()
    assert page.visible(page.CINEMAS).is_displayed()

