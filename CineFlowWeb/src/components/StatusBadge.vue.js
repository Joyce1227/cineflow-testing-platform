const props = defineProps();
const labels = {
    PENDING_PAYMENT: "待支付", PAID: "已支付", CANCELLED: "已取消", REFUNDED: "已退款",
    EXPIRED: "已过期", PAYMENT_FAILED: "支付失败", AVAILABLE: "可选", LOCKED: "已锁定", SOLD: "已售"
};
const __VLS_ctx = {
    ...{},
    ...{},
    ...{},
    ...{},
};
let __VLS_components;
let __VLS_intrinsics;
let __VLS_directives;
__VLS_asFunctionalElement1(__VLS_intrinsics.span, __VLS_intrinsics.span)({
    ...{ class: "status-badge" },
    ...{ class: (`status-${__VLS_ctx.status.toLowerCase()}`) },
    'data-testid': (`status-${__VLS_ctx.status}`),
});
/** @type {__VLS_StyleScopedClasses['status-badge']} */ ;
(__VLS_ctx.labels[props.status] || props.status);
// @ts-ignore
[status, status, labels,];
const __VLS_export = (await import('vue')).defineComponent({
    __typeProps: {},
});
export default {};
