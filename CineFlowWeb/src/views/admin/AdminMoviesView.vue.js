import { onMounted, reactive, ref } from "vue";
import { adminApi, movieApi } from "../../api";
import { errorMessage } from "../../api/http";
const movies = ref([]);
const total = ref(0);
const loading = ref(true);
const submitting = ref(false);
const error = ref("");
const success = ref("");
const showForm = ref(false);
const form = reactive({ name: "", genres: "", regions: "", releaseYear: new Date().getFullYear(), score: 0, status: "AVAILABLE" });
async function load() {
    loading.value = true;
    error.value = "";
    try {
        const result = await movieApi.list({ pageNum: 1, pageSize: 100 });
        movies.value = result.data.data.list;
        total.value = result.data.data.total;
    }
    catch (e) {
        error.value = errorMessage(e);
    }
    finally {
        loading.value = false;
    }
}
async function submit() {
    error.value = "";
    success.value = "";
    if (!form.name.trim()) {
        error.value = "请输入电影名称";
        return;
    }
    submitting.value = true;
    try {
        const result = await adminApi.createMovie({ ...form, name: form.name.trim(), genres: form.genres.trim(), regions: form.regions.trim(), releaseYear: Number(form.releaseYear), score: Number(form.score) });
        success.value = `电影“${result.data.data.name}”创建成功`;
        Object.assign(form, { name: "", genres: "", regions: "", releaseYear: new Date().getFullYear(), score: 0, status: "AVAILABLE" });
        showForm.value = false;
        await load();
    }
    catch (e) {
        error.value = errorMessage(e);
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
    'data-testid': "admin-movies-page",
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
    ...{ onClick: (...[$event]) => {
            return (__VLS_ctx.showForm = !__VLS_ctx.showForm);
            // @ts-ignore
            [showForm, showForm,];
        } },
    ...{ class: "button button-primary" },
    'data-testid': "open-create-movie",
});
/** @type {__VLS_StyleScopedClasses['button']} */ ;
/** @type {__VLS_StyleScopedClasses['button-primary']} */ ;
(__VLS_ctx.showForm ? '收起表单' : '+ 新增电影');
if (__VLS_ctx.success) {
    __VLS_asFunctionalElement1(__VLS_intrinsics.p, __VLS_intrinsics.p)({
        ...{ class: "inline-alert success" },
        role: "status",
        'data-testid': "create-movie-success",
    });
    /** @type {__VLS_StyleScopedClasses['inline-alert']} */ ;
    /** @type {__VLS_StyleScopedClasses['success']} */ ;
    (__VLS_ctx.success);
}
if (__VLS_ctx.error) {
    __VLS_asFunctionalElement1(__VLS_intrinsics.p, __VLS_intrinsics.p)({
        ...{ class: "inline-alert error" },
        role: "alert",
        'data-testid': "create-movie-error",
    });
    /** @type {__VLS_StyleScopedClasses['inline-alert']} */ ;
    /** @type {__VLS_StyleScopedClasses['error']} */ ;
    (__VLS_ctx.error);
}
if (__VLS_ctx.showForm) {
    __VLS_asFunctionalElement1(__VLS_intrinsics.section, __VLS_intrinsics.section)({
        ...{ class: "admin-form-panel" },
        'data-testid': "create-movie-panel",
    });
    /** @type {__VLS_StyleScopedClasses['admin-form-panel']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
        ...{ class: "panel-heading" },
    });
    /** @type {__VLS_StyleScopedClasses['panel-heading']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.h2, __VLS_intrinsics.h2)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.p, __VLS_intrinsics.p)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.form, __VLS_intrinsics.form)({
        ...{ onSubmit: (__VLS_ctx.submit) },
        ...{ class: "admin-form" },
    });
    /** @type {__VLS_StyleScopedClasses['admin-form']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.label, __VLS_intrinsics.label)({
        ...{ class: "form-field" },
    });
    /** @type {__VLS_StyleScopedClasses['form-field']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.input)({
        'data-testid': "admin-movie-name",
        maxlength: "255",
        placeholder: "请输入电影名称",
    });
    (__VLS_ctx.form.name);
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
        ...{ class: "form-row" },
    });
    /** @type {__VLS_StyleScopedClasses['form-row']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.label, __VLS_intrinsics.label)({
        ...{ class: "form-field" },
    });
    /** @type {__VLS_StyleScopedClasses['form-field']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.input)({
        'data-testid': "admin-movie-genres",
        maxlength: "255",
        placeholder: "科幻/剧情",
    });
    (__VLS_ctx.form.genres);
    __VLS_asFunctionalElement1(__VLS_intrinsics.label, __VLS_intrinsics.label)({
        ...{ class: "form-field" },
    });
    /** @type {__VLS_StyleScopedClasses['form-field']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.input)({
        'data-testid': "admin-movie-regions",
        maxlength: "255",
        placeholder: "中国大陆",
    });
    (__VLS_ctx.form.regions);
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
        ...{ class: "form-row three" },
    });
    /** @type {__VLS_StyleScopedClasses['form-row']} */ ;
    /** @type {__VLS_StyleScopedClasses['three']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.label, __VLS_intrinsics.label)({
        ...{ class: "form-field" },
    });
    /** @type {__VLS_StyleScopedClasses['form-field']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.input)({
        'data-testid': "admin-movie-year",
        type: "number",
        min: "1888",
        max: "2200",
    });
    (__VLS_ctx.form.releaseYear);
    __VLS_asFunctionalElement1(__VLS_intrinsics.label, __VLS_intrinsics.label)({
        ...{ class: "form-field" },
    });
    /** @type {__VLS_StyleScopedClasses['form-field']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.input)({
        'data-testid': "admin-movie-score",
        type: "number",
        min: "0",
        max: "10",
        step: "0.1",
    });
    (__VLS_ctx.form.score);
    __VLS_asFunctionalElement1(__VLS_intrinsics.label, __VLS_intrinsics.label)({
        ...{ class: "form-field" },
    });
    /** @type {__VLS_StyleScopedClasses['form-field']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.select, __VLS_intrinsics.select)({
        value: (__VLS_ctx.form.status),
        'data-testid': "admin-movie-status",
    });
    __VLS_asFunctionalElement1(__VLS_intrinsics.option, __VLS_intrinsics.option)({
        value: "AVAILABLE",
    });
    __VLS_asFunctionalElement1(__VLS_intrinsics.option, __VLS_intrinsics.option)({
        value: "OFF_SHELF",
    });
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
        ...{ class: "form-actions" },
    });
    /** @type {__VLS_StyleScopedClasses['form-actions']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.button, __VLS_intrinsics.button)({
        ...{ onClick: (...[$event]) => {
                if (!(__VLS_ctx.showForm))
                    throw 0;
                return (__VLS_ctx.showForm = false);
                // @ts-ignore
                [showForm, showForm, showForm, success, success, error, error, submit, form, form, form, form, form, form,];
            } },
        type: "button",
        ...{ class: "button button-ghost" },
        'data-testid': "cancel-create-movie",
    });
    /** @type {__VLS_StyleScopedClasses['button']} */ ;
    /** @type {__VLS_StyleScopedClasses['button-ghost']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.button, __VLS_intrinsics.button)({
        ...{ class: "button button-primary" },
        'data-testid': "submit-create-movie",
        disabled: (__VLS_ctx.submitting),
    });
    /** @type {__VLS_StyleScopedClasses['button']} */ ;
    /** @type {__VLS_StyleScopedClasses['button-primary']} */ ;
    (__VLS_ctx.submitting ? '正在创建…' : '确认创建');
}
__VLS_asFunctionalElement1(__VLS_intrinsics.section, __VLS_intrinsics.section)({
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
(__VLS_ctx.total);
__VLS_asFunctionalElement1(__VLS_intrinsics.button, __VLS_intrinsics.button)({
    ...{ onClick: (__VLS_ctx.load) },
    ...{ class: "table-refresh" },
    'data-testid': "refresh-movies",
});
/** @type {__VLS_StyleScopedClasses['table-refresh']} */ ;
__VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
    ...{ class: "admin-table-wrap" },
});
/** @type {__VLS_StyleScopedClasses['admin-table-wrap']} */ ;
__VLS_asFunctionalElement1(__VLS_intrinsics.table, __VLS_intrinsics.table)({
    ...{ class: "admin-table" },
    'data-testid': "admin-movie-table",
});
/** @type {__VLS_StyleScopedClasses['admin-table']} */ ;
__VLS_asFunctionalElement1(__VLS_intrinsics.thead, __VLS_intrinsics.thead)({});
__VLS_asFunctionalElement1(__VLS_intrinsics.tr, __VLS_intrinsics.tr)({});
__VLS_asFunctionalElement1(__VLS_intrinsics.th, __VLS_intrinsics.th)({});
__VLS_asFunctionalElement1(__VLS_intrinsics.th, __VLS_intrinsics.th)({});
__VLS_asFunctionalElement1(__VLS_intrinsics.th, __VLS_intrinsics.th)({});
__VLS_asFunctionalElement1(__VLS_intrinsics.th, __VLS_intrinsics.th)({});
__VLS_asFunctionalElement1(__VLS_intrinsics.th, __VLS_intrinsics.th)({});
__VLS_asFunctionalElement1(__VLS_intrinsics.th, __VLS_intrinsics.th)({});
__VLS_asFunctionalElement1(__VLS_intrinsics.th, __VLS_intrinsics.th)({});
__VLS_asFunctionalElement1(__VLS_intrinsics.tbody, __VLS_intrinsics.tbody)({});
if (__VLS_ctx.loading) {
    __VLS_asFunctionalElement1(__VLS_intrinsics.tr, __VLS_intrinsics.tr)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.td, __VLS_intrinsics.td)({
        colspan: "7",
        ...{ class: "table-message" },
    });
    /** @type {__VLS_StyleScopedClasses['table-message']} */ ;
}
else if (!__VLS_ctx.movies.length) {
    __VLS_asFunctionalElement1(__VLS_intrinsics.tr, __VLS_intrinsics.tr)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.td, __VLS_intrinsics.td)({
        colspan: "7",
        ...{ class: "table-message" },
    });
    /** @type {__VLS_StyleScopedClasses['table-message']} */ ;
}
else {
    for (const [movie] of __VLS_vFor((__VLS_ctx.movies))) {
        __VLS_asFunctionalElement1(__VLS_intrinsics.tr, __VLS_intrinsics.tr)({
            key: (movie.id),
            'data-testid': (`admin-movie-row-${movie.id}`),
        });
        __VLS_asFunctionalElement1(__VLS_intrinsics.td, __VLS_intrinsics.td)({});
        (movie.id);
        __VLS_asFunctionalElement1(__VLS_intrinsics.td, __VLS_intrinsics.td)({});
        __VLS_asFunctionalElement1(__VLS_intrinsics.strong, __VLS_intrinsics.strong)({});
        (movie.name);
        __VLS_asFunctionalElement1(__VLS_intrinsics.td, __VLS_intrinsics.td)({});
        (movie.genres || '-');
        __VLS_asFunctionalElement1(__VLS_intrinsics.td, __VLS_intrinsics.td)({});
        (movie.regions || '-');
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
        [submitting, submitting, total, load, loading, movies, movies,];
    }
}
// @ts-ignore
[];
const __VLS_export = (await import('vue')).defineComponent({});
export default {};
