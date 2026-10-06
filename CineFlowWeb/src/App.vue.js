import { computed, onBeforeUnmount, onMounted } from "vue";
import { useRoute, useRouter } from "vue-router";
import AppHeader from "./components/AppHeader.vue";
import { useAuthStore } from "./stores/auth";
const auth = useAuthStore();
const router = useRouter();
const route = useRoute();
const isAdminPage = computed(() => Boolean(route.meta.admin));
const onUnauthorized = () => {
    auth.logout();
    if (router.currentRoute.value.name !== "login") {
        router.push({ name: "login", query: { expired: "1", redirect: router.currentRoute.value.fullPath } });
    }
};
onMounted(() => window.addEventListener("cineflow:unauthorized", onUnauthorized));
onBeforeUnmount(() => window.removeEventListener("cineflow:unauthorized", onUnauthorized));
const __VLS_ctx = {
    ...{},
    ...{},
};
let __VLS_components;
let __VLS_intrinsics;
let __VLS_directives;
__VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
    ...{ class: "app-shell" },
});
/** @type {__VLS_StyleScopedClasses['app-shell']} */ ;
if (!__VLS_ctx.isAdminPage) {
    const __VLS_0 = AppHeader;
    // @ts-ignore
    const __VLS_1 = __VLS_asFunctionalComponent1(__VLS_0, new __VLS_0({}));
    const __VLS_2 = __VLS_1({}, ...__VLS_functionalComponentArgsRest(__VLS_1));
}
__VLS_asFunctionalElement1(__VLS_intrinsics.main, __VLS_intrinsics.main)({});
let __VLS_5;
/** @ts-ignore @type { | typeof __VLS_components.RouterView} */
RouterView;
// @ts-ignore
const __VLS_6 = __VLS_asFunctionalComponent1(__VLS_5, new __VLS_5({}));
const __VLS_7 = __VLS_6({}, ...__VLS_functionalComponentArgsRest(__VLS_6));
if (!__VLS_ctx.isAdminPage) {
    __VLS_asFunctionalElement1(__VLS_intrinsics.footer, __VLS_intrinsics.footer)({
        ...{ class: "footer" },
    });
    /** @type {__VLS_StyleScopedClasses['footer']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.div, __VLS_intrinsics.div)({
        ...{ class: "container footer-inner" },
    });
    /** @type {__VLS_StyleScopedClasses['container']} */ ;
    /** @type {__VLS_StyleScopedClasses['footer-inner']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({
        ...{ class: "brand brand-small" },
    });
    /** @type {__VLS_StyleScopedClasses['brand']} */ ;
    /** @type {__VLS_StyleScopedClasses['brand-small']} */ ;
    __VLS_asFunctionalElement1(__VLS_intrinsics.i, __VLS_intrinsics.i)({});
    __VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({});
}
// @ts-ignore
[isAdminPage, isAdminPage,];
const __VLS_export = (await import('vue')).defineComponent({});
export default {};
