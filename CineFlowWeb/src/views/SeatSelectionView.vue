<script setup lang="ts">
import { computed, onMounted, ref } from "vue";
import { useRoute, useRouter } from "vue-router";
import { movieApi, orderApi } from "../api";
import { errorMessage } from "../api/http";
import ErrorState from "../components/ErrorState.vue";
import LoadingState from "../components/LoadingState.vue";
import { useBookingStore } from "../stores/booking";
import type { Movie, Schedule, Seat } from "../types";

const route = useRoute();
const router = useRouter();
const booking = useBookingStore();
const movieId = Number(route.params.movieId);
const scheduleId = Number(route.params.scheduleId);
const movie = ref<Movie | null>(null);
const schedule = ref<Schedule | null>(null);
const seats = ref<Seat[]>([]);
const selectedIds = ref<number[]>([]);
const loading = ref(true);
const submitting = ref(false);
const error = ref("");
const actionError = ref("");

const rows = computed(() => {
  const result = new Map<string, Seat[]>();
  seats.value.forEach((seat) => {
    if (!result.has(seat.seatRow)) result.set(seat.seatRow, []);
    result.get(seat.seatRow)!.push(seat);
  });
  return [...result.entries()].map(([name, values]) => [name, values.sort((a, b) => a.seatNumber - b.seatNumber)] as const);
});
const selectedSeats = computed(() => seats.value.filter((seat) => selectedIds.value.includes(seat.id)));
const total = computed(() => selectedIds.value.length * Number(schedule.value?.price || 0));

async function load() {
  loading.value = true; error.value = "";
  try {
    const [movieResult, scheduleResult, seatResult] = await Promise.all([
      movieApi.detail(movieId), movieApi.schedules(movieId), movieApi.seats(scheduleId)
    ]);
    movie.value = movieResult.data.data;
    schedule.value = scheduleResult.data.data.find((item) => item.id === scheduleId) || null;
    if (!schedule.value) throw new Error("场次不存在或已停止售票");
    seats.value = seatResult.data.data;
  } catch (e) { error.value = errorMessage(e); }
  finally { loading.value = false; }
}

function toggleSeat(seat: Seat) {
  actionError.value = "";
  if (seat.status !== "AVAILABLE") return;
  if (selectedIds.value.includes(seat.id)) {
    selectedIds.value = selectedIds.value.filter((id) => id !== seat.id);
  } else if (selectedIds.value.length >= 8) {
    actionError.value = "一次最多选择8个座位";
  } else {
    selectedIds.value.push(seat.id);
  }
}

async function lockAndContinue() {
  actionError.value = "";
  if (!selectedIds.value.length) { actionError.value = "请至少选择一个座位"; return; }
  if (!movie.value || !schedule.value) return;
  submitting.value = true;
  try {
    const result = await orderApi.lock(scheduleId, selectedIds.value);
    booking.setSelection(movie.value, schedule.value, result.data.data.seats, result.data.data.expiresAt);
    await router.push("/checkout");
  } catch (e) {
    actionError.value = errorMessage(e);
    await load();
    selectedIds.value = [];
  } finally { submitting.value = false; }
}

onMounted(load);
</script>

<template>
  <div class="container page-content" data-testid="seat-selection-page">
    <LoadingState v-if="loading" />
    <ErrorState v-else-if="error" :message="error" @retry="load" />
    <template v-else-if="movie && schedule">
      <div class="breadcrumb"><RouterLink :to="`/movies/${movie.id}`">{{ movie.name }}</RouterLink><span>/</span><span>选择座位</span></div>
      <section class="booking-layout">
        <div class="seat-panel">
          <div class="booking-heading"><span class="eyebrow">SELECT SEATS</span><h1>选择你的座位</h1><p>{{ schedule.cinemaName }} · {{ schedule.hallName }}</p></div>
          <div class="screen"><span>银幕 SCREEN</span></div>
          <div class="seat-map" data-testid="seat-map">
            <div v-for="[rowName, rowSeats] in rows" :key="rowName" class="seat-row">
              <span class="row-label">{{ rowName }}</span>
              <button v-for="seat in rowSeats" :key="seat.id" type="button" class="seat"
                :class="[seat.status.toLowerCase(), { selected: selectedIds.includes(seat.id) }]"
                :disabled="seat.status !== 'AVAILABLE'" :aria-label="`${seat.seatCode} ${seat.status}`"
                :data-testid="`seat-${seat.id}`" @click="toggleSeat(seat)">{{ seat.seatNumber }}</button>
              <span class="row-label">{{ rowName }}</span>
            </div>
          </div>
          <div class="seat-legend"><span><i class="seat available"></i>可选</span><span><i class="seat selected"></i>已选</span><span><i class="seat locked"></i>已锁定</span><span><i class="seat sold"></i>已售</span></div>
        </div>
        <aside class="booking-summary" data-testid="booking-summary">
          <span class="eyebrow">YOUR ORDER</span><h2>{{ movie.name }}</h2>
          <dl><div><dt>影院</dt><dd>{{ schedule.cinemaName }}</dd></div><div><dt>影厅</dt><dd>{{ schedule.hallName }}</dd></div><div><dt>时间</dt><dd>{{ new Date(schedule.startTime).toLocaleString("zh-CN") }}</dd></div></dl>
          <div class="selected-seat-list"><span>已选座位</span><div><b v-for="seat in selectedSeats" :key="seat.id">{{ seat.seatCode }}</b><em v-if="!selectedSeats.length">尚未选择</em></div></div>
          <div class="price-total"><span>合计</span><strong>¥{{ total.toFixed(2) }}</strong></div>
          <p v-if="actionError" class="inline-alert error" role="alert" data-testid="seat-error">{{ actionError }}</p>
          <button class="button button-primary button-block" data-testid="lock-seats-submit" :disabled="submitting || !selectedIds.length" @click="lockAndContinue">{{ submitting ? "正在锁定…" : "锁定座位并继续" }}</button>
          <small class="summary-tip">座位锁定后请在规定时间内完成下单</small>
        </aside>
      </section>
    </template>
  </div>
</template>
