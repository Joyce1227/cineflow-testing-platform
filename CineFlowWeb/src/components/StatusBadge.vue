<script setup lang="ts">
const props = defineProps<{ status: string }>();
const labels: Record<string, string> = {
  PENDING_PAYMENT: "待支付", PAID: "已支付", CANCELLED: "已取消", REFUNDED: "已退款",
  EXPIRED: "已过期", PAYMENT_FAILED: "支付失败", AVAILABLE: "可选", LOCKED: "已锁定", SOLD: "已售"
};
</script>

<template>
  <span class="status-badge" :class="`status-${status.toLowerCase()}`" :data-testid="`status-${status}`">
    {{ labels[props.status] || props.status }}
  </span>
</template>
