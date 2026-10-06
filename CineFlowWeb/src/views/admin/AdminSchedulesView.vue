<script setup lang="ts">
import { computed, onMounted, reactive, ref, watch } from "vue";
import { adminApi, movieApi } from "../../api";
import { errorMessage } from "../../api/http";
import type { Cinema, Movie, Schedule } from "../../types";

function toLocalInput(date: Date) {
  const local = new Date(date.getTime() - date.getTimezoneOffset() * 60000);
  return local.toISOString().slice(0, 16);
}
const tomorrow = new Date(Date.now() + 24 * 60 * 60 * 1000);
tomorrow.setHours(19, 30, 0, 0);

const movies = ref<Movie[]>([]);
const cinemas = ref<Cinema[]>([]);
const schedules = ref<Schedule[]>([]);
const loading = ref(true);
const submitting = ref(false);
const listLoading = ref(false);
const error = ref("");
const success = ref("");
const created = ref<Schedule | null>(null);
const form = reactive({ movieId: 0, cinemaId: 0, hallName: "1号厅", startTime: toLocalInput(tomorrow), endTime: toLocalInput(new Date(tomorrow.getTime() + 2 * 60 * 60 * 1000)), price: 45, rows: 5, seatsPerRow: 10 });
const seatTotal = computed(() => Number(form.rows) * Number(form.seatsPerRow));

async function loadOptions() {
  loading.value = true; error.value = "";
  try {
    const [movieResult, cinemaResult] = await Promise.all([movieApi.list({ pageNum: 1, pageSize: 100 }), movieApi.cinemas()]);
    movies.value = movieResult.data.data.list;
    cinemas.value = cinemaResult.data.data;
    if (!form.movieId && movies.value.length) form.movieId = movies.value[0].id;
    if (!form.cinemaId && cinemas.value.length) form.cinemaId = cinemas.value[0].id;
    await loadSchedules();
  } catch (e) { error.value = errorMessage(e); }
  finally { loading.value = false; }
}

async function loadSchedules() {
  if (!form.movieId) { schedules.value = []; return; }
  listLoading.value = true;
  try { schedules.value = (await movieApi.schedules(Number(form.movieId))).data.data; }
  catch (e) { error.value = errorMessage(e); }
  finally { listLoading.value = false; }
}

watch(() => form.startTime, (value) => {
  const start = new Date(value);
  if (!Number.isNaN(start.getTime())) form.endTime = toLocalInput(new Date(start.getTime() + 2 * 60 * 60 * 1000));
});

async function submit() {
  error.value = ""; success.value = ""; created.value = null;
  if (!form.movieId || !form.cinemaId || !form.hallName.trim()) { error.value = "请选择电影和影院，并填写影厅名称"; return; }
  if (new Date(form.endTime) <= new Date(form.startTime)) { error.value = "结束时间必须晚于开始时间"; return; }
  submitting.value = true;
  try {
    const result = await adminApi.createSchedule({
      movieId: Number(form.movieId), cinemaId: Number(form.cinemaId), hallName: form.hallName.trim(),
      startTime: form.startTime, endTime: form.endTime, price: Number(form.price), rows: Number(form.rows), seatsPerRow: Number(form.seatsPerRow)
    });
    created.value = result.data.data;
    success.value = `场次 #${created.value.id} 创建成功，已生成 ${seatTotal.value} 个座位`;
    await loadSchedules();
  } catch (e) { error.value = errorMessage(e); }
  finally { submitting.value = false; }
}
onMounted(loadOptions);
</script>

<template>
  <div data-testid="admin-schedules-page">
    <div class="admin-page-heading"><div><span class="eyebrow">SHOWTIMES</span><h1>场次管理</h1><p>为已上架电影安排影院、影厅、票价和座位布局</p></div></div>
    <p v-if="success" class="inline-alert success" role="status" data-testid="create-schedule-success">{{ success }}</p><p v-if="error" class="inline-alert error" role="alert" data-testid="create-schedule-error">{{ error }}</p>
    <div v-if="loading" class="admin-panel table-message">正在加载电影与影院数据…</div>
    <div v-else class="schedule-admin-layout">
      <section class="admin-form-panel sticky-form">
        <div class="panel-heading"><div><h2>创建新场次</h2><p>提交后将自动生成对应座位</p></div></div>
        <form class="admin-form" data-testid="create-schedule-form" @submit.prevent="submit">
          <label class="form-field"><span>选择电影 *</span><select v-model="form.movieId" data-testid="admin-schedule-movie" @change="loadSchedules"><option v-for="movie in movies" :key="movie.id" :value="movie.id">#{{ movie.id }} {{ movie.name }}</option></select></label>
          <label class="form-field"><span>选择影院 *</span><select v-model="form.cinemaId" data-testid="admin-schedule-cinema"><option v-for="cinema in cinemas" :key="cinema.id" :value="cinema.id">{{ cinema.name }}（{{ cinema.city }}）</option></select></label>
          <div class="form-row"><label class="form-field"><span>影厅名称 *</span><input v-model="form.hallName" data-testid="admin-schedule-hall" maxlength="64" /></label><label class="form-field"><span>票价 *</span><div class="input-prefix"><span>¥</span><input v-model="form.price" data-testid="admin-schedule-price" type="number" min="0.01" step="0.01" /></div></label></div>
          <div class="form-row"><label class="form-field"><span>开始时间 *</span><input v-model="form.startTime" data-testid="admin-schedule-start" type="datetime-local" /></label><label class="form-field"><span>结束时间 *</span><input v-model="form.endTime" data-testid="admin-schedule-end" type="datetime-local" /></label></div>
          <div class="seat-config"><div><strong>座位布局</strong><small>将生成 {{ seatTotal }} 个座位</small></div><label><span>排数</span><input v-model="form.rows" data-testid="admin-schedule-rows" type="number" min="1" max="26" /></label><span>×</span><label><span>每排</span><input v-model="form.seatsPerRow" data-testid="admin-schedule-seats-per-row" type="number" min="1" max="50" /></label></div>
          <button class="button button-primary button-block" data-testid="submit-create-schedule" :disabled="submitting || !movies.length || !cinemas.length">{{ submitting ? '正在创建场次…' : `创建场次并生成 ${seatTotal} 个座位` }}</button>
        </form>
      </section>
      <section class="admin-panel">
        <div class="panel-heading"><div><h2>当前电影的可售场次</h2><p>{{ movies.find(item => item.id === Number(form.movieId))?.name || '未选择电影' }}</p></div><button class="table-refresh" data-testid="refresh-schedules" @click="loadSchedules">↻ 刷新</button></div>
        <div v-if="listLoading" class="table-message">正在加载场次…</div><div v-else-if="!schedules.length" class="admin-empty">这部电影暂无未来可售场次</div>
        <div v-else class="admin-schedule-list" data-testid="admin-schedule-list"><article v-for="schedule in schedules" :key="schedule.id" :data-testid="`admin-schedule-card-${schedule.id}`"><div class="schedule-date"><strong>{{ new Date(schedule.startTime).getDate() }}</strong><span>{{ new Date(schedule.startTime).toLocaleDateString('zh-CN', { month: 'short' }) }}</span></div><div class="schedule-admin-info"><strong>{{ schedule.cinemaName }} · {{ schedule.hallName }}</strong><p>{{ new Date(schedule.startTime).toLocaleString('zh-CN') }} — {{ new Date(schedule.endTime).toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' }) }}</p></div><div class="schedule-admin-price">¥{{ Number(schedule.price).toFixed(2) }}</div><span class="table-status available">售票中</span></article></div>
      </section>
    </div>
  </div>
</template>
