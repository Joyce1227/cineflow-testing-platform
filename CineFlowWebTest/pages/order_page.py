from __future__ import annotations

from selenium.webdriver.common.by import By

from pages.base_page import BasePage


class OrderPage(BasePage):
    PAGE = BasePage.testid("order-detail-page")
    ORDER_NUMBER = BasePage.testid("order-number")
    SUCCESS = BasePage.testid("order-success")
    ERROR = BasePage.testid("order-action-error")
    PAY = BasePage.testid("pay-order")
    CANCEL = BasePage.testid("cancel-order")
    REFUND = BasePage.testid("refund-order")
    CONFIRM_MODAL = BasePage.testid("confirm-modal")
    CONFIRM_ACTION = BasePage.testid("confirm-action")

    def wait_loaded(self):
        self.visible(self.PAGE)
        self.wait_loading_finished()
        self.visible(self.ORDER_NUMBER)
        return self

    def order_number(self) -> str:
        return self.text(self.ORDER_NUMBER)

    def status_text(self, status: str) -> str:
        return self.text(self.testid(f"status-{status}"))

    def pay(self):
        self.click(self.PAY)
        self.visible(self.testid("status-PAID"))
        return self

    def cancel(self):
        self.click(self.CANCEL)
        self.visible(self.CONFIRM_MODAL)
        self.click(self.CONFIRM_ACTION)
        self.visible(self.testid("status-CANCELLED"))
        return self

    def refund(self):
        self.click(self.REFUND)
        self.visible(self.CONFIRM_MODAL)
        self.click(self.CONFIRM_ACTION)
        self.visible(self.testid("status-REFUNDED"))
        return self

    def success_message(self) -> str:
        return self.text(self.SUCCESS)

    def order_id_from_url(self) -> int:
        value = self.driver.current_url.split("/orders/", 1)[1].split("?", 1)[0]
        return int(value)

