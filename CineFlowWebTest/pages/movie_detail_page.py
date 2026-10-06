from __future__ import annotations

from selenium.webdriver.common.by import By

from pages.base_page import BasePage


class MovieDetailPage(BasePage):
    PAGE = BasePage.testid("movie-detail-page")
    MOVIE_NAME = BasePage.testid("movie-name")
    SCHEDULE_LIST = BasePage.testid("schedule-list")
    CHOOSE_SCHEDULE = (By.CSS_SELECTOR, '[data-testid^="choose-schedule-"]')

    def wait_loaded(self):
        self.visible(self.PAGE)
        self.wait_loading_finished()
        return self

    def movie_name(self) -> str:
        return self.text(self.MOVIE_NAME)

    def schedule_buttons(self):
        return self.driver.find_elements(*self.CHOOSE_SCHEDULE)

    def choose_first_schedule(self) -> bool:
        buttons = self.schedule_buttons()
        if not buttons:
            return False
        button = self.scroll_into_view(buttons[0])
        self.click_element(button)
        self.wait_url_contains("/seats")
        return True
