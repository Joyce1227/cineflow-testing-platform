import { onMounted, ref } from "vue";
import { recommendationApi } from "../api";
import { errorMessage } from "../api/http";
import ErrorState from "../components/ErrorState.vue";
import LoadingState from "../components/LoadingState.vue";
import MovieCard from "../components/MovieCard.vue";
import { useAuthStore } from "../stores/auth";
const auth = useAuthStore();
const movies = ref([]);
const loading = ref(true);
const error = ref("");
async function load() {
    loading.value = true;
    error.value = "";
    try {
        movies.value = auth.isLoggedIn
            ? (await recommendationApi.mine(8)).data.data
            : (await recommendationApi.hot(8)).data.data;
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
    'data-testid': "recommendations-page",
});
/** @type {__VLS_StyleScopedClasses['container']} */ ;
/** @type {__VLS_StyleScopedClasses['page-content']} */ ;
__VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
    ...{ class: "recommendation-banner" },
});
/** @type {__VLS_StyleScopedClasses['recommendation-banner']} */ ;
__VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({
    ...{ class: "eyebrow" },
});
/** @type {__VLS_StyleScopedClasses['eyebrow']} */ ;
__VLS_asFunctionalElement1(__VLS_intrinsics.h1, __VLS_intrinsics.h1)({});
(__VLS_ctx.auth.isLoggedIn ? `为 ${__VLS_ctx.auth.user?.username} 精选` : '发现热门佳片');
__VLS_asFunctionalElement1(__VLS_intrinsics.p, __VLS_intrinsics.p)({});
(__VLS_ctx.auth.isLoggedIn ? '根据你的评分偏好与热门趋势，为你推荐下一部电影。' : '登录并评价电影后，即可获得更贴合你的个性化推荐。');
if (!__VLS_ctx.auth.isLoggedIn) {
    let __VLS_0;
    /** @ts-ignore @type { | typeof __VLS_components.RouterLink | typeof __VLS_components.RouterLink} */
    RouterLink;
    // @ts-ignore
    const __VLS_1 = __VLS_asFunctionalComponent1(__VLS_0, new __VLS_0({
        to: "/login",
        ...{ class: "button button-primary" },
    }));
    const __VLS_2 = __VLS_1({
        to: "/login",
        ...{ class: "button button-primary" },
    }, ...__VLS_functionalComponentArgsRest(__VLS_1));
    /** @type {__VLS_StyleScopedClasses['button']} */ ;
    /** @type {__VLS_StyleScopedClasses['button-primary']} */ ;
    const { default: __VLS_5 } = __VLS_3.slots;
    // @ts-ignore
    [auth, auth, auth, auth,];
    var __VLS_3;
}
if (__VLS_ctx.loading) {
    const __VLS_6 = LoadingState;
    // @ts-ignore
    const __VLS_7 = __VLS_asFunctionalComponent1(__VLS_6, new __VLS_6({}));
    const __VLS_8 = __VLS_7({}, ...__VLS_functionalComponentArgsRest(__VLS_7));
}
else if (__VLS_ctx.error) {
    const __VLS_11 = ErrorState;
    // @ts-ignore
    const __VLS_12 = __VLS_asFunctionalComponent1(__VLS_11, new __VLS_11({
        ...{ 'onRetry': {} },
        message: (__VLS_ctx.error),
    }));
    const __VLS_13 = __VLS_12({
        ...{ 'onRetry': {} },
        message: (__VLS_ctx.error),
    }, ...__VLS_functionalComponentArgsRest(__VLS_12));
    let __VLS_16;
    const __VLS_17 = {
        /** @type {typeof __VLS_16.retry} */
        onRetry: (__VLS_ctx.load),
    };
    var __VLS_14;
    var __VLS_15;
}
else {
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
        ...{ class: "movie-grid" },
        'data-testid': "recommendation-list",
    });
    /** @type {__VLS_StyleScopedClasses['movie-grid']} */ ;
    for (const [movie, index] of __VLS_vFor((__VLS_ctx.movies))) {
        const __VLS_18 = MovieCard;
        // @ts-ignore
        const __VLS_19 = __VLS_asFunctionalComponent1(__VLS_18, new __VLS_18({
            key: (movie.id),
            movie: (movie),
            index: (index),
        }));
        const __VLS_20 = __VLS_19({
            key: (movie.id),
            movie: (movie),
            index: (index),
        }, ...__VLS_functionalComponentArgsRest(__VLS_19));
        // @ts-ignore
        [loading, error, error, load, movies,];
    }
}
// @ts-ignore
[];
const __VLS_export = (await import('vue')).defineComponent({});
export default {};
