import pytest

from pages.home_page import HomePage
from pages.movie_detail_page import MovieDetailPage


@pytest.mark.regression
def test_filter_movies_by_genre(driver, settings):
    page = HomePage(driver, settings.base_url, settings.timeout).open()
    page.filter_movies(genre="科幻")

    results = page.filtered_movie_card_texts()
    assert results, "演示数据中没有科幻电影"
    assert all("科幻" in text for text in results)

    page.reset_filters()
    assert page.filtered_movie_card_texts()


@pytest.mark.smoke
def test_open_movie_detail(driver, settings):
    HomePage(driver, settings.base_url, settings.timeout).open().open_first_movie()
    detail = MovieDetailPage(driver, settings.base_url, settings.timeout).wait_loaded()

    assert detail.movie_name().strip()
    assert "/movies/" in driver.current_url

