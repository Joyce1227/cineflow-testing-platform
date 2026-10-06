import pytest

from pages.home_page import HomePage


@pytest.mark.smoke
def test_browser_can_open_cineflow(driver, settings):
    page = HomePage(driver, settings.base_url, settings.timeout).open()

    assert "CineFlow" in page.visible(page.LOGO).text
    assert page.movie_cards(), "演示环境中没有可展示的电影"
