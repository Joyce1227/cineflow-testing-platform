import { computed, onMounted, ref } from "vue";
import { useRoute, useRouter } from "vue-router";
import { movieApi, reviewApi } from "../api";
import { errorMessage } from "../api/http";
import EmptyState from "../components/EmptyState.vue";
import ErrorState from "../components/ErrorState.vue";
import LoadingState from "../components/LoadingState.vue";
import { useAuthStore } from "../stores/auth";
const route = useRoute();
const router = useRouter();
const auth = useAuthStore();
const movieId = computed(() => Number(route.params.id));
const movie = ref(null);
const schedules = ref([]);
const reviews = ref([]);
const loading = ref(true);
const error = ref("");
function formatTime(value) {
    return new Intl.DateTimeFormat("zh-CN", { month: "2-digit", day: "2-digit", hour: "2-digit", minute: "2-digit", hour12: false }).format(new Date(value));
}
async function load() {
    loading.value = true;
    error.value = "";
    try {
        const [detail, shows, reviewResult] = await Promise.all([
            movieApi.detail(movieId.value), movieApi.schedules(movieId.value), reviewApi.list(movieId.value)
        ]);
        movie.value = detail.data.data;
        schedules.value = shows.data.data;
        reviews.value = reviewResult.data.data.list;
    }
    catch (e) {
        error.value = errorMessage(e);
    }
    finally {
        loading.value = false;
    }
}
function chooseSchedule(schedule) {
    if (!auth.isLoggedIn) {
        router.push({ name: "login", query: { redirect: `/movies/${movieId.value}/schedules/${schedule.id}/seats` } });
    }
    else {
        router.push(`/movies/${movieId.value}/schedules/${schedule.id}/seats`);
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
    'data-testid': "movie-detail-page",
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
else if (__VLS_ctx.movie) {
    __VLS_asFunctionalElement1(__VLS_intrinsics.section, __VLS_intrinsics.section)({
        ...{ class: "movie-hero-detail" },
    });
    /** @type {__VLS_StyleScopedClasses['movie-hero-detail']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
        ...{ class: "detail-poster" },
    });
    /** @type {__VLS_StyleScopedClasses['detail-poster']} */ ;
    if (__VLS_ctx.movie.cover) {
        __VLS_asFunctionalElement1(__VLS_intrinsics.img)({
            src: (__VLS_ctx.movie.cover),
            alt: (__VLS_ctx.movie.name),
        });
    }
    else {
        __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
            ...{ class: "poster-fallback detail-fallback" },
        });
        /** @type {__VLS_StyleScopedClasses['poster-fallback']} */ ;
        /** @type {__VLS_StyleScopedClasses['detail-fallback']} */ ;
        __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
        (__VLS_ctx.movie.name);
        __VLS_asFunctionalElement1(__VLS_intrinsics.small, __VLS_intrinsics.small)({});
    }
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
        ...{ class: "detail-copy" },
    });
    /** @type {__VLS_StyleScopedClasses['detail-copy']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({
        ...{ class: "eyebrow" },
    });
    /** @type {__VLS_StyleScopedClasses['eyebrow']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.h1, __VLS_intrinsics.h1)({
        'data-testid': "movie-name",
    });
    (__VLS_ctx.movie.name);
    __VLS_asFunctionalElement1(__VLS_intrinsics.p, __VLS_intrinsics.p)({
        ...{ class: "movie-meta" },
    });
    /** @type {__VLS_StyleScopedClasses['movie-meta']} */ ;
    (__VLS_ctx.movie.releaseYear || "年份待定");
    (__VLS_ctx.movie.regions || "地区待定");
    (__VLS_ctx.movie.mins ? `${__VLS_ctx.movie.mins}分钟` : "片长待定");
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
        ...{ class: "detail-score" },
    });
    /** @type {__VLS_StyleScopedClasses['detail-score']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.strong, __VLS_intrinsics.strong)({});
    (Number(__VLS_ctx.movie.score || 0).toFixed(1));
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.br)({});
    (__VLS_ctx.movie.ratingCount || 0);
    __VLS_asFunctionalElement1(__VLS_intrinsics.p, __VLS_intrinsics.p)({
        ...{ class: "tags" },
    });
    /** @type {__VLS_StyleScopedClasses['tags']} */ ;
    for (const [item] of __VLS_vFor(((__VLS_ctx.movie.genres || '').split('/').filter(Boolean)))) {
        __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({
            key: (item),
        });
        (item);
        // @ts-ignore
        [loading, error, error, load, movie, movie, movie, movie, movie, movie, movie, movie, movie, movie, movie, movie, movie,];
    }
    __VLS_asFunctionalElement1(__VLS_intrinsics.dl, __VLS_intrinsics.dl)({
        ...{ class: "movie-facts" },
    });
    /** @type {__VLS_StyleScopedClasses['movie-facts']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.dt, __VLS_intrinsics.dt)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.dd, __VLS_intrinsics.dd)({});
    (__VLS_ctx.movie.directors || "暂无资料");
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.dt, __VLS_intrinsics.dt)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.dd, __VLS_intrinsics.dd)({});
    (__VLS_ctx.movie.actors || "暂无资料");
    __VLS_asFunctionalElement1(__VLS_intrinsics.p, __VLS_intrinsics.p)({
        ...{ class: "storyline" },
    });
    /** @type {__VLS_StyleScopedClasses['storyline']} */ ;
    (__VLS_ctx.movie.storyline || "影片简介正在整理中，敬请期待。");
    __VLS_asFunctionalElement1(__VLS_intrinsics.section, __VLS_intrinsics.section)({
        ...{ class: "content-section" },
    });
    /** @type {__VLS_StyleScopedClasses['content-section']} */ ;
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
    if (!__VLS_ctx.schedules.length) {
        const __VLS_12 = EmptyState;
        // @ts-ignore
        const __VLS_13 = __VLS_asFunctionalComponent1(__VLS_12, new __VLS_12({
            title: "暂无可售场次",
            description: "请稍后再来看看",
        }));
        const __VLS_14 = __VLS_13({
            title: "暂无可售场次",
            description: "请稍后再来看看",
        }, ...__VLS_functionalComponentArgsRest(__VLS_13));
    }
    else {
        __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
            ...{ class: "schedule-list" },
            'data-testid': "schedule-list",
        });
        /** @type {__VLS_StyleScopedClasses['schedule-list']} */ ;
        for (const [schedule] of __VLS_vFor((__VLS_ctx.schedules))) {
            __VLS_asFunctionalElement1(__VLS_intrinsics.article, __VLS_intrinsics.article)({
                key: (schedule.id),
                ...{ class: "schedule-item" },
                'data-testid': (`schedule-${schedule.id}`),
            });
            /** @type {__VLS_StyleScopedClasses['schedule-item']} */ ;
            __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({});
            __VLS_asFunctionalElement1(__VLS_intrinsics.strong, __VLS_intrinsics.strong)({});
            (__VLS_ctx.formatTime(schedule.startTime));
            __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
            (__VLS_ctx.formatTime(schedule.endTime));
            __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({});
            __VLS_asFunctionalElement1(__VLS_intrinsics.strong, __VLS_intrinsics.strong)({});
            (schedule.cinemaName);
            __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
            (schedule.hallName);
            __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
                ...{ class: "schedule-price" },
            });
            /** @type {__VLS_StyleScopedClasses['schedule-price']} */ ;
            (Number(schedule.price).toFixed(2));
            __VLS_asFunctionalElement1(__VLS_intrinsics.button, __VLS_intrinsics.button)({
                ...{ onClick: (...[$event]) => {
                        if (!!(__VLS_ctx.loading))
                            throw 0;
                        if (!!(__VLS_ctx.error))
                            throw 0;
                        if (!(__VLS_ctx.movie))
                            throw 0;
                        if (!!(!__VLS_ctx.schedules.length))
                            throw 0;
                        return (__VLS_ctx.chooseSchedule(schedule));
                        // @ts-ignore
                        [movie, movie, movie, schedules, schedules, formatTime, formatTime, chooseSchedule,];
                    } },
                ...{ class: "button button-primary" },
                'data-testid': (`choose-schedule-${schedule.id}`),
            });
            /** @type {__VLS_StyleScopedClasses['button']} */ ;
            /** @type {__VLS_StyleScopedClasses['button-primary']} */ ;
            // @ts-ignore
            [];
        }
    }
    __VLS_asFunctionalElement1(__VLS_intrinsics.section, __VLS_intrinsics.section)({
        ...{ class: "content-section" },
    });
    /** @type {__VLS_StyleScopedClasses['content-section']} */ ;
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
    if (!__VLS_ctx.reviews.length) {
        const __VLS_17 = EmptyState;
        // @ts-ignore
        const __VLS_18 = __VLS_asFunctionalComponent1(__VLS_17, new __VLS_17({
            title: "还没有评价",
            description: "购买并观看后，来分享你的感受吧",
        }));
        const __VLS_19 = __VLS_18({
            title: "还没有评价",
            description: "购买并观看后，来分享你的感受吧",
        }, ...__VLS_functionalComponentArgsRest(__VLS_18));
    }
    else {
        __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
            ...{ class: "review-list" },
            'data-testid': "review-list",
        });
        /** @type {__VLS_StyleScopedClasses['review-list']} */ ;
        for (const [review] of __VLS_vFor((__VLS_ctx.reviews))) {
            __VLS_asFunctionalElement1(__VLS_intrinsics.article, __VLS_intrinsics.article)({
                key: (review.id),
                ...{ class: "review-card" },
            });
            /** @type {__VLS_StyleScopedClasses['review-card']} */ ;
            __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
                ...{ class: "review-head" },
            });
            /** @type {__VLS_StyleScopedClasses['review-head']} */ ;
            __VLS_asFunctionalElement1(__VLS_intrinsics.strong, __VLS_intrinsics.strong)({});
            (review.username);
            __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
            (review.rating.toFixed(1));
            __VLS_asFunctionalElement1(__VLS_intrinsics.p, __VLS_intrinsics.p)({});
            (review.content);
            __VLS_asFunctionalElement1(__VLS_intrinsics.time, __VLS_intrinsics.time)({});
            (new Date(review.createdAt).toLocaleString("zh-CN"));
            // @ts-ignore
            [reviews, reviews,];
        }
    }
}
// @ts-ignore
[];
const __VLS_export = (await import('vue')).defineComponent({});
export default {};
