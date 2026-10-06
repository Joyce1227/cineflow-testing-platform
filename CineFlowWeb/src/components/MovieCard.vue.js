const __VLS_props = defineProps();
const gradients = [
    "linear-gradient(145deg,#172033,#e9b762)",
    "linear-gradient(145deg,#1d3440,#58a6a6)",
    "linear-gradient(145deg,#43242a,#d56f65)",
    "linear-gradient(145deg,#23213a,#8d78ca)"
];
const __VLS_ctx = {
    ...{},
    ...{},
    ...{},
    ...{},
};
let __VLS_components;
let __VLS_intrinsics;
let __VLS_directives;
__VLS_asFunctionalElement1(__VLS_intrinsics.article, __VLS_intrinsics.article)({
    ...{ class: "movie-card" },
    'data-testid': (`movie-card-${__VLS_ctx.movie.id}`),
});
/** @type {__VLS_StyleScopedClasses['movie-card']} */ ;
let __VLS_0;
/** @ts-ignore @type { | typeof __VLS_components.RouterLink | typeof __VLS_components.RouterLink} */
RouterLink;
// @ts-ignore
const __VLS_1 = __VLS_asFunctionalComponent1(__VLS_0, new __VLS_0({
    to: (`/movies/${__VLS_ctx.movie.id}`),
    ...{ class: "poster-link" },
    'aria-label': (`查看${__VLS_ctx.movie.name}`),
}));
const __VLS_2 = __VLS_1({
    to: (`/movies/${__VLS_ctx.movie.id}`),
    ...{ class: "poster-link" },
    'aria-label': (`查看${__VLS_ctx.movie.name}`),
}, ...__VLS_functionalComponentArgsRest(__VLS_1));
/** @type {__VLS_StyleScopedClasses['poster-link']} */ ;
const { default: __VLS_5 } = __VLS_3.slots;
if (__VLS_ctx.movie.cover) {
    __VLS_asFunctionalElement1(__VLS_intrinsics.img)({
        src: (__VLS_ctx.movie.cover),
        alt: (`${__VLS_ctx.movie.name}海报`),
        ...{ class: "poster-image" },
    });
    /** @type {__VLS_StyleScopedClasses['poster-image']} */ ;
}
else {
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
        ...{ class: "poster-fallback" },
        ...{ style: ({ background: __VLS_ctx.gradients[(__VLS_ctx.index || 0) % __VLS_ctx.gradients.length] }) },
    });
    /** @type {__VLS_StyleScopedClasses['poster-fallback']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    (__VLS_ctx.movie.name);
    __VLS_asFunctionalElement1(__VLS_intrinsics.small, __VLS_intrinsics.small)({});
}
__VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({
    ...{ class: "score-badge" },
});
/** @type {__VLS_StyleScopedClasses['score-badge']} */ ;
(Number(__VLS_ctx.movie.score || 0).toFixed(1));
// @ts-ignore
[movie, movie, movie, movie, movie, movie, movie, movie, gradients, gradients, index,];
var __VLS_3;
__VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
    ...{ class: "movie-card-body" },
});
/** @type {__VLS_StyleScopedClasses['movie-card-body']} */ ;
let __VLS_6;
/** @ts-ignore @type { | typeof __VLS_components.RouterLink | typeof __VLS_components.RouterLink} */
RouterLink;
// @ts-ignore
const __VLS_7 = __VLS_asFunctionalComponent1(__VLS_6, new __VLS_6({
    to: (`/movies/${__VLS_ctx.movie.id}`),
    ...{ class: "movie-title" },
    dataTestid: (`movie-title-${__VLS_ctx.movie.id}`),
}));
const __VLS_8 = __VLS_7({
    to: (`/movies/${__VLS_ctx.movie.id}`),
    ...{ class: "movie-title" },
    dataTestid: (`movie-title-${__VLS_ctx.movie.id}`),
}, ...__VLS_functionalComponentArgsRest(__VLS_7));
/** @type {__VLS_StyleScopedClasses['movie-title']} */ ;
const { default: __VLS_11 } = __VLS_9.slots;
(__VLS_ctx.movie.name);
// @ts-ignore
[movie, movie, movie,];
var __VLS_9;
__VLS_asFunctionalElement1(__VLS_intrinsics.p, __VLS_intrinsics.p)({});
(__VLS_ctx.movie.genres || "类型待定");
(__VLS_ctx.movie.releaseYear || "年份待定");
let __VLS_12;
/** @ts-ignore @type { | typeof __VLS_components.RouterLink | typeof __VLS_components.RouterLink} */
RouterLink;
// @ts-ignore
const __VLS_13 = __VLS_asFunctionalComponent1(__VLS_12, new __VLS_12({
    to: (`/movies/${__VLS_ctx.movie.id}`),
    ...{ class: "card-action" },
    dataTestid: (`movie-detail-${__VLS_ctx.movie.id}`),
}));
const __VLS_14 = __VLS_13({
    to: (`/movies/${__VLS_ctx.movie.id}`),
    ...{ class: "card-action" },
    dataTestid: (`movie-detail-${__VLS_ctx.movie.id}`),
}, ...__VLS_functionalComponentArgsRest(__VLS_13));
/** @type {__VLS_StyleScopedClasses['card-action']} */ ;
const { default: __VLS_17 } = __VLS_15.slots;
// @ts-ignore
[movie, movie, movie, movie,];
var __VLS_15;
// @ts-ignore
[];
const __VLS_export = (await import('vue')).defineComponent({
    __typeProps: {},
});
export default {};
