import { computed, onMounted, ref } from "vue";
import { useRoute, useRouter } from "vue-router";
import { movieApi, orderApi } from "../api";
import { errorMessage } from "../api/http";
import ErrorState from "../components/ErrorState.vue";
import LoadingState from "../components/LoadingState.vue";
import { useBookingStore } from "../stores/booking";
const route = useRoute();
const router = useRouter();
const booking = useBookingStore();
const movieId = Number(route.params.movieId);
const scheduleId = Number(route.params.scheduleId);
const movie = ref(null);
const schedule = ref(null);
const seats = ref([]);
const selectedIds = ref([]);
const loading = ref(true);
const submitting = ref(false);
const error = ref("");
const actionError = ref("");
const rows = computed(() => {
    const result = new Map();
    seats.value.forEach((seat) => {
        if (!result.has(seat.seatRow))
            result.set(seat.seatRow, []);
        result.get(seat.seatRow).push(seat);
    });
    return [...result.entries()].map(([name, values]) => [name, values.sort((a, b) => a.seatNumber - b.seatNumber)]);
});
const selectedSeats = computed(() => seats.value.filter((seat) => selectedIds.value.includes(seat.id)));
const total = computed(() => selectedIds.value.length * Number(schedule.value?.price || 0));
async function load() {
    loading.value = true;
    error.value = "";
    try {
        const [movieResult, scheduleResult, seatResult] = await Promise.all([
            movieApi.detail(movieId), movieApi.schedules(movieId), movieApi.seats(scheduleId)
        ]);
        movie.value = movieResult.data.data;
        schedule.value = scheduleResult.data.data.find((item) => item.id === scheduleId) || null;
        if (!schedule.value)
            throw new Error("场次不存在或已停止售票");
        seats.value = seatResult.data.data;
    }
    catch (e) {
        error.value = errorMessage(e);
    }
    finally {
        loading.value = false;
    }
}
function toggleSeat(seat) {
    actionError.value = "";
    if (seat.status !== "AVAILABLE")
        return;
    if (selectedIds.value.includes(seat.id)) {
        selectedIds.value = selectedIds.value.filter((id) => id !== seat.id);
    }
    else if (selectedIds.value.length >= 8) {
        actionError.value = "一次最多选择8个座位";
    }
    else {
        selectedIds.value.push(seat.id);
    }
}
async function lockAndContinue() {
    actionError.value = "";
    if (!selectedIds.value.length) {
        actionError.value = "请至少选择一个座位";
        return;
    }
    if (!movie.value || !schedule.value)
        return;
    submitting.value = true;
    try {
        const result = await orderApi.lock(scheduleId, selectedIds.value);
        booking.setSelection(movie.value, schedule.value, result.data.data.seats, result.data.data.expiresAt);
        await router.push("/checkout");
    }
    catch (e) {
        actionError.value = errorMessage(e);
        await load();
        selectedIds.value = [];
    }
    finally {
        submitting.value = false;
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
    'data-testid': "seat-selection-page",
});
/** @type {__VLS_StyleScopedClasses['container']} */ ;
/** @type {__VLS_StyleScopedClasses['page-content']} */ ;
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
else if (__VLS_ctx.movie && __VLS_ctx.schedule) {
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
        ...{ class: "breadcrumb" },
    });
    /** @type {__VLS_StyleScopedClasses['breadcrumb']} */ ;
    let __VLS_12;
    /** @ts-ignore @type { | typeof __VLS_components.RouterLink | typeof __VLS_components.RouterLink} */
    RouterLink;
    // @ts-ignore
    const __VLS_13 = __VLS_asFunctionalComponent1(__VLS_12, new __VLS_12({
        to: (`/movies/${__VLS_ctx.movie.id}`),
    }));
    const __VLS_14 = __VLS_13({
        to: (`/movies/${__VLS_ctx.movie.id}`),
    }, ...__VLS_functionalComponentArgsRest(__VLS_13));
    const { default: __VLS_17 } = __VLS_15.slots;
    (__VLS_ctx.movie.name);
    // @ts-ignore
    [loading, error, error, load, movie, movie, movie, schedule,];
    var __VLS_15;
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.section, __VLS_intrinsics.section)({
        ...{ class: "booking-layout" },
    });
    /** @type {__VLS_StyleScopedClasses['booking-layout']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
        ...{ class: "seat-panel" },
    });
    /** @type {__VLS_StyleScopedClasses['seat-panel']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
        ...{ class: "booking-heading" },
    });
    /** @type {__VLS_StyleScopedClasses['booking-heading']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({
        ...{ class: "eyebrow" },
    });
    /** @type {__VLS_StyleScopedClasses['eyebrow']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.h1, __VLS_intrinsics.h1)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.p, __VLS_intrinsics.p)({});
    (__VLS_ctx.schedule.cinemaName);
    (__VLS_ctx.schedule.hallName);
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
        ...{ class: "screen" },
    });
    /** @type {__VLS_StyleScopedClasses['screen']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
        ...{ class: "seat-map" },
        'data-testid': "seat-map",
    });
    /** @type {__VLS_StyleScopedClasses['seat-map']} */ ;
    for (const [[rowName, rowSeats]] of __VLS_vFor((__VLS_ctx.rows))) {
        __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
            key: (rowName),
            ...{ class: "seat-row" },
        });
        /** @type {__VLS_StyleScopedClasses['seat-row']} */ ;
        __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({
            ...{ class: "row-label" },
        });
        /** @type {__VLS_StyleScopedClasses['row-label']} */ ;
        (rowName);
        for (const [seat] of __VLS_vFor((rowSeats))) {
            __VLS_asFunctionalElement1(__VLS_intrinsics.button, __VLS_intrinsics.button)({
                ...{ onClick: (...[$event]) => {
                        if (!!(__VLS_ctx.loading))
                            throw 0;
                        if (!!(__VLS_ctx.error))
                            throw 0;
                        if (!(__VLS_ctx.movie && __VLS_ctx.schedule))
                            throw 0;
                        return (__VLS_ctx.toggleSeat(seat));
                        // @ts-ignore
                        [schedule, schedule, rows, toggleSeat,];
                    } },
                key: (seat.id),
                type: "button",
                ...{ class: "seat" },
                ...{ class: ([seat.status.toLowerCase(), { selected: __VLS_ctx.selectedIds.includes(seat.id) }]) },
                disabled: (seat.status !== 'AVAILABLE'),
                'aria-label': (`${seat.seatCode} ${seat.status}`),
                'data-testid': (`seat-${seat.id}`),
            });
            /** @type {__VLS_StyleScopedClasses['seat']} */ ;
            /** @type {__VLS_StyleScopedClasses['selected']} */ ;
            (seat.seatNumber);
            // @ts-ignore
            [selectedIds,];
        }
        __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({
            ...{ class: "row-label" },
        });
        /** @type {__VLS_StyleScopedClasses['row-label']} */ ;
        (rowName);
        // @ts-ignore
        [];
    }
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
        ...{ class: "seat-legend" },
    });
    /** @type {__VLS_StyleScopedClasses['seat-legend']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.i, __VLS_intrinsics.i)({
        ...{ class: "seat available" },
    });
    /** @type {__VLS_StyleScopedClasses['seat']} */ ;
    /** @type {__VLS_StyleScopedClasses['available']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.i, __VLS_intrinsics.i)({
        ...{ class: "seat selected" },
    });
    /** @type {__VLS_StyleScopedClasses['seat']} */ ;
    /** @type {__VLS_StyleScopedClasses['selected']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.i, __VLS_intrinsics.i)({
        ...{ class: "seat locked" },
    });
    /** @type {__VLS_StyleScopedClasses['seat']} */ ;
    /** @type {__VLS_StyleScopedClasses['locked']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.i, __VLS_intrinsics.i)({
        ...{ class: "seat sold" },
    });
    /** @type {__VLS_StyleScopedClasses['seat']} */ ;
    /** @type {__VLS_StyleScopedClasses['sold']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.aside, __VLS_intrinsics.aside)({
        ...{ class: "booking-summary" },
        'data-testid': "booking-summary",
    });
    /** @type {__VLS_StyleScopedClasses['booking-summary']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({
        ...{ class: "eyebrow" },
    });
    /** @type {__VLS_StyleScopedClasses['eyebrow']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.h2, __VLS_intrinsics.h2)({});
    (__VLS_ctx.movie.name);
    __VLS_asFunctionalElement1(__VLS_intrinsics.dl, __VLS_intrinsics.dl)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.dt, __VLS_intrinsics.dt)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.dd, __VLS_intrinsics.dd)({});
    (__VLS_ctx.schedule.cinemaName);
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.dt, __VLS_intrinsics.dt)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.dd, __VLS_intrinsics.dd)({});
    (__VLS_ctx.schedule.hallName);
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.dt, __VLS_intrinsics.dt)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.dd, __VLS_intrinsics.dd)({});
    (new Date(__VLS_ctx.schedule.startTime).toLocaleString("zh-CN"));
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
        ...{ class: "selected-seat-list" },
    });
    /** @type {__VLS_StyleScopedClasses['selected-seat-list']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({});
    for (const [seat] of __VLS_vFor((__VLS_ctx.selectedSeats))) {
        __VLS_asFunctionalElement1(__VLS_intrinsics.b, __VLS_intrinsics.b)({
            key: (seat.id),
        });
        (seat.seatCode);
        // @ts-ignore
        [movie, schedule, schedule, schedule, selectedSeats,];
    }
    if (!__VLS_ctx.selectedSeats.length) {
        __VLS_asFunctionalElement1(__VLS_intrinsics.em, __VLS_intrinsics.em)({});
    }
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
        ...{ class: "price-total" },
    });
    /** @type {__VLS_StyleScopedClasses['price-total']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.strong, __VLS_intrinsics.strong)({});
    (__VLS_ctx.total.toFixed(2));
    if (__VLS_ctx.actionError) {
        __VLS_asFunctionalElement1(__VLS_intrinsics.p, __VLS_intrinsics.p)({
            ...{ class: "inline-alert error" },
            role: "alert",
            'data-testid': "seat-error",
        });
        /** @type {__VLS_StyleScopedClasses['inline-alert']} */ ;
        /** @type {__VLS_StyleScopedClasses['error']} */ ;
        (__VLS_ctx.actionError);
    }
    __VLS_asFunctionalElement1(__VLS_intrinsics.button, __VLS_intrinsics.button)({
        ...{ onClick: (__VLS_ctx.lockAndContinue) },
        ...{ class: "button button-primary button-block" },
        'data-testid': "lock-seats-submit",
        disabled: (__VLS_ctx.submitting || !__VLS_ctx.selectedIds.length),
    });
    /** @type {__VLS_StyleScopedClasses['button']} */ ;
    /** @type {__VLS_StyleScopedClasses['button-primary']} */ ;
    /** @type {__VLS_StyleScopedClasses['button-block']} */ ;
    (__VLS_ctx.submitting ? "正在锁定…" : "锁定座位并继续");
    __VLS_asFunctionalElement1(__VLS_intrinsics.small, __VLS_intrinsics.small)({
        ...{ class: "summary-tip" },
    });
    /** @type {__VLS_StyleScopedClasses['summary-tip']} */ ;
}
// @ts-ignore
[selectedIds, selectedSeats, total, actionError, actionError, lockAndContinue, submitting, submitting,];
const __VLS_export = (await import('vue')).defineComponent({});
export default {};
