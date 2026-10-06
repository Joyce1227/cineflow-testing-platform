from __future__ import annotations

from selenium.webdriver.common.by import By

from pages.base_page import BasePage


class HomePage(BasePage):
    PAGE = BasePage.testid("home-page")
    LOGO = BasePage.testid("nav-logo")
    ALL_MOVIES = BasePage.testid("all-movies-section")
    GENRE = BasePage.testid("filter-genre")
    REGION = BasePage.testid("filter-region")
    YEAR = BasePage.testid("filter-year")
    MIN_SCORE = BasePage.testid("filter-min-score")
    FILTER_SUBMIT = BasePage.testid("filter-submit")
    FILTER_RESET = BasePage.testid("filter-reset")
    MOVIE_CARDS = (By.CSS_SELECTOR, '[data-testid^="movie-card-"]')
    FILTERED_MOVIE_CARDS = (
        By.CSS_SELECTOR,
        '[data-testid="all-movies-section"] [data-testid^="movie-card-"]',
    )
    MOVIE_DETAILS = (By.CSS_SELECTOR, '[data-testid^="movie-detail-"]')
    EMPTY_STATE = BasePage.testid("empty-state")

    def open(self):
        self.open_path("/")
        self.visible(self.PAGE)
        self.wait_loading_finished()
        return self

    def movie_cards(self):
        return self.driver.find_elements(*self.MOVIE_CARDS)

    def movie_card_texts(self) -> list[str]:
        return self.texts(self.movie_cards())

    def filtered_movie_card_texts(self) -> list[str]:
        return self.texts(self.driver.find_elements(*self.FILTERED_MOVIE_CARDS))

    def filter_movies(self, genre: str = "", region: str = "", year: str = "", min_score: str = ""):
        self.fill(self.GENRE, genre)
        self.fill(self.REGION, region)
        self.fill(self.YEAR, year)
        self.fill(self.MIN_SCORE, min_score)
        self.click(self.FILTER_SUBMIT)
        self.wait_loading_finished()
        self.visible(self.ALL_MOVIES)
        return self

    def reset_filters(self):
        self.click(self.FILTER_RESET)
        self.wait_loading_finished()
        return self

    def open_first_movie(self):
        links = self.all_present(self.MOVIE_DETAILS)
        first = self.scroll_into_view(links[0])
        self.click_element(first)
        self.wait_url_contains("/movies/")
        return self
