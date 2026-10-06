<script setup lang="ts">
import { computed, onMounted, reactive, ref } from "vue";
import { useRoute } from "vue-router";
import { orderApi, reviewApi } from "../api";
import { errorMessage } from "../api/http";
import ErrorState from "../components/ErrorState.vue";
import LoadingState from "../components/LoadingState.vue";
import StatusBadge from "../components/StatusBadge.vue";
import type { Order } from "../types";
import { orderMovieId } from "../utils/orderMeta";

const route = useRoute();
const orderId = Number(route.params.id);
const order = ref<Order | null>(null);
const loading = ref(true);
const actionLoading = ref(false);
const error = ref("");
const success = ref(route.query.created === "1" ? "订单创建成功，请及时完成支付" : "");
const modalAction = ref<"cancel" | "refund" | null>(null);
const movieId = computed(() => orderMovieId(orderId));
const review = reactive({ rating: 8, content: "" });
const reviewError = ref("");
const reviewSuccess = ref("");

async function load() {
  loading.value = true; error.value = "";
  try { order.value = (await orderApi.detail(orderId)).data.data; }
  catch (e) { error.value = errorMessage(e); }
  finally { loading.value = false; }
}

async function pay() {
  if (!order.value) return;
  actionLoading.value = true; error.value = ""; success.value = "";
  try {
    const tradeNo = `WEBPAY-${Date.now()}-${order.value.id}`;
    order.value = (await orderApi.pay(order.value.id, tradeNo)).data.data;
    success.value = "支付成功，座位已出票";
  } catch (e) { error.value = errorMessage(e); }
  finally { actionLoading.value = false; }
}

async function confirmAction() {
  if (!order.value || !modalAction.value) return;
  actionLoading.value = true; error.value = ""; success.value = "";
  try {
    order.value = modalAction.value === "cancel"
      ? (await orderApi.cancel(order.value.id)).data.data
      : (await orderApi.refund(order.value.id)).data.data;
    success.value = modalAction.value === "cancel" ? "订单已取消，座位已经释放" : "退款成功，座位已经释放";
    modalAction.value = null;
  } catch (e) { error.value = errorMessage(e); modalAction.value = null; }
  finally { actionLoading.value = false; }
}

async function submitReview() {
  reviewError.value = ""; reviewSuccess.value = "";
  if (!movieId.value) { reviewError.value = "当前订单缺少电影信息，请从购票流程进入后再评价"; return; }
  if (!review.content.trim()) { reviewError.value = "请输入评价内容"; return; }
  actionLoading.value = true;
  try {
    await reviewApi.save(movieId.value, { rating: Number(review.rating), content: review.content.trim() });
    reviewSuccess.value = "评价发布成功";
    review.content = "";
  } catch (e) { reviewError.value = errorMessage(e); }
  finally { actionLoading.value = false; }
}

onMounted(load);
</script>

<template>
  <div class="container narrow-page page-content" data-testid="order-detail-page">
    <LoadingState v-if="loading" />
    <ErrorState v-else-if="error && !order" :message="error" @retry="load" />
    <template v-else-if="order">
      <div class="breadcrumb"><RouterLink to="/orders">我的订单</RouterLink><span>/</span><span>订单详情</span></div>
      <div class="order-detail-heading"><div><span class="eyebrow">ORDER DETAIL</span><h1>订单详情</h1></div><StatusBadge :status="order.status" /></div>
      <p v-if="success" class="inline-alert success" role="status" data-testid="order-success">{{ success }}</p>
      <p v-if="error" class="inline-alert error" role="alert" data-testid="order-action-error">{{ error }}</p>
      <section class="ticket-detail-card">
        <div class="ticket-top"><div><span>订单号</span><strong data-testid="order-number">{{ order.orderNo }}</strong></div><div class="ticket-logo">CINEFLOW</div></div>
        <div class="ticket-info-grid"><div><span>场次编号</span><strong>#{{ order.scheduleId }}</strong></div><div><span>创建时间</span><strong>{{ new Date(order.createdAt).toLocaleString("zh-CN") }}</strong></div><div><span>座位</span><strong>{{ order.seats.map(s => s.seatCode).join('、') }}</strong></div><div><span>票数</span><strong>{{ order.seats.length }} 张</strong></div></div>
        <div class="ticket-bottom"><span>订单金额</span><strong>¥{{ Number(order.totalAmount).toFixed(2) }}</strong></div>
      </section>
      <div class="order-actions" data-testid="order-actions">
        <button v-if="order.status === 'PENDING_PAYMENT'" class="button button-primary" data-testid="pay-order" :disabled="actionLoading" @click="pay">{{ actionLoading ? "处理中…" : "模拟支付" }}</button>
        <button v-if="order.status === 'PENDING_PAYMENT'" class="button button-danger" data-testid="cancel-order" :disabled="actionLoading" @click="modalAction = 'cancel'">取消订单</button>
        <button v-if="order.status === 'PAID'" class="button button-danger" data-testid="refund-order" :disabled="actionLoading" @click="modalAction = 'refund'">申请退款</button>
        <RouterLink to="/orders" class="button button-secondary">返回订单列表</RouterLink>
      </div>

      <section v-if="order.status === 'PAID' && movieId" class="review-form-section" data-testid="review-form-section">
        <div class="section-heading"><div><span class="eyebrow">RATE THIS MOVIE</span><h2>发表观影评价</h2></div></div>
        <form class="review-form" @submit.prevent="submitReview">
          <label class="form-field"><span>评分：{{ review.rating }} 分</span><input v-model="review.rating" data-testid="review-rating" type="range" min="1" max="10" step="0.5" /></label>
          <label class="form-field"><span>评价内容</span><textarea v-model="review.content" data-testid="review-content" maxlength="1000" rows="4" placeholder="分享你的观影感受…"></textarea></label>
          <p v-if="reviewError" class="inline-alert error" role="alert" data-testid="review-error">{{ reviewError }}</p>
          <p v-if="reviewSuccess" class="inline-alert success" role="status" data-testid="review-success">{{ reviewSuccess }}</p>
          <button class="button button-primary" data-testid="review-submit" :disabled="actionLoading">提交评价</button>
        </form>
      </section>

      <div v-if="modalAction" class="modal-backdrop" data-testid="confirm-modal" @click.self="modalAction = null">
        <div class="confirm-modal" role="dialog" aria-modal="true" aria-labelledby="confirm-title">
          <div class="modal-symbol">?</div><h2 id="confirm-title">确认{{ modalAction === 'cancel' ? '取消订单' : '申请退款' }}？</h2>
          <p>{{ modalAction === 'cancel' ? '取消后座位将立即释放，操作不可撤销。' : '退款后订单将关闭，对应座位会重新开放。' }}</p>
          <div><button class="button button-ghost" data-testid="confirm-dismiss" @click="modalAction = null">暂不操作</button><button class="button button-danger" data-testid="confirm-action" :disabled="actionLoading" @click="confirmAction">确认{{ modalAction === 'cancel' ? '取消' : '退款' }}</button></div>
        </div>
      </div>
    </template>
  </div>
</template>
