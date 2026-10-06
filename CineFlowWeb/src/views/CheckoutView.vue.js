import { computed, ref } from "vue";
import { useRouter } from "vue-router";
import { orderApi } from "../api";
import { errorMessage } from "../api/http";
import EmptyState from "../components/EmptyState.vue";
import { useBookingStore } from "../stores/booking";
import { rememberOrderMovie } from "../utils/orderMeta";
const booking = useBookingStore();
const router = useRouter();
const loading = ref(false);
const error = ref("");
const agreed = ref(true);
const total = computed(() => booking.seats.reduce((sum, seat) => sum + Number(booking.schedule?.price || 0), 0));
function idempotencyKey() {
    const storageKey = `cineflow_checkout_key_${booking.schedule?.id || 0}`;
    let value = sessionStorage.getItem(storageKey);
    if (!value) {
        value = `web-${Date.now()}-${Math.random().toString(16).slice(2)}`;
        sessionStorage.setItem(storageKey, value);
    }
    return value;
}
async function createOrder() {
    error.value = "";
    if (!agreed.value) {
        error.value = "请先同意购票须知";
        return;
    }
    if (!booking.schedule || !booking.movie || !booking.seats.length)
        return;
    loading.value = true;
    try {
        const result = await orderApi.create({
            scheduleId: booking.schedule.id,
            seatIds: booking.seats.map((seat) => seat.id),
            idempotencyKey: idempotencyKey()
        });
        rememberOrderMovie(result.data.data.id, booking.movie.id);
        booking.clear();
        await router.replace(`/orders/${result.data.data.id}?created=1`);
    }
    catch (e) {
        error.value = errorMessage(e);
    }
    finally {
        loading.value = false;
    }
}
const __VLS_ctx = {
    ...{},
    ...{},
};
let __VLS_components;
let __VLS_intrinsics;
let __VLS_directives;
__VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
    ...{ class: "container narrow-page page-content" },
    'data-testid': "checkout-page",
});
/** @type {__VLS_StyleScopedClasses['container']} */ ;
/** @type {__VLS_StyleScopedClasses['narrow-page']} */ ;
/** @type {__VLS_StyleScopedClasses['page-content']} */ ;
if (!__VLS_ctx.booking.schedule || !__VLS_ctx.booking.movie || !__VLS_ctx.booking.seats.length) {
    const __VLS_0 = EmptyState || EmptyState;
    // @ts-ignore
    const __VLS_1 = __VLS_asFunctionalComponent1(__VLS_0, new __VLS_0({
        title: "没有待确认的座位",
        description: "请先选择电影场次和座位",
    }));
    const __VLS_2 = __VLS_1({
        title: "没有待确认的座位",
        description: "请先选择电影场次和座位",
    }, ...__VLS_functionalComponentArgsRest(__VLS_1));
    const { default: __VLS_5 } = __VLS_3.slots;
    let __VLS_6;
    /** @ts-ignore @type { | typeof __VLS_components.RouterLink | typeof __VLS_components.RouterLink} */
    RouterLink;
    // @ts-ignore
    const __VLS_7 = __VLS_asFunctionalComponent1(__VLS_6, new __VLS_6({
        to: "/",
        ...{ class: "button button-primary" },
    }));
    const __VLS_8 = __VLS_7({
        to: "/",
        ...{ class: "button button-primary" },
    }, ...__VLS_functionalComponentArgsRest(__VLS_7));
    /** @type {__VLS_StyleScopedClasses['button']} */ ;
    /** @type {__VLS_StyleScopedClasses['button-primary']} */ ;
    const { default: __VLS_11 } = __VLS_9.slots;
    // @ts-ignore
    [booking, booking, booking,];
    var __VLS_9;
    // @ts-ignore
    [];
    var __VLS_3;
}
else {
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
    __VLS_asFunctionalElement1(__VLS_intrinsics.section, __VLS_intrinsics.section)({
        ...{ class: "checkout-card" },
    });
    /** @type {__VLS_StyleScopedClasses['checkout-card']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
        ...{ class: "checkout-movie" },
    });
    /** @type {__VLS_StyleScopedClasses['checkout-movie']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
        ...{ class: "mini-poster" },
    });
    /** @type {__VLS_StyleScopedClasses['mini-poster']} */ ;
    (__VLS_ctx.booking.movie.name.slice(0, 1));
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.h2, __VLS_intrinsics.h2)({});
    (__VLS_ctx.booking.movie.name);
    __VLS_asFunctionalElement1(__VLS_intrinsics.p, __VLS_intrinsics.p)({});
    (__VLS_ctx.booking.movie.genres);
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
        ...{ class: "checkout-grid" },
    });
    /** @type {__VLS_StyleScopedClasses['checkout-grid']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.strong, __VLS_intrinsics.strong)({});
    (__VLS_ctx.booking.schedule.cinemaName);
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.strong, __VLS_intrinsics.strong)({});
    (__VLS_ctx.booking.schedule.hallName);
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.strong, __VLS_intrinsics.strong)({});
    (new Date(__VLS_ctx.booking.schedule.startTime).toLocaleString("zh-CN"));
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.strong, __VLS_intrinsics.strong)({
        'data-testid': "checkout-seats",
    });
    (__VLS_ctx.booking.seats.map(s => s.seatCode).join('、'));
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
        ...{ class: "checkout-total" },
    });
    /** @type {__VLS_StyleScopedClasses['checkout-total']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    (__VLS_ctx.booking.seats.length);
    __VLS_asFunctionalElement1(__VLS_intrinsics.strong, __VLS_intrinsics.strong)({});
    (__VLS_ctx.total.toFixed(2));
    __VLS_asFunctionalElement1(__VLS_intrinsics.label, __VLS_intrinsics.label)({
        ...{ class: "check-line" },
    });
    /** @type {__VLS_StyleScopedClasses['check-line']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.input)({
        'data-testid': "purchase-agreement",
        type: "checkbox",
    });
    (__VLS_ctx.agreed);
    if (__VLS_ctx.error) {
        __VLS_asFunctionalElement1(__VLS_intrinsics.p, __VLS_intrinsics.p)({
            ...{ class: "inline-alert error" },
            role: "alert",
            'data-testid': "checkout-error",
        });
        /** @type {__VLS_StyleScopedClasses['inline-alert']} */ ;
        /** @type {__VLS_StyleScopedClasses['error']} */ ;
        (__VLS_ctx.error);
    }
    __VLS_asFunctionalElement1(__VLS_intrinsics.button, __VLS_intrinsics.button)({
        ...{ onClick: (__VLS_ctx.createOrder) },
        ...{ class: "button button-primary button-block large-action" },
        'data-testid': "create-order-submit",
        disabled: (__VLS_ctx.loading),
    });
    /** @type {__VLS_StyleScopedClasses['button']} */ ;
    /** @type {__VLS_StyleScopedClasses['button-primary']} */ ;
    /** @type {__VLS_StyleScopedClasses['button-block']} */ ;
    /** @type {__VLS_StyleScopedClasses['large-action']} */ ;
    (__VLS_ctx.loading ? "正在创建订单…" : `提交订单 · ¥${__VLS_ctx.total.toFixed(2)}`);
}
// @ts-ignore
[booking, booking, booking, booking, booking, booking, booking, booking, total, total, agreed, error, error, createOrder, loading, loading,];
const __VLS_export = (await import('vue')).defineComponent({});
export default {};
