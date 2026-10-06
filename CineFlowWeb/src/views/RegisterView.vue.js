import { reactive, ref } from "vue";
import { useRouter } from "vue-router";
import { authApi } from "../api";
import { errorMessage } from "../api/http";
const router = useRouter();
const form = reactive({ username: "", phone: "", email: "", password: "", confirmPassword: "" });
const errors = reactive({});
const submitError = ref("");
const loading = ref(false);
function validate() {
    errors.username = /^[A-Za-z0-9_]{3,32}$/.test(form.username) ? "" : "3-32位字母、数字或下划线";
    errors.phone = /^1[3-9]\d{9}$/.test(form.phone) ? "" : "请输入正确的11位手机号";
    errors.email = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(form.email) ? "" : "请输入正确的邮箱";
    errors.password = form.password.length >= 6 && /[A-Za-z]/.test(form.password) && /\d/.test(form.password) ? "" : "至少6位，且同时包含字母和数字";
    errors.confirmPassword = form.confirmPassword === form.password ? "" : "两次输入的密码不一致";
    return Object.values(errors).every((value) => !value);
}
async function submit() {
    submitError.value = "";
    if (!validate())
        return;
    loading.value = true;
    try {
        await authApi.register({ username: form.username, phone: form.phone, email: form.email, password: form.password });
        await router.push({ name: "login", query: { registered: "1" } });
    }
    catch (e) {
        submitError.value = errorMessage(e);
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
    ...{ class: "auth-page auth-page-register" },
    'data-testid': "register-page",
});
/** @type {__VLS_StyleScopedClasses['auth-page']} */ ;
/** @type {__VLS_StyleScopedClasses['auth-page-register']} */ ;
__VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
    ...{ class: "auth-visual" },
});
/** @type {__VLS_StyleScopedClasses['auth-visual']} */ ;
__VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({});
__VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({
    ...{ class: "eyebrow" },
});
/** @type {__VLS_StyleScopedClasses['eyebrow']} */ ;
__VLS_asFunctionalElement1(__VLS_intrinsics.h1, __VLS_intrinsics.h1)({});
__VLS_asFunctionalElement1(__VLS_intrinsics.br)({});
__VLS_asFunctionalElement1(__VLS_intrinsics.p, __VLS_intrinsics.p)({});
__VLS_asFunctionalElement1(__VLS_intrinsics.section, __VLS_intrinsics.section)({
    ...{ class: "auth-card" },
});
/** @type {__VLS_StyleScopedClasses['auth-card']} */ ;
let __VLS_0;
/** @ts-ignore @type { | typeof __VLS_components.RouterLink | typeof __VLS_components.RouterLink} */
RouterLink;
// @ts-ignore
const __VLS_1 = __VLS_asFunctionalComponent1(__VLS_0, new __VLS_0({
    to: "/",
    ...{ class: "brand" },
}));
const __VLS_2 = __VLS_1({
    to: "/",
    ...{ class: "brand" },
}, ...__VLS_functionalComponentArgsRest(__VLS_1));
/** @type {__VLS_StyleScopedClasses['brand']} */ ;
const { default: __VLS_5 } = __VLS_3.slots;
__VLS_asFunctionalElement1(__VLS_intrinsics.i, __VLS_intrinsics.i)({});
var __VLS_3;
__VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
    ...{ class: "auth-heading" },
});
/** @type {__VLS_StyleScopedClasses['auth-heading']} */ ;
__VLS_asFunctionalElement1(__VLS_intrinsics.h2, __VLS_intrinsics.h2)({});
__VLS_asFunctionalElement1(__VLS_intrinsics.p, __VLS_intrinsics.p)({});
if (__VLS_ctx.submitError) {
    __VLS_asFunctionalElement1(__VLS_intrinsics.p, __VLS_intrinsics.p)({
        ...{ class: "inline-alert error" },
        role: "alert",
        'data-testid': "register-error",
    });
    /** @type {__VLS_StyleScopedClasses['inline-alert']} */ ;
    /** @type {__VLS_StyleScopedClasses['error']} */ ;
    (__VLS_ctx.submitError);
}
__VLS_asFunctionalElement1(__VLS_intrinsics.form, __VLS_intrinsics.form)({
    ...{ onSubmit: (__VLS_ctx.submit) },
    novalidate: true,
    'data-testid': "register-form",
});
__VLS_asFunctionalElement1(__VLS_intrinsics.label, __VLS_intrinsics.label)({
    ...{ class: "form-field" },
});
/** @type {__VLS_StyleScopedClasses['form-field']} */ ;
__VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
__VLS_asFunctionalElement1(__VLS_intrinsics.input)({
    'data-testid': "register-username",
    autocomplete: "username",
    placeholder: "3-32位字母、数字或下划线",
});
(__VLS_ctx.form.username);
if (__VLS_ctx.errors.username) {
    __VLS_asFunctionalElement1(__VLS_intrinsics.small, __VLS_intrinsics.small)({
        ...{ class: "field-error" },
    });
    /** @type {__VLS_StyleScopedClasses['field-error']} */ ;
    (__VLS_ctx.errors.username);
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
    'data-testid': "register-phone",
    inputmode: "numeric",
    placeholder: "请输入手机号",
});
(__VLS_ctx.form.phone);
if (__VLS_ctx.errors.phone) {
    __VLS_asFunctionalElement1(__VLS_intrinsics.small, __VLS_intrinsics.small)({
        ...{ class: "field-error" },
    });
    /** @type {__VLS_StyleScopedClasses['field-error']} */ ;
    (__VLS_ctx.errors.phone);
}
__VLS_asFunctionalElement1(__VLS_intrinsics.label, __VLS_intrinsics.label)({
    ...{ class: "form-field" },
});
/** @type {__VLS_StyleScopedClasses['form-field']} */ ;
__VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
__VLS_asFunctionalElement1(__VLS_intrinsics.input)({
    'data-testid': "register-email",
    type: "email",
    placeholder: "name@example.com",
});
(__VLS_ctx.form.email);
if (__VLS_ctx.errors.email) {
    __VLS_asFunctionalElement1(__VLS_intrinsics.small, __VLS_intrinsics.small)({
        ...{ class: "field-error" },
    });
    /** @type {__VLS_StyleScopedClasses['field-error']} */ ;
    (__VLS_ctx.errors.email);
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
    'data-testid': "register-password",
    type: "password",
    autocomplete: "new-password",
    placeholder: "至少6位字母和数字",
});
(__VLS_ctx.form.password);
if (__VLS_ctx.errors.password) {
    __VLS_asFunctionalElement1(__VLS_intrinsics.small, __VLS_intrinsics.small)({
        ...{ class: "field-error" },
    });
    /** @type {__VLS_StyleScopedClasses['field-error']} */ ;
    (__VLS_ctx.errors.password);
}
__VLS_asFunctionalElement1(__VLS_intrinsics.label, __VLS_intrinsics.label)({
    ...{ class: "form-field" },
});
/** @type {__VLS_StyleScopedClasses['form-field']} */ ;
__VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
__VLS_asFunctionalElement1(__VLS_intrinsics.input)({
    'data-testid': "register-confirm-password",
    type: "password",
    autocomplete: "new-password",
    placeholder: "再次输入密码",
});
(__VLS_ctx.form.confirmPassword);
if (__VLS_ctx.errors.confirmPassword) {
    __VLS_asFunctionalElement1(__VLS_intrinsics.small, __VLS_intrinsics.small)({
        ...{ class: "field-error" },
    });
    /** @type {__VLS_StyleScopedClasses['field-error']} */ ;
    (__VLS_ctx.errors.confirmPassword);
}
__VLS_asFunctionalElement1(__VLS_intrinsics.button, __VLS_intrinsics.button)({
    ...{ class: "button button-primary button-block" },
    'data-testid': "register-submit",
    disabled: (__VLS_ctx.loading),
});
/** @type {__VLS_StyleScopedClasses['button']} */ ;
/** @type {__VLS_StyleScopedClasses['button-primary']} */ ;
/** @type {__VLS_StyleScopedClasses['button-block']} */ ;
(__VLS_ctx.loading ? "注册中…" : "创建账号");
__VLS_asFunctionalElement1(__VLS_intrinsics.p, __VLS_intrinsics.p)({
    ...{ class: "auth-switch" },
});
/** @type {__VLS_StyleScopedClasses['auth-switch']} */ ;
let __VLS_6;
/** @ts-ignore @type { | typeof __VLS_components.RouterLink | typeof __VLS_components.RouterLink} */
RouterLink;
// @ts-ignore
const __VLS_7 = __VLS_asFunctionalComponent1(__VLS_6, new __VLS_6({
    to: "/login",
    dataTestid: "go-login",
}));
const __VLS_8 = __VLS_7({
    to: "/login",
    dataTestid: "go-login",
}, ...__VLS_functionalComponentArgsRest(__VLS_7));
const { default: __VLS_11 } = __VLS_9.slots;
// @ts-ignore
[submitError, submitError, submit, form, form, form, form, form, errors, errors, errors, errors, errors, errors, errors, errors, errors, errors, loading, loading,];
var __VLS_9;
// @ts-ignore
[];
const __VLS_export = (await import('vue')).defineComponent({});
export default {};
