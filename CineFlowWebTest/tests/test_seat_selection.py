import pytest

from utils.flows import find_seat_page_with_availability


@pytest.mark.regression
def test_available_seat_can_be_selected_and_unselected(user_driver, settings):
    page = find_seat_page_with_availability(user_driver, settings)
    if page is None:
        pytest.skip("当前演示数据没有可售场次或可用座位")

    seat_testid = page.select_first_available()
    assert seat_testid is not None
    assert page.selected_count() == 1

    page.unselect(seat_testid)
    assert page.selected_count() == 0
