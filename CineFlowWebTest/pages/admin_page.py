from __future__ import annotations

from pages.base_page import BasePage


class AdminPage(BasePage):
    LAYOUT = BasePage.testid("admin-layout")
    DASHBOARD = BasePage.testid("admin-dashboard-page")
    HEALTH = BasePage.testid("metric-health")
    MOVIES = BasePage.testid("metric-movies")
    CINEMAS = BasePage.testid("metric-cinemas")
    REFRESH = BasePage.testid("dashboard-refresh")

    def open(self):
        self.open_path("/admin")
        return self

    def wait_loaded(self):
        self.visible(self.LAYOUT)
        self.visible(self.DASHBOARD)
        self.wait_loading_finished()
        return self

    def health_text(self) -> str:
        return self.text(self.HEALTH)

    def refresh(self):
        self.click(self.REFRESH)
        self.wait_loading_finished()
        return self

