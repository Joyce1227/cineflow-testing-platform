<script setup lang="ts">
import { onMounted, ref } from "vue";
import { adminApi, movieApi, statApi } from "../../api";
import { errorMessage } from "../../api/http";
import LoadingState from "../../components/LoadingState.vue";
import type { ActorStat, MinsSummary, Movie } from "../../types";

const loading = ref(true);
const error = ref("");
const health = ref("UNKNOWN");
const movieTotal = ref(0);
const cinemaTotal = ref(0);
const highScoreAverage = ref(0);
const mins = ref<MinsSummary>({ totalMins: 0, averageMins: 0, minMins: 0, maxMins: 0 });
const actors = ref<ActorStat[]>([]);
const recentMovies = ref<Movie[]>([]);

async function load() {
  loading.value = true; error.value = "";
  try {
    const [healthResult, movieResult, cinemaResult, scoreResult, minsResult, actorResult] = await Promise.all([
      adminApi.health(), movieApi.list({ pageNum: 1, pageSize: 6 }), movieApi.cinemas(),
      statApi.highScore(), statApi.mins(), statApi.actors()
    ]);
    health.value = healthResult.data.data.status;
    movieTotal.value = movieResult.data.data.total;
    recentMovies.value = movieResult.data.data.list;
    cinemaTotal.value = cinemaResult.data.data.length;
    highScoreAverage.value = Number(scoreResult.data.data.averageScore || 0);
    mins.value = minsResult.data.data;
    actors.value = actorResult.data.data.slice(0, 6);
  } catch (e) { error.value = errorMessage(e); }
  finally { loading.value = false; }
}

function barWidth(count: number) {
  const max = Math.max(...actors.value.map(item => item.actedMovieCnt), 1);
  return `${Math.max((count / max) * 100, 4)}%`;
}
onMounted(load);
</script>

<template>
  <div data-testid="admin-dashboard-page">
    <div class="admin-page-heading"><div><span class="eyebrow">OVERVIEW</span><h1>运营控制台</h1><p>查看 CineFlow 当前内容与系统运行概况</p></div><button class="button button-secondary" data-testid="dashboard-refresh" :disabled="loading" @click="load">刷新数据</button></div>
    <LoadingState v-if="loading" />
    <template v-else>
      <p v-if="error" class="inline-alert error" role="alert" data-testid="dashboard-error">{{ error }}</p>
      <section class="metric-grid">
        <article class="metric-card" data-testid="metric-health"><span>API服务</span><strong :class="{ online: health === 'UP' }">{{ health === 'UP' ? '运行正常' : '状态异常' }}</strong><small><i class="system-dot"></i> FastAPI service</small></article>
        <article class="metric-card" data-testid="metric-movies"><span>可管理电影</span><strong>{{ movieTotal }}</strong><small>Movie records</small></article>
        <article class="metric-card" data-testid="metric-cinemas"><span>营业影院</span><strong>{{ cinemaTotal }}</strong><small>Cinema locations</small></article>
        <article class="metric-card" data-testid="metric-score"><span>高分电影均分</span><strong>{{ highScoreAverage.toFixed(2) }}</strong><small>Score ≥ 8.0</small></article>
      </section>

      <section class="admin-dashboard-grid">
        <article class="admin-panel">
          <div class="panel-heading"><div><h2>电影数据概览</h2><p>片长统计与近期电影</p></div><RouterLink to="/admin/movies">管理电影 →</RouterLink></div>
          <div class="mini-metrics"><div><span>平均片长</span><strong>{{ Number(mins.averageMins).toFixed(0) }}<small> min</small></strong></div><div><span>最短片长</span><strong>{{ mins.minMins }}<small> min</small></strong></div><div><span>最长片长</span><strong>{{ mins.maxMins }}<small> min</small></strong></div></div>
          <div class="admin-table-wrap"><table class="admin-table" data-testid="dashboard-movie-table"><thead><tr><th>电影</th><th>类型</th><th>年份</th><th>评分</th><th>状态</th></tr></thead><tbody><tr v-for="movie in recentMovies" :key="movie.id"><td><strong>{{ movie.name }}</strong></td><td>{{ movie.genres || '-' }}</td><td>{{ movie.releaseYear || '-' }}</td><td>{{ Number(movie.score).toFixed(1) }}</td><td><span class="table-status" :class="movie.status.toLowerCase()">{{ movie.status === 'AVAILABLE' ? '可售' : '下架' }}</span></td></tr></tbody></table></div>
        </article>
        <article class="admin-panel">
          <div class="panel-heading"><div><h2>演员作品数</h2><p>聚合统计 Top 6</p></div></div>
          <div v-if="actors.length" class="bar-list" data-testid="actor-stat-chart"><div v-for="(actor, index) in actors" :key="actor.personName" class="bar-item"><span class="bar-rank">{{ String(index + 1).padStart(2, '0') }}</span><div><div class="bar-label"><strong>{{ actor.personName }}</strong><span>{{ actor.actedMovieCnt }} 部</span></div><div class="bar-track"><i :style="{ width: barWidth(actor.actedMovieCnt) }"></i></div></div></div></div>
          <div v-else class="admin-empty">统计表暂时没有数据</div>
        </article>
      </section>
    </template>
  </div>
</template>
