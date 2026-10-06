import { onMounted, reactive, ref } from "vue";
import { adminApi, movieApi } from "../../api";
import { errorMessage } from "../../api/http";
const cinemas = ref([]);
const loading = ref(true);
const submitting = ref(false);
const error = ref("");
const success = ref("");
const showForm = ref(false);
const form = reactive({ name: "", city: "", address: "" });
async function load() {
    loading.value = true;
    error.value = "";
    try {
        cinemas.value = (await movieApi.cinemas()).data.data;
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
    if (!form.name.trim() || !form.city.trim() || !form.address.trim()) {
        error.value = "影院名称、城市和详细地址均不能为空";
        return;
    }
    submitting.value = true;
    try {
        const result = await adminApi.createCinema({ name: form.name.trim(), city: form.city.trim(), address: form.address.trim() });
        success.value = `影院“${result.data.data.name}”创建成功`;
        Object.assign(form, { name: "", city: "", address: "" });
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
    'data-testid': "admin-cinemas-page",
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
    'data-testid': "open-create-cinema",
});
/** @type {__VLS_StyleScopedClasses['button']} */ ;
/** @type {__VLS_StyleScopedClasses['button-primary']} */ ;
(__VLS_ctx.showForm ? '收起表单' : '+ 新增影院');
if (__VLS_ctx.success) {
    __VLS_asFunctionalElement1(__VLS_intrinsics.p, __VLS_intrinsics.p)({
        ...{ class: "inline-alert success" },
        role: "status",
        'data-testid': "create-cinema-success",
    });
    /** @type {__VLS_StyleScopedClasses['inline-alert']} */ ;
    /** @type {__VLS_StyleScopedClasses['success']} */ ;
    (__VLS_ctx.success);
}
if (__VLS_ctx.error) {
    __VLS_asFunctionalElement1(__VLS_intrinsics.p, __VLS_intrinsics.p)({
        ...{ class: "inline-alert error" },
        role: "alert",
        'data-testid': "create-cinema-error",
    });
    /** @type {__VLS_StyleScopedClasses['inline-alert']} */ ;
    /** @type {__VLS_StyleScopedClasses['error']} */ ;
    (__VLS_ctx.error);
}
if (__VLS_ctx.showForm) {
    __VLS_asFunctionalElement1(__VLS_intrinsics.section, __VLS_intrinsics.section)({
        ...{ class: "admin-form-panel" },
        'data-testid': "create-cinema-panel",
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
        'data-testid': "admin-cinema-name",
        maxlength: "128",
        placeholder: "如：CineFlow国际影城",
    });
    (__VLS_ctx.form.name);
    __VLS_asFunctionalElement1(__VLS_intrinsics.label, __VLS_intrinsics.label)({
        ...{ class: "form-field" },
    });
    /** @type {__VLS_StyleScopedClasses['form-field']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.input)({
        'data-testid': "admin-cinema-city",
        maxlength: "64",
        placeholder: "如：北京",
    });
    (__VLS_ctx.form.city);
    __VLS_asFunctionalElement1(__VLS_intrinsics.label, __VLS_intrinsics.label)({
        ...{ class: "form-field" },
    });
    /** @type {__VLS_StyleScopedClasses['form-field']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.input)({
        'data-testid': "admin-cinema-address",
        maxlength: "255",
        placeholder: "请输入街道、商场及楼层",
    });
    (__VLS_ctx.form.address);
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
                [showForm, showForm, showForm, success, success, error, error, submit, form, form, form,];
            } },
        type: "button",
        ...{ class: "button button-ghost" },
    });
    /** @type {__VLS_StyleScopedClasses['button']} */ ;
    /** @type {__VLS_StyleScopedClasses['button-ghost']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.button, __VLS_intrinsics.button)({
        ...{ class: "button button-primary" },
        'data-testid': "submit-create-cinema",
        disabled: (__VLS_ctx.submitting),
    });
    /** @type {__VLS_StyleScopedClasses['button']} */ ;
    /** @type {__VLS_StyleScopedClasses['button-primary']} */ ;
    (__VLS_ctx.submitting ? '正在创建…' : '确认创建');
}
__VLS_asFunctionalElement1(__VLS_intrinsics.section, __VLS_intrinsics.section)({
    ...{ class: "cinema-admin-grid" },
    'data-testid': "admin-cinema-list",
});
/** @type {__VLS_StyleScopedClasses['cinema-admin-grid']} */ ;
if (__VLS_ctx.loading) {
    __VLS_asFunctionalElement1(__VLS_intrinsics.article, __VLS_intrinsics.article)({
        ...{ class: "admin-panel table-message" },
    });
    /** @type {__VLS_StyleScopedClasses['admin-panel']} */ ;
    /** @type {__VLS_StyleScopedClasses['table-message']} */ ;
}
else {
    for (const [cinema] of __VLS_vFor((__VLS_ctx.cinemas))) {
        __VLS_asFunctionalElement1(__VLS_intrinsics.article, __VLS_intrinsics.article)({
            key: (cinema.id),
            ...{ class: "cinema-admin-card" },
            'data-testid': (`admin-cinema-card-${cinema.id}`),
        });
        /** @type {__VLS_StyleScopedClasses['cinema-admin-card']} */ ;
        __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
            ...{ class: "cinema-symbol" },
        });
        /** @type {__VLS_StyleScopedClasses['cinema-symbol']} */ ;
        __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({});
        __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({
            ...{ class: "table-status available" },
        });
        /** @type {__VLS_StyleScopedClasses['table-status']} */ ;
        /** @type {__VLS_StyleScopedClasses['available']} */ ;
        __VLS_asFunctionalElement1(__VLS_intrinsics.h2, __VLS_intrinsics.h2)({});
        (cinema.name);
        __VLS_asFunctionalElement1(__VLS_intrinsics.p, __VLS_intrinsics.p)({});
        (cinema.city);
        (cinema.address);
        __VLS_asFunctionalElement1(__VLS_intrinsics.small, __VLS_intrinsics.small)({});
        (cinema.id);
        // @ts-ignore
        [submitting, submitting, loading, cinemas,];
    }
}
if (!__VLS_ctx.loading && !__VLS_ctx.cinemas.length) {
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
        ...{ class: "admin-empty" },
    });
    /** @type {__VLS_StyleScopedClasses['admin-empty']} */ ;
}
// @ts-ignore
[loading, cinemas,];
const __VLS_export = (await import('vue')).defineComponent({});
export default {};
