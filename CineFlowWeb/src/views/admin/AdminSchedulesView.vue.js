import { computed, onMounted, reactive, ref, watch } from "vue";
import { adminApi, movieApi } from "../../api";
import { errorMessage } from "../../api/http";
function toLocalInput(date) {
    const local = new Date(date.getTime() - date.getTimezoneOffset() * 60000);
    return local.toISOString().slice(0, 16);
}
const tomorrow = new Date(Date.now() + 24 * 60 * 60 * 1000);
tomorrow.setHours(19, 30, 0, 0);
const movies = ref([]);
const cinemas = ref([]);
const schedules = ref([]);
const loading = ref(true);
const submitting = ref(false);
const listLoading = ref(false);
const error = ref("");
const success = ref("");
const created = ref(null);
const form = reactive({ movieId: 0, cinemaId: 0, hallName: "1号厅", startTime: toLocalInput(tomorrow), endTime: toLocalInput(new Date(tomorrow.getTime() + 2 * 60 * 60 * 1000)), price: 45, rows: 5, seatsPerRow: 10 });
const seatTotal = computed(() => Number(form.rows) * Number(form.seatsPerRow));
async function loadOptions() {
    loading.value = true;
    error.value = "";
    try {
        const [movieResult, cinemaResult] = await Promise.all([movieApi.list({ pageNum: 1, pageSize: 100 }), movieApi.cinemas()]);
        movies.value = movieResult.data.data.list;
        cinemas.value = cinemaResult.data.data;
        if (!form.movieId && movies.value.length)
            form.movieId = movies.value[0].id;
        if (!form.cinemaId && cinemas.value.length)
            form.cinemaId = cinemas.value[0].id;
        await loadSchedules();
    }
    catch (e) {
        error.value = errorMessage(e);
    }
    finally {
        loading.value = false;
    }
}
async function loadSchedules() {
    if (!form.movieId) {
        schedules.value = [];
        return;
    }
    listLoading.value = true;
    try {
        schedules.value = (await movieApi.schedules(Number(form.movieId))).data.data;
    }
    catch (e) {
        error.value = errorMessage(e);
    }
    finally {
        listLoading.value = false;
    }
}
watch(() => form.startTime, (value) => {
    const start = new Date(value);
    if (!Number.isNaN(start.getTime()))
        form.endTime = toLocalInput(new Date(start.getTime() + 2 * 60 * 60 * 1000));
});
async function submit() {
    error.value = "";
    success.value = "";
    created.value = null;
    if (!form.movieId || !form.cinemaId || !form.hallName.trim()) {
        error.value = "请选择电影和影院，并填写影厅名称";
        return;
    }
    if (new Date(form.endTime) <= new Date(form.startTime)) {
        error.value = "结束时间必须晚于开始时间";
        return;
    }
    submitting.value = true;
    try {
        const result = await adminApi.createSchedule({
            movieId: Number(form.movieId), cinemaId: Number(form.cinemaId), hallName: form.hallName.trim(),
            startTime: form.startTime, endTime: form.endTime, price: Number(form.price), rows: Number(form.rows), seatsPerRow: Number(form.seatsPerRow)
        });
        created.value = result.data.data;
        success.value = `场次 #${created.value.id} 创建成功，已生成 ${seatTotal.value} 个座位`;
        await loadSchedules();
    }
    catch (e) {
        error.value = errorMessage(e);
    }
    finally {
        submitting.value = false;
    }
}
onMounted(loadOptions);
const __VLS_ctx = {
    ...{},
    ...{},
};
let __VLS_components;
let __VLS_intrinsics;
let __VLS_directives;
__VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
    'data-testid': "admin-schedules-page",
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
if (__VLS_ctx.success) {
    __VLS_asFunctionalElement1(__VLS_intrinsics.p, __VLS_intrinsics.p)({
        ...{ class: "inline-alert success" },
        role: "status",
        'data-testid': "create-schedule-success",
    });
    /** @type {__VLS_StyleScopedClasses['inline-alert']} */ ;
    /** @type {__VLS_StyleScopedClasses['success']} */ ;
    (__VLS_ctx.success);
}
if (__VLS_ctx.error) {
    __VLS_asFunctionalElement1(__VLS_intrinsics.p, __VLS_intrinsics.p)({
        ...{ class: "inline-alert error" },
        role: "alert",
        'data-testid': "create-schedule-error",
    });
    /** @type {__VLS_StyleScopedClasses['inline-alert']} */ ;
    /** @type {__VLS_StyleScopedClasses['error']} */ ;
    (__VLS_ctx.error);
}
if (__VLS_ctx.loading) {
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
        ...{ class: "admin-panel table-message" },
    });
    /** @type {__VLS_StyleScopedClasses['admin-panel']} */ ;
    /** @type {__VLS_StyleScopedClasses['table-message']} */ ;
}
else {
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
        ...{ class: "schedule-admin-layout" },
    });
    /** @type {__VLS_StyleScopedClasses['schedule-admin-layout']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.section, __VLS_intrinsics.section)({
        ...{ class: "admin-form-panel sticky-form" },
    });
    /** @type {__VLS_StyleScopedClasses['admin-form-panel']} */ ;
    /** @type {__VLS_StyleScopedClasses['sticky-form']} */ ;
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
        'data-testid': "create-schedule-form",
    });
    /** @type {__VLS_StyleScopedClasses['admin-form']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.label, __VLS_intrinsics.label)({
        ...{ class: "form-field" },
    });
    /** @type {__VLS_StyleScopedClasses['form-field']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.select, __VLS_intrinsics.select)({
        ...{ onChange: (__VLS_ctx.loadSchedules) },
        value: (__VLS_ctx.form.movieId),
        'data-testid': "admin-schedule-movie",
    });
    for (const [movie] of __VLS_vFor((__VLS_ctx.movies))) {
        __VLS_asFunctionalElement1(__VLS_intrinsics.option, __VLS_intrinsics.option)({
            key: (movie.id),
            value: (movie.id),
        });
        (movie.id);
        (movie.name);
        // @ts-ignore
        [success, success, error, error, loading, submit, loadSchedules, form, movies,];
    }
    __VLS_asFunctionalElement1(__VLS_intrinsics.label, __VLS_intrinsics.label)({
        ...{ class: "form-field" },
    });
    /** @type {__VLS_StyleScopedClasses['form-field']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.select, __VLS_intrinsics.select)({
        value: (__VLS_ctx.form.cinemaId),
        'data-testid': "admin-schedule-cinema",
    });
    for (const [cinema] of __VLS_vFor((__VLS_ctx.cinemas))) {
        __VLS_asFunctionalElement1(__VLS_intrinsics.option, __VLS_intrinsics.option)({
            key: (cinema.id),
            value: (cinema.id),
        });
        (cinema.name);
        (cinema.city);
        // @ts-ignore
        [form, cinemas,];
    }
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
        'data-testid': "admin-schedule-hall",
        maxlength: "64",
    });
    (__VLS_ctx.form.hallName);
    __VLS_asFunctionalElement1(__VLS_intrinsics.label, __VLS_intrinsics.label)({
        ...{ class: "form-field" },
    });
    /** @type {__VLS_StyleScopedClasses['form-field']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
        ...{ class: "input-prefix" },
    });
    /** @type {__VLS_StyleScopedClasses['input-prefix']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.input)({
        'data-testid': "admin-schedule-price",
        type: "number",
        min: "0.01",
        step: "0.01",
    });
    (__VLS_ctx.form.price);
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
        'data-testid': "admin-schedule-start",
        type: "datetime-local",
    });
    (__VLS_ctx.form.startTime);
    __VLS_asFunctionalElement1(__VLS_intrinsics.label, __VLS_intrinsics.label)({
        ...{ class: "form-field" },
    });
    /** @type {__VLS_StyleScopedClasses['form-field']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.input)({
        'data-testid': "admin-schedule-end",
        type: "datetime-local",
    });
    (__VLS_ctx.form.endTime);
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
        ...{ class: "seat-config" },
    });
    /** @type {__VLS_StyleScopedClasses['seat-config']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.strong, __VLS_intrinsics.strong)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.small, __VLS_intrinsics.small)({});
    (__VLS_ctx.seatTotal);
    __VLS_asFunctionalElement1(__VLS_intrinsics.label, __VLS_intrinsics.label)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.input)({
        'data-testid': "admin-schedule-rows",
        type: "number",
        min: "1",
        max: "26",
    });
    (__VLS_ctx.form.rows);
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.label, __VLS_intrinsics.label)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.input)({
        'data-testid': "admin-schedule-seats-per-row",
        type: "number",
        min: "1",
        max: "50",
    });
    (__VLS_ctx.form.seatsPerRow);
    __VLS_asFunctionalElement1(__VLS_intrinsics.button, __VLS_intrinsics.button)({
        ...{ class: "button button-primary button-block" },
        'data-testid': "submit-create-schedule",
        disabled: (__VLS_ctx.submitting || !__VLS_ctx.movies.length || !__VLS_ctx.cinemas.length),
    });
    /** @type {__VLS_StyleScopedClasses['button']} */ ;
    /** @type {__VLS_StyleScopedClasses['button-primary']} */ ;
    /** @type {__VLS_StyleScopedClasses['button-block']} */ ;
    (__VLS_ctx.submitting ? '正在创建场次…' : `创建场次并生成 ${__VLS_ctx.seatTotal} 个座位`);
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
    (__VLS_ctx.movies.find(item => item.id === Number(__VLS_ctx.form.movieId))?.name || '未选择电影');
    __VLS_asFunctionalElement1(__VLS_intrinsics.button, __VLS_intrinsics.button)({
        ...{ onClick: (__VLS_ctx.loadSchedules) },
        ...{ class: "table-refresh" },
        'data-testid': "refresh-schedules",
    });
    /** @type {__VLS_StyleScopedClasses['table-refresh']} */ ;
    if (__VLS_ctx.listLoading) {
        __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
            ...{ class: "table-message" },
        });
        /** @type {__VLS_StyleScopedClasses['table-message']} */ ;
    }
    else if (!__VLS_ctx.schedules.length) {
        __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
            ...{ class: "admin-empty" },
        });
        /** @type {__VLS_StyleScopedClasses['admin-empty']} */ ;
    }
    else {
        __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
            ...{ class: "admin-schedule-list" },
            'data-testid': "admin-schedule-list",
        });
        /** @type {__VLS_StyleScopedClasses['admin-schedule-list']} */ ;
        for (const [schedule] of __VLS_vFor((__VLS_ctx.schedules))) {
            __VLS_asFunctionalElement1(__VLS_intrinsics.article, __VLS_intrinsics.article)({
                key: (schedule.id),
                'data-testid': (`admin-schedule-card-${schedule.id}`),
            });
            __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
                ...{ class: "schedule-date" },
            });
            /** @type {__VLS_StyleScopedClasses['schedule-date']} */ ;
            __VLS_asFunctionalElement1(__VLS_intrinsics.strong, __VLS_intrinsics.strong)({});
            (new Date(schedule.startTime).getDate());
            __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
            (new Date(schedule.startTime).toLocaleDateString('zh-CN', { month: 'short' }));
            __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
                ...{ class: "schedule-admin-info" },
            });
            /** @type {__VLS_StyleScopedClasses['schedule-admin-info']} */ ;
            __VLS_asFunctionalElement1(__VLS_intrinsics.strong, __VLS_intrinsics.strong)({});
            (schedule.cinemaName);
            (schedule.hallName);
            __VLS_asFunctionalElement1(__VLS_intrinsics.p, __VLS_intrinsics.p)({});
            (new Date(schedule.startTime).toLocaleString('zh-CN'));
            (new Date(schedule.endTime).toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' }));
            __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
                ...{ class: "schedule-admin-price" },
            });
            /** @type {__VLS_StyleScopedClasses['schedule-admin-price']} */ ;
            (Number(schedule.price).toFixed(2));
            __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({
                ...{ class: "table-status available" },
            });
            /** @type {__VLS_StyleScopedClasses['table-status']} */ ;
            /** @type {__VLS_StyleScopedClasses['available']} */ ;
            // @ts-ignore
            [loadSchedules, form, form, form, form, form, form, form, movies, movies, cinemas, seatTotal, seatTotal, submitting, submitting, listLoading, schedules, schedules,];
        }
    }
}
// @ts-ignore
[];
const __VLS_export = (await import('vue')).defineComponent({});
export default {};
