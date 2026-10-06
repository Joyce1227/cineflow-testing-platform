from __future__ import annotations

import re

from selenium.webdriver.remote.webdriver import WebDriver

from pages.checkout_page import CheckoutPage
from pages.base_page import BasePage
from pages.home_page import HomePage
from pages.movie_detail_page import MovieDetailPage
from pages.seat_page import SeatPage
from settings import Settings


def find_seat_page_with_availability(driver: WebDriver, settings: Settings) -> SeatPage | None:
    """Find the first demo-data schedule that currently has an available seat."""
    home = HomePage(driver, settings.base_url, settings.timeout).open()
    detail_hrefs = []
    for link in driver.find_elements(*home.MOVIE_DETAILS):
        href = link.get_attribute("href")
        if href and href not in detail_hrefs:
            detail_hrefs.append(href)

    for href in detail_hrefs:
        BasePage(driver, settings.base_url, settings.timeout).open_path(href)
        detail = MovieDetailPage(driver, settings.base_url, settings.timeout).wait_loaded()
        match = re.search(r"/movies/(\d+)", driver.current_url)
        if not match:
            continue
        movie_id = int(match.group(1))
        schedule_ids = []
        for button in detail.schedule_buttons():
            testid = button.get_attribute("data-testid") or ""
            schedule_match = re.fullmatch(r"choose-schedule-(\d+)", testid)
            if schedule_match:
                schedule_ids.append(int(schedule_match.group(1)))

        for schedule_id in schedule_ids:
            BasePage(driver, settings.base_url, settings.timeout).open_path(
                f"/movies/{movie_id}/schedules/{schedule_id}/seats"
            )
            seat_page = SeatPage(driver, settings.base_url, settings.timeout).wait_loaded()
            if seat_page.available_seats():
                return seat_page
    return None


def start_checkout(driver: WebDriver, settings: Settings) -> CheckoutPage | None:
    seat_page = find_seat_page_with_availability(driver, settings)
    if seat_page is None or seat_page.select_first_available() is None:
        return None
    seat_page.continue_to_checkout()
    return CheckoutPage(driver, settings.base_url, settings.timeout).wait_loaded()
