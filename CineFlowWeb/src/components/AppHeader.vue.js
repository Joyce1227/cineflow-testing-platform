import { ref } from "vue";
import { useRouter } from "vue-router";
import { useAuthStore } from "../stores/auth";
const auth = useAuthStore();
const router = useRouter();
const menuOpen = ref(false);
function logout() {
    auth.logout();
    menuOpen.value = false;
    router.push({ name: "home" });
}
const __VLS_ctx = {
    ...{},
    ...{},
};
let __VLS_components;
let __VLS_intrinsics;
let __VLS_directives;
__VLS_asFunctionalElement1(__VLS_intrinsics.header, __VLS_intrinsics.header)({
    ...{ class: "site-header" },
    'data-testid': "site-header",
});
/** @type {__VLS_StyleScopedClasses['site-header']} */ ;
__VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
    ...{ class: "container nav-wrap" },
});
/** @type {__VLS_StyleScopedClasses['container']} */ ;
/** @type {__VLS_StyleScopedClasses['nav-wrap']} */ ;
let __VLS_0;
/** @ts-ignore @type { | typeof __VLS_components.RouterLink | typeof __VLS_components.RouterLink} */
RouterLink;
// @ts-ignore
const __VLS_1 = __VLS_asFunctionalComponent1(__VLS_0, new __VLS_0({
    to: "/",
    ...{ class: "brand" },
    dataTestid: "nav-logo",
}));
const __VLS_2 = __VLS_1({
    to: "/",
    ...{ class: "brand" },
    dataTestid: "nav-logo",
}, ...__VLS_functionalComponentArgsRest(__VLS_1));
/** @type {__VLS_StyleScopedClasses['brand']} */ ;
const { default: __VLS_5 } = __VLS_3.slots;
__VLS_asFunctionalElement1(__VLS_intrinsics.i, __VLS_intrinsics.i)({});
var __VLS_3;
__VLS_asFunctionalElement1(__VLS_intrinsics.nav, __VLS_intrinsics.nav)({
    ...{ class: "main-nav" },
    'aria-label': "主导航",
});
/** @type {__VLS_StyleScopedClasses['main-nav']} */ ;
let __VLS_6;
/** @ts-ignore @type { | typeof __VLS_components.RouterLink | typeof __VLS_components.RouterLink} */
RouterLink;
// @ts-ignore
const __VLS_7 = __VLS_asFunctionalComponent1(__VLS_6, new __VLS_6({
    to: "/",
    dataTestid: "nav-movies",
}));
const __VLS_8 = __VLS_7({
    to: "/",
    dataTestid: "nav-movies",
}, ...__VLS_functionalComponentArgsRest(__VLS_7));
const { default: __VLS_11 } = __VLS_9.slots;
var __VLS_9;
let __VLS_12;
/** @ts-ignore @type { | typeof __VLS_components.RouterLink | typeof __VLS_components.RouterLink} */
RouterLink;
// @ts-ignore
const __VLS_13 = __VLS_asFunctionalComponent1(__VLS_12, new __VLS_12({
    to: "/recommendations",
    dataTestid: "nav-recommendations",
}));
const __VLS_14 = __VLS_13({
    to: "/recommendations",
    dataTestid: "nav-recommendations",
}, ...__VLS_functionalComponentArgsRest(__VLS_13));
const { default: __VLS_17 } = __VLS_15.slots;
var __VLS_15;
if (__VLS_ctx.auth.isLoggedIn) {
    let __VLS_18;
    /** @ts-ignore @type { | typeof __VLS_components.RouterLink | typeof __VLS_components.RouterLink} */
    RouterLink;
    // @ts-ignore
    const __VLS_19 = __VLS_asFunctionalComponent1(__VLS_18, new __VLS_18({
        to: "/orders",
        dataTestid: "nav-orders",
    }));
    const __VLS_20 = __VLS_19({
        to: "/orders",
        dataTestid: "nav-orders",
    }, ...__VLS_functionalComponentArgsRest(__VLS_19));
    const { default: __VLS_23 } = __VLS_21.slots;
    // @ts-ignore
    [auth,];
    var __VLS_21;
}
__VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
    ...{ class: "nav-actions" },
});
/** @type {__VLS_StyleScopedClasses['nav-actions']} */ ;
if (__VLS_ctx.auth.isLoggedIn) {
    __VLS_asFunctionalElement1(__VLS_intrinsics.button, __VLS_intrinsics.button)({
        ...{ onClick: (...[$event]) => {
                if (!(__VLS_ctx.auth.isLoggedIn))
                    throw 0;
                return (__VLS_ctx.menuOpen = !__VLS_ctx.menuOpen);
                // @ts-ignore
                [auth, menuOpen, menuOpen,];
            } },
        ...{ class: "user-button" },
        'data-testid': "user-menu-button",
    });
    /** @type {__VLS_StyleScopedClasses['user-button']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({
        ...{ class: "avatar" },
    });
    /** @type {__VLS_StyleScopedClasses['avatar']} */ ;
    (__VLS_ctx.auth.user?.username.slice(0, 1).toUpperCase());
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
    (__VLS_ctx.auth.user?.username);
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({
        'aria-hidden': "true",
    });
    if (__VLS_ctx.menuOpen) {
        __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
            ...{ class: "user-menu" },
            'data-testid': "user-menu",
        });
        /** @type {__VLS_StyleScopedClasses['user-menu']} */ ;
        if (__VLS_ctx.auth.user?.role === 'ADMIN') {
            let __VLS_24;
            /** @ts-ignore @type { | typeof __VLS_components.RouterLink | typeof __VLS_components.RouterLink} */
            RouterLink;
            // @ts-ignore
            const __VLS_25 = __VLS_asFunctionalComponent1(__VLS_24, new __VLS_24({
                ...{ 'onClick': {} },
                to: "/admin",
                dataTestid: "admin-console-link",
            }));
            const __VLS_26 = __VLS_25({
                ...{ 'onClick': {} },
                to: "/admin",
                dataTestid: "admin-console-link",
            }, ...__VLS_functionalComponentArgsRest(__VLS_25));
            let __VLS_29;
            const __VLS_30 = {
                /** @type {typeof __VLS_29.click} */
                onClick: (...[$event]) => {
                    if (!(__VLS_ctx.auth.isLoggedIn))
                        throw 0;
                    if (!(__VLS_ctx.menuOpen))
                        throw 0;
                    if (!(__VLS_ctx.auth.user?.role === 'ADMIN'))
                        throw 0;
                    return (__VLS_ctx.menuOpen = false);
                    // @ts-ignore
                    [auth, auth, auth, menuOpen, menuOpen,];
                },
            };
            const { default: __VLS_31 } = __VLS_27.slots;
            // @ts-ignore
            [];
            var __VLS_27;
            var __VLS_28;
        }
        let __VLS_32;
        /** @ts-ignore @type { | typeof __VLS_components.RouterLink | typeof __VLS_components.RouterLink} */
        RouterLink;
        // @ts-ignore
        const __VLS_33 = __VLS_asFunctionalComponent1(__VLS_32, new __VLS_32({
            ...{ 'onClick': {} },
            to: "/orders",
        }));
        const __VLS_34 = __VLS_33({
            ...{ 'onClick': {} },
            to: "/orders",
        }, ...__VLS_functionalComponentArgsRest(__VLS_33));
        let __VLS_37;
        const __VLS_38 = {
            /** @type {typeof __VLS_37.click} */
            onClick: (...[$event]) => {
                if (!(__VLS_ctx.auth.isLoggedIn))
                    throw 0;
                if (!(__VLS_ctx.menuOpen))
                    throw 0;
                return (__VLS_ctx.menuOpen = false);
                // @ts-ignore
                [menuOpen,];
            },
        };
        const { default: __VLS_39 } = __VLS_35.slots;
        // @ts-ignore
        [];
        var __VLS_35;
        var __VLS_36;
        __VLS_asFunctionalElement1(__VLS_intrinsics.button, __VLS_intrinsics.button)({
            ...{ onClick: (__VLS_ctx.logout) },
            'data-testid': "logout-button",
        });
    }
}
else {
    let __VLS_40;
    /** @ts-ignore @type { | typeof __VLS_components.RouterLink | typeof __VLS_components.RouterLink} */
    RouterLink;
    // @ts-ignore
    const __VLS_41 = __VLS_asFunctionalComponent1(__VLS_40, new __VLS_40({
        to: "/login",
        ...{ class: "text-link" },
        dataTestid: "nav-login",
    }));
    const __VLS_42 = __VLS_41({
        to: "/login",
        ...{ class: "text-link" },
        dataTestid: "nav-login",
    }, ...__VLS_functionalComponentArgsRest(__VLS_41));
    /** @type {__VLS_StyleScopedClasses['text-link']} */ ;
    const { default: __VLS_45 } = __VLS_43.slots;
    // @ts-ignore
    [logout,];
    var __VLS_43;
    let __VLS_46;
    /** @ts-ignore @type { | typeof __VLS_components.RouterLink | typeof __VLS_components.RouterLink} */
    RouterLink;
    // @ts-ignore
    const __VLS_47 = __VLS_asFunctionalComponent1(__VLS_46, new __VLS_46({
        to: "/register",
        ...{ class: "button button-primary button-small" },
        dataTestid: "nav-register",
    }));
    const __VLS_48 = __VLS_47({
        to: "/register",
        ...{ class: "button button-primary button-small" },
        dataTestid: "nav-register",
    }, ...__VLS_functionalComponentArgsRest(__VLS_47));
    /** @type {__VLS_StyleScopedClasses['button']} */ ;
    /** @type {__VLS_StyleScopedClasses['button-primary']} */ ;
    /** @type {__VLS_StyleScopedClasses['button-small']} */ ;
    const { default: __VLS_51 } = __VLS_49.slots;
    // @ts-ignore
    [];
    var __VLS_49;
}
// @ts-ignore
[];
const __VLS_export = (await import('vue')).defineComponent({});
export default {};
