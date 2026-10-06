import { computed, onMounted, reactive, ref } from "vue";
import { useRoute } from "vue-router";
import { orderApi, reviewApi } from "../api";
import { errorMessage } from "../api/http";
import ErrorState from "../components/ErrorState.vue";
import LoadingState from "../components/LoadingState.vue";
import StatusBadge from "../components/StatusBadge.vue";
import { orderMovieId } from "../utils/orderMeta";
const route = useRoute();
const orderId = Number(route.params.id);
const order = ref(null);
const loading = ref(true);
const actionLoading = ref(false);
const error = ref("");
const success = ref(route.query.created === "1" ? "订单创建成功，请及时完成支付" : "");
const modalAction = ref(null);
const movieId = computed(() => orderMovieId(orderId));
const review = reactive({ rating: 8, content: "" });
const reviewError = ref("");
const reviewSuccess = ref("");
async function load() {
    loading.value = true;
    error.value = "";
    try {
        order.value = (await orderApi.detail(orderId)).data.data;
    }
    catch (e) {
        error.value = errorMessage(e);
    }
    finally {
        loading.value = false;
    }
}
async function pay() {
    if (!order.value)
        return;
    actionLoading.value = true;
    error.value = "";
    success.value = "";
    try {
        const tradeNo = `WEBPAY-${Date.now()}-${order.value.id}`;
        order.value = (await orderApi.pay(order.value.id, tradeNo)).data.data;
        success.value = "支付成功，座位已出票";
    }
    catch (e) {
        error.value = errorMessage(e);
    }
    finally {
        actionLoading.value = false;
    }
}
async function confirmAction() {
    if (!order.value || !modalAction.value)
        return;
    actionLoading.value = true;
    error.value = "";
    success.value = "";
    try {
        order.value = modalAction.value === "cancel"
            ? (await orderApi.cancel(order.value.id)).data.data
            : (await orderApi.refund(order.value.id)).data.data;
        success.value = modalAction.value === "cancel" ? "订单已取消，座位已经释放" : "退款成功，座位已经释放";
        modalAction.value = null;
    }
    catch (e) {
        error.value = errorMessage(e);
        modalAction.value = null;
    }
    finally {
        actionLoading.value = false;
    }
}
async function submitReview() {
    reviewError.value = "";
    reviewSuccess.value = "";
    if (!movieId.value) {
        reviewError.value = "当前订单缺少电影信息，请从购票流程进入后再评价";
        return;
    }
    if (!review.content.trim()) {
        reviewError.value = "请输入评价内容";
        return;
    }
    actionLoading.value = true;
    try {
        await reviewApi.save(movieId.value, { rating: Number(review.rating), content: review.content.trim() });
        reviewSuccess.value = "评价发布成功";
        review.content = "";
    }
    catch (e) {
        reviewError.value = errorMessage(e);
    }
    finally {
        actionLoading.value = false;
    }
}
onMounted(load);
const __VLS_ctx = {
    ...{},
    ...{},
};
let __VLS_components;
let __VLS_intrinsics;
let __VLS_directives;
__VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
    ...{ class: "container narrow-page page-content" },
    'data-testid': "order-detail-page",
});
/** @type {__VLS_StyleScopedClasses['container']} */ ;
/** @type {__VLS_StyleScopedClasses['narrow-page']} */ ;
/** @type {__VLS_StyleScopedClasses['page-content']} */ ;
if (__VLS_ctx.loading) {
    const __VLS_0 = LoadingState;
    // @ts-ignore
    const __VLS_1 = __VLS_asFunctionalComponent1(__VLS_0, new __VLS_0({}));
    const __VLS_2 = __VLS_1({}, ...__VLS_functionalComponentArgsRest(__VLS_1));
}
else if (__VLS_ctx.error && !__VLS_ctx.order) {
    const __VLS_5 = ErrorState;
    // @ts-ignore
    const __VLS_6 = __VLS_asFunctionalComponent1(__VLS_5, new __VLS_5({
        ...{ 'onRetry': {} },
        message: (__VLS_ctx.error),
    }));
    const __VLS_7 = __VLS_6({
        ...{ 'onRetry': {} },
        message: (__VLS_ctx.error),
    }, ...__VLS_functionalComponentArgsRest(__VLS_6));
    let __VLS_10;
    const __VLS_11 = {
        /** @type {typeof __VLS_10.retry} */
        onRetry: (__VLS_ctx.load),
    };
    var __VLS_8;
    var __VLS_9;
}
else if (__VLS_ctx.order) {
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
        ...{ class: "breadcrumb" },
    });
    /** @type {__VLS_StyleScopedClasses['breadcrumb']} */ ;
    let __VLS_12;
    /** @ts-ignore @type { | typeof __VLS_components.RouterLink | typeof __VLS_components.RouterLink} */
    RouterLink;
    // @ts-ignore
    const __VLS_13 = __VLS_asFunctionalComponent1(__VLS_12, new __VLS_12({
        to: "/orders",
    }));
    const __VLS_14 = __VLS_13({
        to: "/orders",
    }, ...__VLS_functionalComponentArgsRest(__VLS_13));
    const { default: __VLS_17 } = __VLS_15.slots;
    // @ts-ignore
    [loading, error, error, order, order, load,];
    var __VLS_15;
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
        ...{ class: "order-detail-heading" },
    });
    /** @type {__VLS_StyleScopedClasses['order-detail-heading']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({
        ...{ class: "eyebrow" },
    });
    /** @type {__VLS_StyleScopedClasses['eyebrow']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.h1, __VLS_intrinsics.h1)({});
    const __VLS_18 = StatusBadge;
    // @ts-ignore
    const __VLS_19 = __VLS_asFunctionalComponent1(__VLS_18, new __VLS_18({
        status: (__VLS_ctx.order.status),
    }));
    const __VLS_20 = __VLS_19({
        status: (__VLS_ctx.order.status),
    }, ...__VLS_functionalComponentArgsRest(__VLS_19));
    if (__VLS_ctx.success) {
        __VLS_asFunctionalElement1(__VLS_intrinsics.p, __VLS_intrinsics.p)({
            ...{ class: "inline-alert success" },
            role: "status",
            'data-testid': "order-success",
        });
        /** @type {__VLS_StyleScopedClasses['inline-alert']} */ ;
        /** @type {__VLS_StyleScopedClasses['success']} */ ;
        (__VLS_ctx.success);
    }
    if (__VLS_ctx.error) {
        __VLS_asFunctionalElement1(__VLS_intrinsics.p, __VLS_intrinsics.p)({
            ...{ class: "inline-alert error" },
            role: "alert",
            'data-testid': "order-action-error",
        });
        /** @type {__VLS_StyleScopedClasses['inline-alert']} */ ;
        /** @type {__VLS_StyleScopedClasses['error']} */ ;
        (__VLS_ctx.error);
    }
    __VLS_asFunctionalElement1(__VLS_intrinsics.section, __VLS_intrinsics.section)({
        ...{ class: "ticket-detail-card" },
    });
    /** @type {__VLS_StyleScopedClasses['ticket-detail-card']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
        ...{ class: "ticket-top" },
    });
    /** @type {__VLS_StyleScopedClasses['ticket-top']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.strong, __VLS_intrinsics.strong)({
        'data-testid': "order-number",
    });
    (__VLS_ctx.order.orderNo);
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
        ...{ class: "ticket-logo" },
    });
    /** @type {__VLS_StyleScopedClasses['ticket-logo']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
        ...{ class: "ticket-info-grid" },
    });
    /** @type {__VLS_StyleScopedClasses['ticket-info-grid']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.strong, __VLS_intrinsics.strong)({});
    (__VLS_ctx.order.scheduleId);
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.strong, __VLS_intrinsics.strong)({});
    (new Date(__VLS_ctx.order.createdAt).toLocaleString("zh-CN"));
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.strong, __VLS_intrinsics.strong)({});
    (__VLS_ctx.order.seats.map(s => s.seatCode).join('、'));
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.strong, __VLS_intrinsics.strong)({});
    (__VLS_ctx.order.seats.length);
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
        ...{ class: "ticket-bottom" },
    });
    /** @type {__VLS_StyleScopedClasses['ticket-bottom']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.strong, __VLS_intrinsics.strong)({});
    (Number(__VLS_ctx.order.totalAmount).toFixed(2));
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
        ...{ class: "order-actions" },
        'data-testid': "order-actions",
    });
    /** @type {__VLS_StyleScopedClasses['order-actions']} */ ;
    if (__VLS_ctx.order.status === 'PENDING_PAYMENT') {
        __VLS_asFunctionalElement1(__VLS_intrinsics.button, __VLS_intrinsics.button)({
            ...{ onClick: (__VLS_ctx.pay) },
            ...{ class: "button button-primary" },
            'data-testid': "pay-order",
            disabled: (__VLS_ctx.actionLoading),
        });
        /** @type {__VLS_StyleScopedClasses['button']} */ ;
        /** @type {__VLS_StyleScopedClasses['button-primary']} */ ;
        (__VLS_ctx.actionLoading ? "处理中…" : "模拟支付");
    }
    if (__VLS_ctx.order.status === 'PENDING_PAYMENT') {
        __VLS_asFunctionalElement1(__VLS_intrinsics.button, __VLS_intrinsics.button)({
            ...{ onClick: (...[$event]) => {
                    if (!!(__VLS_ctx.loading))
                        throw 0;
                    if (!!(__VLS_ctx.error && !__VLS_ctx.order))
                        throw 0;
                    if (!(__VLS_ctx.order))
                        throw 0;
                    if (!(__VLS_ctx.order.status === 'PENDING_PAYMENT'))
                        throw 0;
                    return (__VLS_ctx.modalAction = 'cancel');
                    // @ts-ignore
                    [error, error, order, order, order, order, order, order, order, order, order, success, success, pay, actionLoading, actionLoading, modalAction,];
                } },
            ...{ class: "button button-danger" },
            'data-testid': "cancel-order",
            disabled: (__VLS_ctx.actionLoading),
        });
        /** @type {__VLS_StyleScopedClasses['button']} */ ;
        /** @type {__VLS_StyleScopedClasses['button-danger']} */ ;
    }
    if (__VLS_ctx.order.status === 'PAID') {
        __VLS_asFunctionalElement1(__VLS_intrinsics.button, __VLS_intrinsics.button)({
            ...{ onClick: (...[$event]) => {
                    if (!!(__VLS_ctx.loading))
                        throw 0;
                    if (!!(__VLS_ctx.error && !__VLS_ctx.order))
                        throw 0;
                    if (!(__VLS_ctx.order))
                        throw 0;
                    if (!(__VLS_ctx.order.status === 'PAID'))
                        throw 0;
                    return (__VLS_ctx.modalAction = 'refund');
                    // @ts-ignore
                    [order, actionLoading, modalAction,];
                } },
            ...{ class: "button button-danger" },
            'data-testid': "refund-order",
            disabled: (__VLS_ctx.actionLoading),
        });
        /** @type {__VLS_StyleScopedClasses['button']} */ ;
        /** @type {__VLS_StyleScopedClasses['button-danger']} */ ;
    }
    let __VLS_23;
    /** @ts-ignore @type { | typeof __VLS_components.RouterLink | typeof __VLS_components.RouterLink} */
    RouterLink;
    // @ts-ignore
    const __VLS_24 = __VLS_asFunctionalComponent1(__VLS_23, new __VLS_23({
        to: "/orders",
        ...{ class: "button button-secondary" },
    }));
    const __VLS_25 = __VLS_24({
        to: "/orders",
        ...{ class: "button button-secondary" },
    }, ...__VLS_functionalComponentArgsRest(__VLS_24));
    /** @type {__VLS_StyleScopedClasses['button']} */ ;
    /** @type {__VLS_StyleScopedClasses['button-secondary']} */ ;
    const { default: __VLS_28 } = __VLS_26.slots;
    // @ts-ignore
    [actionLoading,];
    var __VLS_26;
    if (__VLS_ctx.order.status === 'PAID' && __VLS_ctx.movieId) {
        __VLS_asFunctionalElement1(__VLS_intrinsics.section, __VLS_intrinsics.section)({
            ...{ class: "review-form-section" },
            'data-testid': "review-form-section",
        });
        /** @type {__VLS_StyleScopedClasses['review-form-section']} */ ;
        __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
            ...{ class: "section-heading" },
        });
        /** @type {__VLS_StyleScopedClasses['section-heading']} */ ;
        __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({});
        __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({
            ...{ class: "eyebrow" },
        });
        /** @type {__VLS_StyleScopedClasses['eyebrow']} */ ;
        __VLS_asFunctionalElement1(__VLS_intrinsics.h2, __VLS_intrinsics.h2)({});
        __VLS_asFunctionalElement1(__VLS_intrinsics.form, __VLS_intrinsics.form)({
            ...{ onSubmit: (__VLS_ctx.submitReview) },
            ...{ class: "review-form" },
        });
        /** @type {__VLS_StyleScopedClasses['review-form']} */ ;
        __VLS_asFunctionalElement1(__VLS_intrinsics.label, __VLS_intrinsics.label)({
            ...{ class: "form-field" },
        });
        /** @type {__VLS_StyleScopedClasses['form-field']} */ ;
        __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
        (__VLS_ctx.review.rating);
        __VLS_asFunctionalElement1(__VLS_intrinsics.input)({
            'data-testid': "review-rating",
            type: "range",
            min: "1",
            max: "10",
            step: "0.5",
        });
        (__VLS_ctx.review.rating);
        __VLS_asFunctionalElement1(__VLS_intrinsics.label, __VLS_intrinsics.label)({
            ...{ class: "form-field" },
        });
        /** @type {__VLS_StyleScopedClasses['form-field']} */ ;
        __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
        __VLS_asFunctionalElement1(__VLS_intrinsics.textarea, __VLS_intrinsics.textarea)({
            value: (__VLS_ctx.review.content),
            'data-testid': "review-content",
            maxlength: "1000",
            rows: "4",
            placeholder: "分享你的观影感受…",
        });
        if (__VLS_ctx.reviewError) {
            __VLS_asFunctionalElement1(__VLS_intrinsics.p, __VLS_intrinsics.p)({
                ...{ class: "inline-alert error" },
                role: "alert",
                'data-testid': "review-error",
            });
            /** @type {__VLS_StyleScopedClasses['inline-alert']} */ ;
            /** @type {__VLS_StyleScopedClasses['error']} */ ;
            (__VLS_ctx.reviewError);
        }
        if (__VLS_ctx.reviewSuccess) {
            __VLS_asFunctionalElement1(__VLS_intrinsics.p, __VLS_intrinsics.p)({
                ...{ class: "inline-alert success" },
                role: "status",
                'data-testid': "review-success",
            });
            /** @type {__VLS_StyleScopedClasses['inline-alert']} */ ;
            /** @type {__VLS_StyleScopedClasses['success']} */ ;
            (__VLS_ctx.reviewSuccess);
        }
        __VLS_asFunctionalElement1(__VLS_intrinsics.button, __VLS_intrinsics.button)({
            ...{ class: "button button-primary" },
            'data-testid': "review-submit",
            disabled: (__VLS_ctx.actionLoading),
        });
        /** @type {__VLS_StyleScopedClasses['button']} */ ;
        /** @type {__VLS_StyleScopedClasses['button-primary']} */ ;
    }
    if (__VLS_ctx.modalAction) {
        __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
            ...{ onClick: (...[$event]) => {
                    if (!!(__VLS_ctx.loading))
                        throw 0;
                    if (!!(__VLS_ctx.error && !__VLS_ctx.order))
                        throw 0;
                    if (!(__VLS_ctx.order))
                        throw 0;
                    if (!(__VLS_ctx.modalAction))
                        throw 0;
                    return (__VLS_ctx.modalAction = null);
                    // @ts-ignore
                    [order, actionLoading, modalAction, modalAction, movieId, submitReview, review, review, review, reviewError, reviewError, reviewSuccess, reviewSuccess,];
                } },
            ...{ class: "modal-backdrop" },
            'data-testid': "confirm-modal",
        });
        /** @type {__VLS_StyleScopedClasses['modal-backdrop']} */ ;
        __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
            ...{ class: "confirm-modal" },
            role: "dialog",
            'aria-modal': "true",
            'aria-labelledby': "confirm-title",
        });
        /** @type {__VLS_StyleScopedClasses['confirm-modal']} */ ;
        __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
            ...{ class: "modal-symbol" },
        });
        /** @type {__VLS_StyleScopedClasses['modal-symbol']} */ ;
        __VLS_asFunctionalElement1(__VLS_intrinsics.h2, __VLS_intrinsics.h2)({
            id: "confirm-title",
        });
        (__VLS_ctx.modalAction === 'cancel' ? '取消订单' : '申请退款');
        __VLS_asFunctionalElement1(__VLS_intrinsics.p, __VLS_intrinsics.p)({});
        (__VLS_ctx.modalAction === 'cancel' ? '取消后座位将立即释放，操作不可撤销。' : '退款后订单将关闭，对应座位会重新开放。');
        __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({});
        __VLS_asFunctionalElement1(__VLS_intrinsics.button, __VLS_intrinsics.button)({
            ...{ onClick: (...[$event]) => {
                    if (!!(__VLS_ctx.loading))
                        throw 0;
                    if (!!(__VLS_ctx.error && !__VLS_ctx.order))
                        throw 0;
                    if (!(__VLS_ctx.order))
                        throw 0;
                    if (!(__VLS_ctx.modalAction))
                        throw 0;
                    return (__VLS_ctx.modalAction = null);
                    // @ts-ignore
                    [modalAction, modalAction, modalAction,];
                } },
            ...{ class: "button button-ghost" },
            'data-testid': "confirm-dismiss",
        });
        /** @type {__VLS_StyleScopedClasses['button']} */ ;
        /** @type {__VLS_StyleScopedClasses['button-ghost']} */ ;
        __VLS_asFunctionalElement1(__VLS_intrinsics.button, __VLS_intrinsics.button)({
            ...{ onClick: (__VLS_ctx.confirmAction) },
            ...{ class: "button button-danger" },
            'data-testid': "confirm-action",
            disabled: (__VLS_ctx.actionLoading),
        });
        /** @type {__VLS_StyleScopedClasses['button']} */ ;
        /** @type {__VLS_StyleScopedClasses['button-danger']} */ ;
        (__VLS_ctx.modalAction === 'cancel' ? '取消' : '退款');
    }
}
// @ts-ignore
[actionLoading, modalAction, confirmAction,];
const __VLS_export = (await import('vue')).defineComponent({});
export default {};
