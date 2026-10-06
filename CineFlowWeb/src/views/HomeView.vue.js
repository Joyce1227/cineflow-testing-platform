import { onMounted, reactive, ref } from "vue";
import { movieApi } from "../api";
import { errorMessage } from "../api/http";
import EmptyState from "../components/EmptyState.vue";
import ErrorState from "../components/ErrorState.vue";
import LoadingState from "../components/LoadingState.vue";
import MovieCard from "../components/MovieCard.vue";
const hotMovies = ref([]);
const movies = ref({ list: [], pageNum: 1, pageSize: 8, total: 0, totalPages: 0 });
const loading = ref(true);
const listLoading = ref(false);
const error = ref("");
const filters = reactive({ genre: "", region: "", year: "", minScore: "" });
async function loadHome() {
    loading.value = true;
    error.value = "";
    try {
        const [hot, all] = await Promise.all([movieApi.hot(4), movieApi.list({ pageNum: 1, pageSize: 8 })]);
        hotMovies.value = hot.data.data;
        movies.value = all.data.data;
    }
    catch (e) {
        error.value = errorMessage(e);
    }
    finally {
        loading.value = false;
    }
}
async function search(pageNum = 1) {
    listLoading.value = true;
    error.value = "";
    try {
        const result = await movieApi.list({
            genre: filters.genre || undefined,
            region: filters.region || undefined,
            year: filters.year ? Number(filters.year) : undefined,
            minScore: filters.minScore ? Number(filters.minScore) : undefined,
            pageNum, pageSize: 8
        });
        movies.value = result.data.data;
    }
    catch (e) {
        error.value = errorMessage(e);
    }
    finally {
        listLoading.value = false;
    }
}
function reset() {
    Object.assign(filters, { genre: "", region: "", year: "", minScore: "" });
    search(1);
}
onMounted(loadHome);
const __VLS_ctx = {
    ...{},
    ...{},
};
let __VLS_components;
let __VLS_intrinsics;
let __VLS_directives;
__VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
    'data-testid': "home-page",
});
__VLS_asFunctionalElement1(__VLS_intrinsics.section, __VLS_intrinsics.section)({
    ...{ class: "hero" },
});
/** @type {__VLS_StyleScopedClasses['hero']} */ ;
__VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
    ...{ class: "container hero-inner" },
});
/** @type {__VLS_StyleScopedClasses['container']} */ ;
/** @type {__VLS_StyleScopedClasses['hero-inner']} */ ;
__VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
    ...{ class: "hero-copy" },
});
/** @type {__VLS_StyleScopedClasses['hero-copy']} */ ;
__VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({
    ...{ class: "eyebrow" },
});
/** @type {__VLS_StyleScopedClasses['eyebrow']} */ ;
__VLS_asFunctionalElement1(__VLS_intrinsics.h1, __VLS_intrinsics.h1)({});
__VLS_asFunctionalElement1(__VLS_intrinsics.br)({});
__VLS_asFunctionalElement1(__VLS_intrinsics.em, __VLS_intrinsics.em)({});
__VLS_asFunctionalElement1(__VLS_intrinsics.p, __VLS_intrinsics.p)({});
__VLS_asFunctionalElement1(__VLS_intrinsics.a, __VLS_intrinsics.a)({
    href: "#all-movies",
    ...{ class: "button button-primary" },
    'data-testid': "hero-browse-button",
});
/** @type {__VLS_StyleScopedClasses['button']} */ ;
/** @type {__VLS_StyleScopedClasses['button-primary']} */ ;
__VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
    ...{ class: "hero-art" },
    'aria-hidden': "true",
});
/** @type {__VLS_StyleScopedClasses['hero-art']} */ ;
__VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
    ...{ class: "orb orb-one" },
});
/** @type {__VLS_StyleScopedClasses['orb']} */ ;
/** @type {__VLS_StyleScopedClasses['orb-one']} */ ;
__VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
    ...{ class: "orb orb-two" },
});
/** @type {__VLS_StyleScopedClasses['orb']} */ ;
/** @type {__VLS_StyleScopedClasses['orb-two']} */ ;
__VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
    ...{ class: "ticket-art" },
});
/** @type {__VLS_StyleScopedClasses['ticket-art']} */ ;
__VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
__VLS_asFunctionalElement1(__VLS_intrinsics.strong, __VLS_intrinsics.strong)({});
__VLS_asFunctionalElement1(__VLS_intrinsics.small, __VLS_intrinsics.small)({});
__VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
    ...{ class: "container page-content" },
});
/** @type {__VLS_StyleScopedClasses['container']} */ ;
/** @type {__VLS_StyleScopedClasses['page-content']} */ ;
if (__VLS_ctx.loading) {
    const __VLS_0 = LoadingState;
    // @ts-ignore
    const __VLS_1 = __VLS_asFunctionalComponent1(__VLS_0, new __VLS_0({}));
    const __VLS_2 = __VLS_1({}, ...__VLS_functionalComponentArgsRest(__VLS_1));
}
else if (__VLS_ctx.error && !__VLS_ctx.movies.list.length) {
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
        onRetry: (__VLS_ctx.loadHome),
    };
    var __VLS_8;
    var __VLS_9;
}
else {
    __VLS_asFunctionalElement1(__VLS_intrinsics.section, __VLS_intrinsics.section)({
        ...{ class: "content-section" },
        'data-testid': "hot-movies-section",
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
    let __VLS_12;
    /** @ts-ignore @type { | typeof __VLS_components.RouterLink | typeof __VLS_components.RouterLink} */
    RouterLink;
    // @ts-ignore
    const __VLS_13 = __VLS_asFunctionalComponent1(__VLS_12, new __VLS_12({
        to: "/recommendations",
    }));
    const __VLS_14 = __VLS_13({
        to: "/recommendations",
    }, ...__VLS_functionalComponentArgsRest(__VLS_13));
    const { default: __VLS_17 } = __VLS_15.slots;
    // @ts-ignore
    [loading, error, error, movies, loadHome,];
    var __VLS_15;
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
        ...{ class: "movie-grid movie-grid-featured" },
    });
    /** @type {__VLS_StyleScopedClasses['movie-grid']} */ ;
    /** @type {__VLS_StyleScopedClasses['movie-grid-featured']} */ ;
    for (const [movie, index] of __VLS_vFor((__VLS_ctx.hotMovies))) {
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
        [hotMovies,];
    }
    __VLS_asFunctionalElement1(__VLS_intrinsics.section, __VLS_intrinsics.section)({
        id: "all-movies",
        ...{ class: "content-section" },
        'data-testid': "all-movies-section",
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
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({
        ...{ class: "result-count" },
    });
    /** @type {__VLS_StyleScopedClasses['result-count']} */ ;
    (__VLS_ctx.movies.total);
    __VLS_asFunctionalElement1(__VLS_intrinsics.form, __VLS_intrinsics.form)({
        ...{ onSubmit: (...[$event]) => {
                if (!!(__VLS_ctx.loading))
                    throw 0;
                if (!!(__VLS_ctx.error && !__VLS_ctx.movies.list.length))
                    throw 0;
                return (__VLS_ctx.search(1));
                // @ts-ignore
                [movies, search,];
            } },
        ...{ class: "filter-bar" },
        'data-testid': "movie-filter-form",
    });
    /** @type {__VLS_StyleScopedClasses['filter-bar']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.label, __VLS_intrinsics.label)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.input)({
        'data-testid': "filter-genre",
        placeholder: "如：科幻",
    });
    (__VLS_ctx.filters.genre);
    __VLS_asFunctionalElement1(__VLS_intrinsics.label, __VLS_intrinsics.label)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.input)({
        'data-testid': "filter-region",
        placeholder: "如：中国大陆",
    });
    (__VLS_ctx.filters.region);
    __VLS_asFunctionalElement1(__VLS_intrinsics.label, __VLS_intrinsics.label)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.input)({
        'data-testid': "filter-year",
        type: "number",
        min: "1888",
        max: "2200",
        placeholder: "2024",
    });
    (__VLS_ctx.filters.year);
    __VLS_asFunctionalElement1(__VLS_intrinsics.label, __VLS_intrinsics.label)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.input)({
        'data-testid': "filter-min-score",
        type: "number",
        min: "0",
        max: "10",
        step: "0.1",
        placeholder: "8.0",
    });
    (__VLS_ctx.filters.minScore);
    __VLS_asFunctionalElement1(__VLS_intrinsics.button, __VLS_intrinsics.button)({
        ...{ class: "button button-primary" },
        'data-testid': "filter-submit",
        disabled: (__VLS_ctx.listLoading),
    });
    /** @type {__VLS_StyleScopedClasses['button']} */ ;
    /** @type {__VLS_StyleScopedClasses['button-primary']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.button, __VLS_intrinsics.button)({
        ...{ onClick: (__VLS_ctx.reset) },
        type: "button",
        ...{ class: "button button-ghost" },
        'data-testid': "filter-reset",
    });
    /** @type {__VLS_StyleScopedClasses['button']} */ ;
    /** @type {__VLS_StyleScopedClasses['button-ghost']} */ ;
    if (__VLS_ctx.error) {
        __VLS_asFunctionalElement1(__VLS_intrinsics.p, __VLS_intrinsics.p)({
            ...{ class: "inline-alert error" },
            role: "alert",
            'data-testid': "movie-list-error",
        });
        /** @type {__VLS_StyleScopedClasses['inline-alert']} */ ;
        /** @type {__VLS_StyleScopedClasses['error']} */ ;
        (__VLS_ctx.error);
    }
    if (__VLS_ctx.listLoading) {
        const __VLS_23 = LoadingState;
        // @ts-ignore
        const __VLS_24 = __VLS_asFunctionalComponent1(__VLS_23, new __VLS_23({}));
        const __VLS_25 = __VLS_24({}, ...__VLS_functionalComponentArgsRest(__VLS_24));
    }
    else if (!__VLS_ctx.movies.list.length) {
        const __VLS_28 = EmptyState;
        // @ts-ignore
        const __VLS_29 = __VLS_asFunctionalComponent1(__VLS_28, new __VLS_28({
            title: "没有找到电影",
            description: "请尝试调整筛选条件",
        }));
        const __VLS_30 = __VLS_29({
            title: "没有找到电影",
            description: "请尝试调整筛选条件",
        }, ...__VLS_functionalComponentArgsRest(__VLS_29));
    }
    else {
        __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
            ...{ class: "movie-grid" },
        });
        /** @type {__VLS_StyleScopedClasses['movie-grid']} */ ;
        for (const [movie, index] of __VLS_vFor((__VLS_ctx.movies.list))) {
            const __VLS_33 = MovieCard;
            // @ts-ignore
            const __VLS_34 = __VLS_asFunctionalComponent1(__VLS_33, new __VLS_33({
                key: (movie.id),
                movie: (movie),
                index: (index),
            }));
            const __VLS_35 = __VLS_34({
                key: (movie.id),
                movie: (movie),
                index: (index),
            }, ...__VLS_functionalComponentArgsRest(__VLS_34));
            // @ts-ignore
            [error, error, movies, movies, filters, filters, filters, filters, listLoading, listLoading, reset,];
        }
    }
    if (__VLS_ctx.movies.totalPages > 1) {
        __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
            ...{ class: "pagination" },
            'data-testid': "pagination",
        });
        /** @type {__VLS_StyleScopedClasses['pagination']} */ ;
        __VLS_asFunctionalElement1(__VLS_intrinsics.button, __VLS_intrinsics.button)({
            ...{ onClick: (...[$event]) => {
                    if (!!(__VLS_ctx.loading))
                        throw 0;
                    if (!!(__VLS_ctx.error && !__VLS_ctx.movies.list.length))
                        throw 0;
                    if (!(__VLS_ctx.movies.totalPages > 1))
                        throw 0;
                    return (__VLS_ctx.search(__VLS_ctx.movies.pageNum - 1));
                    // @ts-ignore
                    [movies, movies, search,];
                } },
            ...{ class: "button button-ghost" },
            'data-testid': "previous-page",
            disabled: (__VLS_ctx.movies.pageNum <= 1),
        });
        /** @type {__VLS_StyleScopedClasses['button']} */ ;
        /** @type {__VLS_StyleScopedClasses['button-ghost']} */ ;
        __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
        (__VLS_ctx.movies.pageNum);
        (__VLS_ctx.movies.totalPages);
        __VLS_asFunctionalElement1(__VLS_intrinsics.button, __VLS_intrinsics.button)({
            ...{ onClick: (...[$event]) => {
                    if (!!(__VLS_ctx.loading))
                        throw 0;
                    if (!!(__VLS_ctx.error && !__VLS_ctx.movies.list.length))
                        throw 0;
                    if (!(__VLS_ctx.movies.totalPages > 1))
                        throw 0;
                    return (__VLS_ctx.search(__VLS_ctx.movies.pageNum + 1));
                    // @ts-ignore
                    [movies, movies, movies, movies, search,];
                } },
            ...{ class: "button button-ghost" },
            'data-testid': "next-page",
            disabled: (__VLS_ctx.movies.pageNum >= __VLS_ctx.movies.totalPages),
        });
        /** @type {__VLS_StyleScopedClasses['button']} */ ;
        /** @type {__VLS_StyleScopedClasses['button-ghost']} */ ;
    }
}
// @ts-ignore
[movies, movies,];
const __VLS_export = (await import('vue')).defineComponent({});
export default {};
