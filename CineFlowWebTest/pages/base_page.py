from __future__ import annotations

from typing import Iterable

from selenium.common.exceptions import ElementClickInterceptedException, TimeoutException
from selenium.webdriver.common.by import By
from selenium.webdriver.remote.webdriver import WebDriver
from selenium.webdriver.remote.webelement import WebElement
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait


Locator = tuple[str, str]


class BasePage:
    LOADING: Locator = (By.CSS_SELECTOR, '[data-testid="loading-state"]')

    def __init__(self, driver: WebDriver, base_url: str, timeout: int = 10):
        self.driver = driver
        self.base_url = base_url.rstrip("/")
        self.timeout = timeout
        self.wait = WebDriverWait(driver, timeout)

    @staticmethod
    def testid(value: str) -> Locator:
        return By.CSS_SELECTOR, f'[data-testid="{value}"]'

    def open_path(self, path: str):
        target = path if path.startswith("http") else f"{self.base_url}/{path.lstrip('/')}"
        if self.driver.current_url.rstrip("/") == target.rstrip("/"):
            return self
        if self.driver.current_url.startswith(self.base_url):
            # SPA navigation should not wait for unrelated image resources.
            self.driver.execute_script("window.location.assign(arguments[0]);", target)
        else:
            self.driver.get(target)
        return self

    def visible(self, locator: Locator) -> WebElement:
        return self.wait.until(EC.visibility_of_element_located(locator))

    def clickable(self, locator: Locator) -> WebElement:
        return self.wait.until(EC.element_to_be_clickable(locator))

    def all_present(self, locator: Locator) -> list[WebElement]:
        return self.wait.until(EC.presence_of_all_elements_located(locator))

    def click(self, locator: Locator) -> WebElement:
        element = self.clickable(locator)
        self.click_element(element)
        return element

    def click_element(self, element: WebElement) -> WebElement:
        self.scroll_into_view(element)
        try:
            element.click()
        except ElementClickInterceptedException:
            # Sticky headers and CSS transitions can briefly cover a valid target.
            self.driver.execute_script("arguments[0].click();", element)
        return element

    def fill(self, locator: Locator, value: str) -> WebElement:
        element = self.visible(locator)
        element.clear()
        element.send_keys(value)
        return element

    def text(self, locator: Locator) -> str:
        return self.visible(locator).text

    def exists(self, locator: Locator, timeout: float = 1.0) -> bool:
        try:
            WebDriverWait(self.driver, timeout).until(EC.presence_of_element_located(locator))
            return True
        except TimeoutException:
            return False

    def wait_absent(self, locator: Locator) -> None:
        self.wait.until(EC.invisibility_of_element_located(locator))

    def wait_loading_finished(self) -> None:
        if self.driver.find_elements(*self.LOADING):
            self.wait_absent(self.LOADING)

    def wait_url_contains(self, value: str) -> None:
        self.wait.until(EC.url_contains(value))

    def scroll_into_view(self, element: WebElement) -> WebElement:
        self.driver.execute_script("arguments[0].scrollIntoView({block: 'center'});", element)
        return element

    @staticmethod
    def texts(elements: Iterable[WebElement]) -> list[str]:
        return [element.text for element in elements]
