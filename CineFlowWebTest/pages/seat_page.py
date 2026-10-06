from __future__ import annotations

from selenium.webdriver.common.by import By

from pages.base_page import BasePage


class SeatPage(BasePage):
    PAGE = BasePage.testid("seat-selection-page")
    SEAT_MAP = BasePage.testid("seat-map")
    AVAILABLE_SEATS = (By.CSS_SELECTOR, 'button.seat.available:not([disabled])')
    SELECTED_SEATS = (By.CSS_SELECTOR, 'button.seat.selected')
    CONTINUE = BasePage.testid("lock-seats-submit")
    ERROR = BasePage.testid("seat-error")

    def wait_loaded(self):
        self.visible(self.PAGE)
        self.wait_loading_finished()
        self.visible(self.SEAT_MAP)
        return self

    def available_seats(self):
        return self.driver.find_elements(*self.AVAILABLE_SEATS)

    def select_first_available(self) -> str | None:
        seats = self.available_seats()
        if not seats:
            return None
        seat = seats[0]
        seat_id = seat.get_attribute("data-testid")
        self.click(self.testid(seat_id))
        self.wait.until(
            lambda driver: "selected" in driver.find_element(*self.testid(seat_id)).get_attribute("class").split()
        )
        return seat_id

    def unselect(self, seat_testid: str):
        locator = self.testid(seat_testid)
        self.click(locator)
        self.wait.until(
            lambda driver: "selected" not in driver.find_element(*locator).get_attribute("class").split()
        )
        return self

    def selected_count(self) -> int:
        return len(self.driver.find_elements(*self.SELECTED_SEATS))

    def continue_to_checkout(self):
        self.click(self.CONTINUE)
        self.wait_url_contains("/checkout")
        return self
