<script setup lang="ts">
import { computed, onMounted, ref } from "vue";
import { orderApi } from "../api";
import { errorMessage } from "../api/http";
import EmptyState from "../components/EmptyState.vue";
import ErrorState from "../components/ErrorState.vue";
import LoadingState from "../components/LoadingState.vue";
import StatusBadge from "../components/StatusBadge.vue";
import type { Order } from "../types";

const orders = ref<Order[]>([]);
const loading = ref(true);
const error = ref("");
const activeStatus = ref("ALL");
const statuses = [{ value: "ALL", label: "全部" }, { value: "PENDING_PAYMENT", label: "待支付" }, { value: "PAID", label: "已支付" }, { value: "CANCELLED", label: "已取消" }, { value: "REFUNDED", label: "已退款" }];
const filtered = computed(() => activeStatus.value === "ALL" ? orders.value : orders.value.filter((order) => order.status === activeStatus.value));

async function load() {
  loading.value = true; error.value = "";
  try { orders.value = (await orderApi.list()).data.data; }
  catch (e) { error.value = errorMessage(e); }
  finally { loading.value = false; }
}
onMounted(load);
</script>

<template>
  <div class="container page-content" data-testid="orders-page">
    <div class="page-title"><span class="eyebrow">MY TICKETS</span><h1>我的订单</h1><p>查看并管理你的电影票订单</p></div>
    <div class="order-tabs" role="tablist" data-testid="order-status-tabs"><button v-for="status in statuses" :key="status.value" :class="{ active: activeStatus === status.value }" :data-testid="`order-tab-${status.value}`" @click="activeStatus = status.value">{{ status.label }}</button></div>
    <LoadingState v-if="loading" />
    <ErrorState v-else-if="error" :message="error" @retry="load" />
    <EmptyState v-else-if="!filtered.length" title="暂无订单" description="当前分类下还没有电影票订单"><RouterLink to="/" class="button button-primary">去选电影</RouterLink></EmptyState>
    <div v-else class="order-list" data-testid="order-list">
      <article v-for="order in filtered" :key="order.id" class="order-card" :data-testid="`order-card-${order.id}`">
        <div class="order-card-head"><span>订单号 {{ order.orderNo }}</span><StatusBadge :status="order.status" /></div>
        <div class="order-card-body"><div class="ticket-mark">CF</div><div class="order-main"><strong>场次 #{{ order.scheduleId }}</strong><p>{{ new Date(order.createdAt).toLocaleString("zh-CN") }} 创建</p><p>座位：{{ order.seats.map(s => s.seatCode).join('、') }}</p></div><div class="order-amount">¥{{ Number(order.totalAmount).toFixed(2) }}</div><RouterLink :to="`/orders/${order.id}`" class="button button-secondary" :data-testid="`order-detail-${order.id}`">查看详情</RouterLink></div>
      </article>
    </div>
  </div>
</template>
