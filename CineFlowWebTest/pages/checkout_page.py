from __future__ import annotations

from pages.base_page import BasePage


class CheckoutPage(BasePage):
    PAGE = BasePage.testid("checkout-page")
    SEATS = BasePage.testid("checkout-seats")
    AGREEMENT = BasePage.testid("purchase-agreement")
    SUBMIT = BasePage.testid("create-order-submit")
    ERROR = BasePage.testid("checkout-error")

    def wait_loaded(self):
        self.visible(self.PAGE)
        self.visible(self.SUBMIT)
        return self

    def selected_seats(self) -> str:
        return self.text(self.SEATS)

    def set_agreement(self, checked: bool):
        checkbox = self.visible(self.AGREEMENT)
        if checkbox.is_selected() != checked:
            checkbox.click()
        return self

    def submit_order(self):
        self.click(self.SUBMIT)
        self.wait_url_contains("/orders/")
        return self

    def error_message(self) -> str:
        return self.text(self.ERROR)

