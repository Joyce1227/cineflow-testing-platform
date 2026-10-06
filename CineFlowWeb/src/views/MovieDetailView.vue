<script setup lang="ts">
import { computed, onMounted, ref } from "vue";
import { useRoute, useRouter } from "vue-router";
import { movieApi, reviewApi } from "../api";
import { errorMessage } from "../api/http";
import EmptyState from "../components/EmptyState.vue";
import ErrorState from "../components/ErrorState.vue";
import LoadingState from "../components/LoadingState.vue";
import { useAuthStore } from "../stores/auth";
import type { Movie, Review, Schedule } from "../types";

const route = useRoute();
const router = useRouter();
const auth = useAuthStore();
const movieId = computed(() => Number(route.params.id));
const movie = ref<Movie | null>(null);
const schedules = ref<Schedule[]>([]);
const reviews = ref<Review[]>([]);
const loading = ref(true);
const error = ref("");

function formatTime(value: string) {
  return new Intl.DateTimeFormat("zh-CN", { month: "2-digit", day: "2-digit", hour: "2-digit", minute: "2-digit", hour12: false }).format(new Date(value));
}

async function load() {
  loading.value = true; error.value = "";
  try {
    const [detail, shows, reviewResult] = await Promise.all([
      movieApi.detail(movieId.value), movieApi.schedules(movieId.value), reviewApi.list(movieId.value)
    ]);
    movie.value = detail.data.data;
    schedules.value = shows.data.data;
    reviews.value = reviewResult.data.data.list;
  } catch (e) { error.value = errorMessage(e); }
  finally { loading.value = false; }
}

function chooseSchedule(schedule: Schedule) {
  if (!auth.isLoggedIn) {
    router.push({ name: "login", query: { redirect: `/movies/${movieId.value}/schedules/${schedule.id}/seats` } });
  } else {
    router.push(`/movies/${movieId.value}/schedules/${schedule.id}/seats`);
  }
}

onMounted(load);
</script>

<template>
  <div class="container page-content" data-testid="movie-detail-page">
    <LoadingState v-if="loading" />
    <ErrorState v-else-if="error" :message="error" @retry="load" />
    <template v-else-if="movie">
      <section class="movie-hero-detail">
        <div class="detail-poster"><img v-if="movie.cover" :src="movie.cover" :alt="movie.name" /><div v-else class="poster-fallback detail-fallback"><span>{{ movie.name }}</span><small>CINEFLOW</small></div></div>
        <div class="detail-copy">
          <span class="eyebrow">MOVIE DETAIL</span>
          <h1 data-testid="movie-name">{{ movie.name }}</h1>
          <p class="movie-meta">{{ movie.releaseYear || "年份待定" }} · {{ movie.regions || "地区待定" }} · {{ movie.mins ? `${movie.mins}分钟` : "片长待定" }}</p>
          <div class="detail-score"><strong>{{ Number(movie.score || 0).toFixed(1) }}</strong><span>观众评分<br />{{ movie.ratingCount || 0 }} 人评价</span></div>
          <p class="tags"><span v-for="item in (movie.genres || '').split('/').filter(Boolean)" :key="item">{{ item }}</span></p>
          <dl class="movie-facts"><div><dt>导演</dt><dd>{{ movie.directors || "暂无资料" }}</dd></div><div><dt>主演</dt><dd>{{ movie.actors || "暂无资料" }}</dd></div></dl>
          <p class="storyline">{{ movie.storyline || "影片简介正在整理中，敬请期待。" }}</p>
        </div>
      </section>

      <section class="content-section">
        <div class="section-heading"><div><span class="eyebrow">SHOWTIMES</span><h2>选择场次</h2></div></div>
        <EmptyState v-if="!schedules.length" title="暂无可售场次" description="请稍后再来看看" />
        <div v-else class="schedule-list" data-testid="schedule-list">
          <article v-for="schedule in schedules" :key="schedule.id" class="schedule-item" :data-testid="`schedule-${schedule.id}`">
            <div><strong>{{ formatTime(schedule.startTime) }}</strong><span>至 {{ formatTime(schedule.endTime) }}</span></div>
            <div><strong>{{ schedule.cinemaName }}</strong><span>{{ schedule.hallName }}</span></div>
            <div class="schedule-price">¥{{ Number(schedule.price).toFixed(2) }}</div>
            <button class="button button-primary" :data-testid="`choose-schedule-${schedule.id}`" @click="chooseSchedule(schedule)">选座购票</button>
          </article>
        </div>
      </section>

      <section class="content-section">
        <div class="section-heading"><div><span class="eyebrow">REVIEWS</span><h2>观众评价</h2></div></div>
        <EmptyState v-if="!reviews.length" title="还没有评价" description="购买并观看后，来分享你的感受吧" />
        <div v-else class="review-list" data-testid="review-list">
          <article v-for="review in reviews" :key="review.id" class="review-card">
            <div class="review-head"><strong>{{ review.username }}</strong><span>{{ review.rating.toFixed(1) }} / 10</span></div>
            <p>{{ review.content }}</p><time>{{ new Date(review.createdAt).toLocaleString("zh-CN") }}</time>
          </article>
        </div>
      </section>
    </template>
  </div>
</template>
