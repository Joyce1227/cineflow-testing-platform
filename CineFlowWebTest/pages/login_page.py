from __future__ import annotations

from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait

from pages.base_page import BasePage


class LoginPage(BasePage):
    PAGE = BasePage.testid("login-page")
    USERNAME = BasePage.testid("login-username")
    PASSWORD = BasePage.testid("login-password")
    SUBMIT = BasePage.testid("login-submit")
    ERROR = BasePage.testid("login-error")
    USER_MENU = BasePage.testid("user-menu-button")
    FIELD_ERRORS = (By.CSS_SELECTOR, ".field-error")

    def open(self):
        self.open_path("/login")
        self.visible(self.PAGE)
        return self

    def login(self, username: str, password: str):
        self.fill(self.USERNAME, username)
        self.fill(self.PASSWORD, password)
        self.click(self.SUBMIT)
        return self

    def wait_for_login_success(self):
        WebDriverWait(self.driver, self.timeout).until(
            lambda driver: (
                "/login" not in driver.current_url
                and bool(driver.execute_script("return localStorage.getItem('cineflow_token');"))
            )
        )
        return self

    def error_message(self) -> str:
        return self.text(self.ERROR)

    def submit_empty_form(self):
        self.click(self.SUBMIT)
        return self

    def field_errors(self) -> list[str]:
        return self.texts(self.all_present(self.FIELD_ERRORS))
