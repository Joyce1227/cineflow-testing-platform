import pytest

from pages.order_page import OrderPage
from utils.api_helper import ApiHelper
from utils.flows import start_checkout


@pytest.mark.e2e
@pytest.mark.serial
def test_purchase_pay_and_refund_full_flow(user_driver, settings):
    checkout = start_checkout(user_driver, settings)
    if checkout is None:
        pytest.skip("当前演示数据没有可售场次或可用座位")

    assert checkout.selected_seats().strip()
    checkout.set_agreement(True).submit_order()

    order = OrderPage(user_driver, settings.base_url, settings.timeout).wait_loaded()
    order_id = order.order_id_from_url()
    try:
        assert order.order_number().startswith("T")
        assert order.status_text("PENDING_PAYMENT") == "待支付"

        order.pay()
        assert order.status_text("PAID") == "已支付"
        assert "支付成功" in order.success_message()

        order.refund()
        assert order.status_text("REFUNDED") == "已退款"
        assert "退款成功" in order.success_message()
    finally:
        ApiHelper(settings.api_url).cleanup_order(
            settings.test_username, settings.test_password, order_id
        )

