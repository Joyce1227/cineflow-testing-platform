<script setup lang="ts">
import { computed, ref } from "vue";
import { useRouter } from "vue-router";
import { orderApi } from "../api";
import { errorMessage } from "../api/http";
import EmptyState from "../components/EmptyState.vue";
import { useBookingStore } from "../stores/booking";
import { rememberOrderMovie } from "../utils/orderMeta";

const booking = useBookingStore();
const router = useRouter();
const loading = ref(false);
const error = ref("");
const agreed = ref(true);
const total = computed(() => booking.seats.reduce((sum, seat) => sum + Number(booking.schedule?.price || 0), 0));

function idempotencyKey() {
  const storageKey = `cineflow_checkout_key_${booking.schedule?.id || 0}`;
  let value = sessionStorage.getItem(storageKey);
  if (!value) {
    value = `web-${Date.now()}-${Math.random().toString(16).slice(2)}`;
    sessionStorage.setItem(storageKey, value);
  }
  return value;
}

async function createOrder() {
  error.value = "";
  if (!agreed.value) { error.value = "请先同意购票须知"; return; }
  if (!booking.schedule || !booking.movie || !booking.seats.length) return;
  loading.value = true;
  try {
    const result = await orderApi.create({
      scheduleId: booking.schedule.id,
      seatIds: booking.seats.map((seat) => seat.id),
      idempotencyKey: idempotencyKey()
    });
    rememberOrderMovie(result.data.data.id, booking.movie.id);
    booking.clear();
    await router.replace(`/orders/${result.data.data.id}?created=1`);
  } catch (e) { error.value = errorMessage(e); }
  finally { loading.value = false; }
}
</script>

<template>
  <div class="container narrow-page page-content" data-testid="checkout-page">
    <EmptyState v-if="!booking.schedule || !booking.movie || !booking.seats.length" title="没有待确认的座位" description="请先选择电影场次和座位">
      <RouterLink to="/" class="button button-primary">去选电影</RouterLink>
    </EmptyState>
    <template v-else>
      <div class="page-title"><span class="eyebrow">CHECKOUT</span><h1>确认订单</h1><p>请核对场次与座位信息，提交后将在15分钟内保留订单。</p></div>
      <section class="checkout-card">
        <div class="checkout-movie"><div class="mini-poster">{{ booking.movie.name.slice(0, 1) }}</div><div><h2>{{ booking.movie.name }}</h2><p>{{ booking.movie.genres }}</p></div></div>
        <div class="checkout-grid"><div><span>影院</span><strong>{{ booking.schedule.cinemaName }}</strong></div><div><span>影厅</span><strong>{{ booking.schedule.hallName }}</strong></div><div><span>开场时间</span><strong>{{ new Date(booking.schedule.startTime).toLocaleString("zh-CN") }}</strong></div><div><span>座位</span><strong data-testid="checkout-seats">{{ booking.seats.map(s => s.seatCode).join('、') }}</strong></div></div>
        <div class="checkout-total"><span>{{ booking.seats.length }} 张电影票</span><strong>应付 ¥{{ total.toFixed(2) }}</strong></div>
      </section>
      <label class="check-line"><input v-model="agreed" data-testid="purchase-agreement" type="checkbox" />我已阅读并同意购票须知，确认场次和座位信息无误</label>
      <p v-if="error" class="inline-alert error" role="alert" data-testid="checkout-error">{{ error }}</p>
      <button class="button button-primary button-block large-action" data-testid="create-order-submit" :disabled="loading" @click="createOrder">{{ loading ? "正在创建订单…" : `提交订单 · ¥${total.toFixed(2)}` }}</button>
    </template>
  </div>
</template>
