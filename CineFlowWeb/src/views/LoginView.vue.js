import { computed, reactive, ref } from "vue";
import { useRoute, useRouter } from "vue-router";
import { errorMessage } from "../api/http";
import { useAuthStore } from "../stores/auth";
const auth = useAuthStore();
const route = useRoute();
const router = useRouter();
const form = reactive({ username: "", password: "" });
const errors = reactive({ username: "", password: "" });
const submitError = ref("");
const loading = ref(false);
const expired = computed(() => route.query.expired === "1");
const registered = computed(() => route.query.registered === "1");
function validate() {
    errors.username = form.username.trim() ? "" : "请输入用户名";
    errors.password = form.password ? "" : "请输入密码";
    return !errors.username && !errors.password;
}
async function submit() {
    submitError.value = "";
    if (!validate())
        return;
    loading.value = true;
    try {
        await auth.login(form.username.trim(), form.password);
        const target = typeof route.query.redirect === "string" ? route.query.redirect : "/";
        await router.replace(target);
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
    ...{ class: "auth-page" },
    'data-testid': "login-page",
});
/** @type {__VLS_StyleScopedClasses['auth-page']} */ ;
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
if (__VLS_ctx.registered) {
    __VLS_asFunctionalElement1(__VLS_intrinsics.p, __VLS_intrinsics.p)({
        ...{ class: "inline-alert success" },
        role: "status",
        'data-testid': "register-success-alert",
    });
    /** @type {__VLS_StyleScopedClasses['inline-alert']} */ ;
    /** @type {__VLS_StyleScopedClasses['success']} */ ;
}
if (__VLS_ctx.expired) {
    __VLS_asFunctionalElement1(__VLS_intrinsics.p, __VLS_intrinsics.p)({
        ...{ class: "inline-alert warning" },
        role: "alert",
        'data-testid': "session-expired-alert",
    });
    /** @type {__VLS_StyleScopedClasses['inline-alert']} */ ;
    /** @type {__VLS_StyleScopedClasses['warning']} */ ;
}
if (__VLS_ctx.submitError) {
    __VLS_asFunctionalElement1(__VLS_intrinsics.p, __VLS_intrinsics.p)({
        ...{ class: "inline-alert error" },
        role: "alert",
        'data-testid': "login-error",
    });
    /** @type {__VLS_StyleScopedClasses['inline-alert']} */ ;
    /** @type {__VLS_StyleScopedClasses['error']} */ ;
    (__VLS_ctx.submitError);
}
__VLS_asFunctionalElement1(__VLS_intrinsics.form, __VLS_intrinsics.form)({
    ...{ onSubmit: (__VLS_ctx.submit) },
    novalidate: true,
    'data-testid': "login-form",
});
__VLS_asFunctionalElement1(__VLS_intrinsics.label, __VLS_intrinsics.label)({
    ...{ class: "form-field" },
});
/** @type {__VLS_StyleScopedClasses['form-field']} */ ;
__VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
__VLS_asFunctionalElement1(__VLS_intrinsics.input)({
    ...{ onBlur: (__VLS_ctx.validate) },
    'data-testid': "login-username",
    autocomplete: "username",
    placeholder: "请输入用户名",
});
(__VLS_ctx.form.username);
if (__VLS_ctx.errors.username) {
    __VLS_asFunctionalElement1(__VLS_intrinsics.small, __VLS_intrinsics.small)({
        ...{ class: "field-error" },
    });
    /** @type {__VLS_StyleScopedClasses['field-error']} */ ;
    (__VLS_ctx.errors.username);
}
__VLS_asFunctionalElement1(__VLS_intrinsics.label, __VLS_intrinsics.label)({
    ...{ class: "form-field" },
});
/** @type {__VLS_StyleScopedClasses['form-field']} */ ;
__VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
__VLS_asFunctionalElement1(__VLS_intrinsics.input)({
    ...{ onBlur: (__VLS_ctx.validate) },
    'data-testid': "login-password",
    type: "password",
    autocomplete: "current-password",
    placeholder: "请输入密码",
});
(__VLS_ctx.form.password);
if (__VLS_ctx.errors.password) {
    __VLS_asFunctionalElement1(__VLS_intrinsics.small, __VLS_intrinsics.small)({
        ...{ class: "field-error" },
    });
    /** @type {__VLS_StyleScopedClasses['field-error']} */ ;
    (__VLS_ctx.errors.password);
}
__VLS_asFunctionalElement1(__VLS_intrinsics.button, __VLS_intrinsics.button)({
    ...{ class: "button button-primary button-block" },
    'data-testid': "login-submit",
    disabled: (__VLS_ctx.loading),
});
/** @type {__VLS_StyleScopedClasses['button']} */ ;
/** @type {__VLS_StyleScopedClasses['button-primary']} */ ;
/** @type {__VLS_StyleScopedClasses['button-block']} */ ;
(__VLS_ctx.loading ? "登录中…" : "登录");
__VLS_asFunctionalElement1(__VLS_intrinsics.p, __VLS_intrinsics.p)({
    ...{ class: "auth-switch" },
});
/** @type {__VLS_StyleScopedClasses['auth-switch']} */ ;
let __VLS_6;
/** @ts-ignore @type { | typeof __VLS_components.RouterLink | typeof __VLS_components.RouterLink} */
RouterLink;
// @ts-ignore
const __VLS_7 = __VLS_asFunctionalComponent1(__VLS_6, new __VLS_6({
    to: "/register",
    dataTestid: "go-register",
}));
const __VLS_8 = __VLS_7({
    to: "/register",
    dataTestid: "go-register",
}, ...__VLS_functionalComponentArgsRest(__VLS_7));
const { default: __VLS_11 } = __VLS_9.slots;
// @ts-ignore
[registered, expired, submitError, submitError, submit, validate, validate, form, form, errors, errors, errors, errors, loading, loading,];
var __VLS_9;
__VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
    ...{ class: "demo-account" },
});
/** @type {__VLS_StyleScopedClasses['demo-account']} */ ;
__VLS_asFunctionalElement1(__VLS_intrinsics.strong, __VLS_intrinsics.strong)({});
__VLS_asFunctionalElement1(__VLS_intrinsics.code, __VLS_intrinsics.code)({});
// @ts-ignore
[];
const __VLS_export = (await import('vue')).defineComponent({});
export default {};
