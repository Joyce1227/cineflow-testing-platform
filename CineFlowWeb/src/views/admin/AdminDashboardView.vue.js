import { onMounted, ref } from "vue";
import { adminApi, movieApi, statApi } from "../../api";
import { errorMessage } from "../../api/http";
import LoadingState from "../../components/LoadingState.vue";
const loading = ref(true);
const error = ref("");
const health = ref("UNKNOWN");
const movieTotal = ref(0);
const cinemaTotal = ref(0);
const highScoreAverage = ref(0);
const mins = ref({ totalMins: 0, averageMins: 0, minMins: 0, maxMins: 0 });
const actors = ref([]);
const recentMovies = ref([]);
async function load() {
    loading.value = true;
    error.value = "";
    try {
        const [healthResult, movieResult, cinemaResult, scoreResult, minsResult, actorResult] = await Promise.all([
            adminApi.health(), movieApi.list({ pageNum: 1, pageSize: 6 }), movieApi.cinemas(),
            statApi.highScore(), statApi.mins(), statApi.actors()
        ]);
        health.value = healthResult.data.data.status;
        movieTotal.value = movieResult.data.data.total;
        recentMovies.value = movieResult.data.data.list;
        cinemaTotal.value = cinemaResult.data.data.length;
        highScoreAverage.value = Number(scoreResult.data.data.averageScore || 0);
        mins.value = minsResult.data.data;
        actors.value = actorResult.data.data.slice(0, 6);
    }
    catch (e) {
        error.value = errorMessage(e);
    }
    finally {
        loading.value = false;
    }
}
function barWidth(count) {
    const max = Math.max(...actors.value.map(item => item.actedMovieCnt), 1);
    return `${Math.max((count / max) * 100, 4)}%`;
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
    'data-testid': "admin-dashboard-page",
});
__VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
    ...{ class: "admin-page-heading" },
});
/** @type {__VLS_StyleScopedClasses['admin-page-heading']} */ ;
__VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({});
__VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({
    ...{ class: "eyebrow" },
});
/** @type {__VLS_StyleScopedClasses['eyebrow']} */ ;
__VLS_asFunctionalElement1(__VLS_intrinsics.h1, __VLS_intrinsics.h1)({});
__VLS_asFunctionalElement1(__VLS_intrinsics.p, __VLS_intrinsics.p)({});
__VLS_asFunctionalElement1(__VLS_intrinsics.button, __VLS_intrinsics.button)({
    ...{ onClick: (__VLS_ctx.load) },
    ...{ class: "button button-secondary" },
    'data-testid': "dashboard-refresh",
    disabled: (__VLS_ctx.loading),
});
/** @type {__VLS_StyleScopedClasses['button']} */ ;
/** @type {__VLS_StyleScopedClasses['button-secondary']} */ ;
if (__VLS_ctx.loading) {
    const __VLS_0 = LoadingState;
    // @ts-ignore
    const __VLS_1 = __VLS_asFunctionalComponent1(__VLS_0, new __VLS_0({}));
    const __VLS_2 = __VLS_1({}, ...__VLS_functionalComponentArgsRest(__VLS_1));
}
else {
    if (__VLS_ctx.error) {
        __VLS_asFunctionalElement1(__VLS_intrinsics.p, __VLS_intrinsics.p)({
            ...{ class: "inline-alert error" },
            role: "alert",
            'data-testid': "dashboard-error",
        });
        /** @type {__VLS_StyleScopedClasses['inline-alert']} */ ;
        /** @type {__VLS_StyleScopedClasses['error']} */ ;
        (__VLS_ctx.error);
    }
    __VLS_asFunctionalElement1(__VLS_intrinsics.section, __VLS_intrinsics.section)({
        ...{ class: "metric-grid" },
    });
    /** @type {__VLS_StyleScopedClasses['metric-grid']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.article, __VLS_intrinsics.article)({
        ...{ class: "metric-card" },
        'data-testid': "metric-health",
    });
    /** @type {__VLS_StyleScopedClasses['metric-card']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.strong, __VLS_intrinsics.strong)({
        ...{ class: ({ online: __VLS_ctx.health === 'UP' }) },
    });
    /** @type {__VLS_StyleScopedClasses['online']} */ ;
    (__VLS_ctx.health === 'UP' ? '运行正常' : '状态异常');
    __VLS_asFunctionalElement1(__VLS_intrinsics.small, __VLS_intrinsics.small)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.i, __VLS_intrinsics.i)({
        ...{ class: "system-dot" },
    });
    /** @type {__VLS_StyleScopedClasses['system-dot']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.article, __VLS_intrinsics.article)({
        ...{ class: "metric-card" },
        'data-testid': "metric-movies",
    });
    /** @type {__VLS_StyleScopedClasses['metric-card']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.strong, __VLS_intrinsics.strong)({});
    (__VLS_ctx.movieTotal);
    __VLS_asFunctionalElement1(__VLS_intrinsics.small, __VLS_intrinsics.small)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.article, __VLS_intrinsics.article)({
        ...{ class: "metric-card" },
        'data-testid': "metric-cinemas",
    });
    /** @type {__VLS_StyleScopedClasses['metric-card']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.strong, __VLS_intrinsics.strong)({});
    (__VLS_ctx.cinemaTotal);
    __VLS_asFunctionalElement1(__VLS_intrinsics.small, __VLS_intrinsics.small)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.article, __VLS_intrinsics.article)({
        ...{ class: "metric-card" },
        'data-testid': "metric-score",
    });
    /** @type {__VLS_StyleScopedClasses['metric-card']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.strong, __VLS_intrinsics.strong)({});
    (__VLS_ctx.highScoreAverage.toFixed(2));
    __VLS_asFunctionalElement1(__VLS_intrinsics.small, __VLS_intrinsics.small)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.section, __VLS_intrinsics.section)({
        ...{ class: "admin-dashboard-grid" },
    });
    /** @type {__VLS_StyleScopedClasses['admin-dashboard-grid']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.article, __VLS_intrinsics.article)({
        ...{ class: "admin-panel" },
    });
    /** @type {__VLS_StyleScopedClasses['admin-panel']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
        ...{ class: "panel-heading" },
    });
    /** @type {__VLS_StyleScopedClasses['panel-heading']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.h2, __VLS_intrinsics.h2)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.p, __VLS_intrinsics.p)({});
    let __VLS_5;
    /** @ts-ignore @type { | typeof __VLS_components.RouterLink | typeof __VLS_components.RouterLink} */
    RouterLink;
    // @ts-ignore
    const __VLS_6 = __VLS_asFunctionalComponent1(__VLS_5, new __VLS_5({
        to: "/admin/movies",
    }));
    const __VLS_7 = __VLS_6({
        to: "/admin/movies",
    }, ...__VLS_functionalComponentArgsRest(__VLS_6));
    const { default: __VLS_10 } = __VLS_8.slots;
    // @ts-ignore
    [load, loading, loading, error, error, health, health, movieTotal, cinemaTotal, highScoreAverage,];
    var __VLS_8;
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
        ...{ class: "mini-metrics" },
    });
    /** @type {__VLS_StyleScopedClasses['mini-metrics']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.strong, __VLS_intrinsics.strong)({});
    (Number(__VLS_ctx.mins.averageMins).toFixed(0));
    __VLS_asFunctionalElement1(__VLS_intrinsics.small, __VLS_intrinsics.small)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.strong, __VLS_intrinsics.strong)({});
    (__VLS_ctx.mins.minMins);
    __VLS_asFunctionalElement1(__VLS_intrinsics.small, __VLS_intrinsics.small)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.strong, __VLS_intrinsics.strong)({});
    (__VLS_ctx.mins.maxMins);
    __VLS_asFunctionalElement1(__VLS_intrinsics.small, __VLS_intrinsics.small)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
        ...{ class: "admin-table-wrap" },
    });
    /** @type {__VLS_StyleScopedClasses['admin-table-wrap']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.table, __VLS_intrinsics.table)({
        ...{ class: "admin-table" },
        'data-testid': "dashboard-movie-table",
    });
    /** @type {__VLS_StyleScopedClasses['admin-table']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.thead, __VLS_intrinsics.thead)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.tr, __VLS_intrinsics.tr)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.th, __VLS_intrinsics.th)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.th, __VLS_intrinsics.th)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.th, __VLS_intrinsics.th)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.th, __VLS_intrinsics.th)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.th, __VLS_intrinsics.th)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.tbody, __VLS_intrinsics.tbody)({});
    for (const [movie] of __VLS_vFor((__VLS_ctx.recentMovies))) {
        __VLS_asFunctionalElement1(__VLS_intrinsics.tr, __VLS_intrinsics.tr)({
            key: (movie.id),
        });
        __VLS_asFunctionalElement1(__VLS_intrinsics.td, __VLS_intrinsics.td)({});
        __VLS_asFunctionalElement1(__VLS_intrinsics.strong, __VLS_intrinsics.strong)({});
        (movie.name);
        __VLS_asFunctionalElement1(__VLS_intrinsics.td, __VLS_intrinsics.td)({});
        (movie.genres || '-');
        __VLS_asFunctionalElement1(__VLS_intrinsics.td, __VLS_intrinsics.td)({});
        (movie.releaseYear || '-');
        __VLS_asFunctionalElement1(__VLS_intrinsics.td, __VLS_intrinsics.td)({});
        (Number(movie.score).toFixed(1));
        __VLS_asFunctionalElement1(__VLS_intrinsics.td, __VLS_intrinsics.td)({});
        __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({
            ...{ class: "table-status" },
            ...{ class: (movie.status.toLowerCase()) },
        });
        /** @type {__VLS_StyleScopedClasses['table-status']} */ ;
        (movie.status === 'AVAILABLE' ? '可售' : '下架');
        // @ts-ignore
        [mins, mins, mins, recentMovies,];
    }
    __VLS_asFunctionalElement1(__VLS_intrinsics.article, __VLS_intrinsics.article)({
        ...{ class: "admin-panel" },
    });
    /** @type {__VLS_StyleScopedClasses['admin-panel']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
        ...{ class: "panel-heading" },
    });
    /** @type {__VLS_StyleScopedClasses['panel-heading']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.h2, __VLS_intrinsics.h2)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.p, __VLS_intrinsics.p)({});
    if (__VLS_ctx.actors.length) {
        __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
            ...{ class: "bar-list" },
            'data-testid': "actor-stat-chart",
        });
        /** @type {__VLS_StyleScopedClasses['bar-list']} */ ;
        for (const [actor, index] of __VLS_vFor((__VLS_ctx.actors))) {
            __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
                key: (actor.personName),
                ...{ class: "bar-item" },
            });
            /** @type {__VLS_StyleScopedClasses['bar-item']} */ ;
            __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({
                ...{ class: "bar-rank" },
            });
            /** @type {__VLS_StyleScopedClasses['bar-rank']} */ ;
            (String(index + 1).padStart(2, '0'));
            __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({});
            __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
                ...{ class: "bar-label" },
            });
            /** @type {__VLS_StyleScopedClasses['bar-label']} */ ;
            __VLS_asFunctionalElement1(__VLS_intrinsics.strong, __VLS_intrinsics.strong)({});
            (actor.personName);
            __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
            (actor.actedMovieCnt);
            __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
                ...{ class: "bar-track" },
            });
            /** @type {__VLS_StyleScopedClasses['bar-track']} */ ;
            __VLS_asFunctionalElement1(__VLS_intrinsics.i, __VLS_intrinsics.i)({
                ...{ style: ({ width: __VLS_ctx.barWidth(actor.actedMovieCnt) }) },
            });
            // @ts-ignore
            [actors, actors, barWidth,];
        }
    }
    else {
        __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
            ...{ class: "admin-empty" },
        });
        /** @type {__VLS_StyleScopedClasses['admin-empty']} */ ;
    }
}
// @ts-ignore
[];
const __VLS_export = (await import('vue')).defineComponent({});
export default {};
