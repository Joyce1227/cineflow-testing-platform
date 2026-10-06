import { ref } from "vue";
import { useRouter } from "vue-router";
import { useAuthStore } from "../stores/auth";
const auth = useAuthStore();
const router = useRouter();
const collapsed = ref(false);
function logout() {
    auth.logout();
    router.replace("/login");
}
const __VLS_ctx = {
    ...{},
    ...{},
};
let __VLS_components;
let __VLS_intrinsics;
let __VLS_directives;
__VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
    ...{ class: "admin-shell" },
    ...{ class: ({ collapsed: __VLS_ctx.collapsed }) },
    'data-testid': "admin-layout",
});
/** @type {__VLS_StyleScopedClasses['admin-shell']} */ ;
/** @type {__VLS_StyleScopedClasses['collapsed']} */ ;
__VLS_asFunctionalElement1(__VLS_intrinsics.aside, __VLS_intrinsics.aside)({
    ...{ class: "admin-sidebar" },
});
/** @type {__VLS_StyleScopedClasses['admin-sidebar']} */ ;
let __VLS_0;
/** @ts-ignore @type { | typeof __VLS_components.RouterLink | typeof __VLS_components.RouterLink} */
RouterLink;
// @ts-ignore
const __VLS_1 = __VLS_asFunctionalComponent1(__VLS_0, new __VLS_0({
    to: "/admin",
    ...{ class: "admin-brand" },
    dataTestid: "admin-logo",
}));
const __VLS_2 = __VLS_1({
    to: "/admin",
    ...{ class: "admin-brand" },
    dataTestid: "admin-logo",
}, ...__VLS_functionalComponentArgsRest(__VLS_1));
/** @type {__VLS_StyleScopedClasses['admin-brand']} */ ;
const { default: __VLS_5 } = __VLS_3.slots;
__VLS_asFunctionalElement1(__VLS_intrinsics.i, __VLS_intrinsics.i)({});
__VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
__VLS_asFunctionalElement1(__VLS_intrinsics.small, __VLS_intrinsics.small)({});
// @ts-ignore
[collapsed,];
var __VLS_3;
__VLS_asFunctionalElement1(__VLS_intrinsics.nav, __VLS_intrinsics.nav)({
    ...{ class: "admin-nav" },
    'aria-label': "管理端导航",
});
/** @type {__VLS_StyleScopedClasses['admin-nav']} */ ;
let __VLS_6;
/** @ts-ignore @type { | typeof __VLS_components.RouterLink | typeof __VLS_components.RouterLink} */
RouterLink;
// @ts-ignore
const __VLS_7 = __VLS_asFunctionalComponent1(__VLS_6, new __VLS_6({
    to: "/admin",
    exactActiveClass: "active",
    dataTestid: "admin-nav-dashboard",
}));
const __VLS_8 = __VLS_7({
    to: "/admin",
    exactActiveClass: "active",
    dataTestid: "admin-nav-dashboard",
}, ...__VLS_functionalComponentArgsRest(__VLS_7));
const { default: __VLS_11 } = __VLS_9.slots;
__VLS_asFunctionalElement1(__VLS_intrinsics.b, __VLS_intrinsics.b)({});
__VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
// @ts-ignore
[];
var __VLS_9;
let __VLS_12;
/** @ts-ignore @type { | typeof __VLS_components.RouterLink | typeof __VLS_components.RouterLink} */
RouterLink;
// @ts-ignore
const __VLS_13 = __VLS_asFunctionalComponent1(__VLS_12, new __VLS_12({
    to: "/admin/movies",
    dataTestid: "admin-nav-movies",
}));
const __VLS_14 = __VLS_13({
    to: "/admin/movies",
    dataTestid: "admin-nav-movies",
}, ...__VLS_functionalComponentArgsRest(__VLS_13));
const { default: __VLS_17 } = __VLS_15.slots;
__VLS_asFunctionalElement1(__VLS_intrinsics.b, __VLS_intrinsics.b)({});
__VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
// @ts-ignore
[];
var __VLS_15;
let __VLS_18;
/** @ts-ignore @type { | typeof __VLS_components.RouterLink | typeof __VLS_components.RouterLink} */
RouterLink;
// @ts-ignore
const __VLS_19 = __VLS_asFunctionalComponent1(__VLS_18, new __VLS_18({
    to: "/admin/cinemas",
    dataTestid: "admin-nav-cinemas",
}));
const __VLS_20 = __VLS_19({
    to: "/admin/cinemas",
    dataTestid: "admin-nav-cinemas",
}, ...__VLS_functionalComponentArgsRest(__VLS_19));
const { default: __VLS_23 } = __VLS_21.slots;
__VLS_asFunctionalElement1(__VLS_intrinsics.b, __VLS_intrinsics.b)({});
__VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
// @ts-ignore
[];
var __VLS_21;
let __VLS_24;
/** @ts-ignore @type { | typeof __VLS_components.RouterLink | typeof __VLS_components.RouterLink} */
RouterLink;
// @ts-ignore
const __VLS_25 = __VLS_asFunctionalComponent1(__VLS_24, new __VLS_24({
    to: "/admin/schedules",
    dataTestid: "admin-nav-schedules",
}));
const __VLS_26 = __VLS_25({
    to: "/admin/schedules",
    dataTestid: "admin-nav-schedules",
}, ...__VLS_functionalComponentArgsRest(__VLS_25));
const { default: __VLS_29 } = __VLS_27.slots;
__VLS_asFunctionalElement1(__VLS_intrinsics.b, __VLS_intrinsics.b)({});
__VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
// @ts-ignore
[];
var __VLS_27;
let __VLS_30;
/** @ts-ignore @type { | typeof __VLS_components.RouterLink | typeof __VLS_components.RouterLink} */
RouterLink;
// @ts-ignore
const __VLS_31 = __VLS_asFunctionalComponent1(__VLS_30, new __VLS_30({
    to: "/",
    ...{ class: "admin-back" },
    dataTestid: "back-to-user-site",
}));
const __VLS_32 = __VLS_31({
    to: "/",
    ...{ class: "admin-back" },
    dataTestid: "back-to-user-site",
}, ...__VLS_functionalComponentArgsRest(__VLS_31));
/** @type {__VLS_StyleScopedClasses['admin-back']} */ ;
const { default: __VLS_35 } = __VLS_33.slots;
__VLS_asFunctionalElement1(__VLS_intrinsics.b, __VLS_intrinsics.b)({});
__VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
// @ts-ignore
[];
var __VLS_33;
__VLS_asFunctionalElement1(__VLS_intrinsics.section, __VLS_intrinsics.section)({
    ...{ class: "admin-main" },
});
/** @type {__VLS_StyleScopedClasses['admin-main']} */ ;
__VLS_asFunctionalElement1(__VLS_intrinsics.header, __VLS_intrinsics.header)({
    ...{ class: "admin-topbar" },
});
/** @type {__VLS_StyleScopedClasses['admin-topbar']} */ ;
__VLS_asFunctionalElement1(__VLS_intrinsics.button, __VLS_intrinsics.button)({
    ...{ onClick: (...[$event]) => {
            return (__VLS_ctx.collapsed = !__VLS_ctx.collapsed);
            // @ts-ignore
            [collapsed, collapsed,];
        } },
    ...{ class: "sidebar-toggle" },
    'aria-label': "切换侧边栏",
    'data-testid': "sidebar-toggle",
});
/** @type {__VLS_StyleScopedClasses['sidebar-toggle']} */ ;
__VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
    ...{ class: "admin-topbar-right" },
});
/** @type {__VLS_StyleScopedClasses['admin-topbar-right']} */ ;
__VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({
    ...{ class: "system-dot" },
});
/** @type {__VLS_StyleScopedClasses['system-dot']} */ ;
__VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
__VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({
    ...{ class: "admin-avatar" },
});
/** @type {__VLS_StyleScopedClasses['admin-avatar']} */ ;
(__VLS_ctx.auth.user?.username.slice(0, 1).toUpperCase());
__VLS_asFunctionalElement1(__VLS_intrinsics.strong, __VLS_intrinsics.strong)({});
(__VLS_ctx.auth.user?.username);
__VLS_asFunctionalElement1(__VLS_intrinsics.button, __VLS_intrinsics.button)({
    ...{ onClick: (__VLS_ctx.logout) },
    'data-testid': "admin-logout",
});
__VLS_asFunctionalElement1(__VLS_intrinsics.main, __VLS_intrinsics.main)({
    ...{ class: "admin-content" },
});
/** @type {__VLS_StyleScopedClasses['admin-content']} */ ;
let __VLS_36;
/** @ts-ignore @type { | typeof __VLS_components.RouterView} */
RouterView;
// @ts-ignore
const __VLS_37 = __VLS_asFunctionalComponent1(__VLS_36, new __VLS_36({}));
const __VLS_38 = __VLS_37({}, ...__VLS_functionalComponentArgsRest(__VLS_37));
// @ts-ignore
[auth, auth, logout,];
const __VLS_export = (await import('vue')).defineComponent({});
export default {};
