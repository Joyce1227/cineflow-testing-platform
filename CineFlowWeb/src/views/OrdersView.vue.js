import { computed, onMounted, ref } from "vue";
import { orderApi } from "../api";
import { errorMessage } from "../api/http";
import EmptyState from "../components/EmptyState.vue";
import ErrorState from "../components/ErrorState.vue";
import LoadingState from "../components/LoadingState.vue";
import StatusBadge from "../components/StatusBadge.vue";
const orders = ref([]);
const loading = ref(true);
const error = ref("");
const activeStatus = ref("ALL");
const statuses = [{ value: "ALL", label: "全部" }, { value: "PENDING_PAYMENT", label: "待支付" }, { value: "PAID", label: "已支付" }, { value: "CANCELLED", label: "已取消" }, { value: "REFUNDED", label: "已退款" }];
const filtered = computed(() => activeStatus.value === "ALL" ? orders.value : orders.value.filter((order) => order.status === activeStatus.value));
async function load() {
    loading.value = true;
    error.value = "";
    try {
        orders.value = (await orderApi.list()).data.data;
    }
    catch (e) {
        error.value = errorMessage(e);
    }
    finally {
        loading.value = false;
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
    ...{ class: "container page-content" },
    'data-testid': "orders-page",
});
/** @type {__VLS_StyleScopedClasses['container']} */ ;
/** @type {__VLS_StyleScopedClasses['page-content']} */ ;
__VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
    ...{ class: "page-title" },
});
/** @type {__VLS_StyleScopedClasses['page-title']} */ ;
__VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({
    ...{ class: "eyebrow" },
});
/** @type {__VLS_StyleScopedClasses['eyebrow']} */ ;
__VLS_asFunctionalElement1(__VLS_intrinsics.h1, __VLS_intrinsics.h1)({});
__VLS_asFunctionalElement1(__VLS_intrinsics.p, __VLS_intrinsics.p)({});
__VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
    ...{ class: "order-tabs" },
    role: "tablist",
    'data-testid': "order-status-tabs",
});
/** @type {__VLS_StyleScopedClasses['order-tabs']} */ ;
for (const [status] of __VLS_vFor((__VLS_ctx.statuses))) {
    __VLS_asFunctionalElement1(__VLS_intrinsics.button, __VLS_intrinsics.button)({
        ...{ onClick: (...[$event]) => {
                return (__VLS_ctx.activeStatus = status.value);
                // @ts-ignore
                [statuses, activeStatus,];
            } },
        key: (status.value),
        ...{ class: ({ active: __VLS_ctx.activeStatus === status.value }) },
        'data-testid': (`order-tab-${status.value}`),
    });
    /** @type {__VLS_StyleScopedClasses['active']} */ ;
    (status.label);
    // @ts-ignore
    [activeStatus,];
}
if (__VLS_ctx.loading) {
    const __VLS_0 = LoadingState;
    // @ts-ignore
    const __VLS_1 = __VLS_asFunctionalComponent1(__VLS_0, new __VLS_0({}));
    const __VLS_2 = __VLS_1({}, ...__VLS_functionalComponentArgsRest(__VLS_1));
}
else if (__VLS_ctx.error) {
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
else if (!__VLS_ctx.filtered.length) {
    const __VLS_12 = EmptyState || EmptyState;
    // @ts-ignore
    const __VLS_13 = __VLS_asFunctionalComponent1(__VLS_12, new __VLS_12({
        title: "暂无订单",
        description: "当前分类下还没有电影票订单",
    }));
    const __VLS_14 = __VLS_13({
        title: "暂无订单",
        description: "当前分类下还没有电影票订单",
    }, ...__VLS_functionalComponentArgsRest(__VLS_13));
    const { default: __VLS_17 } = __VLS_15.slots;
    let __VLS_18;
    /** @ts-ignore @type { | typeof __VLS_components.RouterLink | typeof __VLS_components.RouterLink} */
    RouterLink;
    // @ts-ignore
    const __VLS_19 = __VLS_asFunctionalComponent1(__VLS_18, new __VLS_18({
        to: "/",
        ...{ class: "button button-primary" },
    }));
    const __VLS_20 = __VLS_19({
        to: "/",
        ...{ class: "button button-primary" },
    }, ...__VLS_functionalComponentArgsRest(__VLS_19));
    /** @type {__VLS_StyleScopedClasses['button']} */ ;
    /** @type {__VLS_StyleScopedClasses['button-primary']} */ ;
    const { default: __VLS_23 } = __VLS_21.slots;
    // @ts-ignore
    [loading, error, error, load, filtered,];
    var __VLS_21;
    // @ts-ignore
    [];
    var __VLS_15;
}
else {
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
        ...{ class: "order-list" },
        'data-testid': "order-list",
    });
    /** @type {__VLS_StyleScopedClasses['order-list']} */ ;
    for (const [order] of __VLS_vFor((__VLS_ctx.filtered))) {
        __VLS_asFunctionalElement1(__VLS_intrinsics.article, __VLS_intrinsics.article)({
            key: (order.id),
            ...{ class: "order-card" },
            'data-testid': (`order-card-${order.id}`),
        });
        /** @type {__VLS_StyleScopedClasses['order-card']} */ ;
        __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
            ...{ class: "order-card-head" },
        });
        /** @type {__VLS_StyleScopedClasses['order-card-head']} */ ;
        __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
        (order.orderNo);
        const __VLS_24 = StatusBadge;
        // @ts-ignore
        const __VLS_25 = __VLS_asFunctionalComponent1(__VLS_24, new __VLS_24({
            status: (order.status),
        }));
        const __VLS_26 = __VLS_25({
            status: (order.status),
        }, ...__VLS_functionalComponentArgsRest(__VLS_25));
        __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
            ...{ class: "order-card-body" },
        });
        /** @type {__VLS_StyleScopedClasses['order-card-body']} */ ;
        __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
            ...{ class: "ticket-mark" },
        });
        /** @type {__VLS_StyleScopedClasses['ticket-mark']} */ ;
        __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
            ...{ class: "order-main" },
        });
        /** @type {__VLS_StyleScopedClasses['order-main']} */ ;
        __VLS_asFunctionalElement1(__VLS_intrinsics.strong, __VLS_intrinsics.strong)({});
        (order.scheduleId);
        __VLS_asFunctionalElement1(__VLS_intrinsics.p, __VLS_intrinsics.p)({});
        (new Date(order.createdAt).toLocaleString("zh-CN"));
        __VLS_asFunctionalElement1(__VLS_intrinsics.p, __VLS_intrinsics.p)({});
        (order.seats.map(s => s.seatCode).join('、'));
        __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
            ...{ class: "order-amount" },
        });
        /** @type {__VLS_StyleScopedClasses['order-amount']} */ ;
        (Number(order.totalAmount).toFixed(2));
        let __VLS_29;
        /** @ts-ignore @type { | typeof __VLS_components.RouterLink | typeof __VLS_components.RouterLink} */
        RouterLink;
        // @ts-ignore
        const __VLS_30 = __VLS_asFunctionalComponent1(__VLS_29, new __VLS_29({
            to: (`/orders/${order.id}`),
            ...{ class: "button button-secondary" },
            dataTestid: (`order-detail-${order.id}`),
        }));
        const __VLS_31 = __VLS_30({
            to: (`/orders/${order.id}`),
            ...{ class: "button button-secondary" },
            dataTestid: (`order-detail-${order.id}`),
        }, ...__VLS_functionalComponentArgsRest(__VLS_30));
        /** @type {__VLS_StyleScopedClasses['button']} */ ;
        /** @type {__VLS_StyleScopedClasses['button-secondary']} */ ;
        const { default: __VLS_34 } = __VLS_32.slots;
        // @ts-ignore
        [filtered,];
        var __VLS_32;
        // @ts-ignore
        [];
    }
}
// @ts-ignore
[];
const __VLS_export = (await import('vue')).defineComponent({});
export default {};
