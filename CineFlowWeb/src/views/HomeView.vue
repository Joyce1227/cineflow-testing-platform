<script setup lang="ts">
import { onMounted, reactive, ref } from "vue";
import { movieApi } from "../api";
import { errorMessage } from "../api/http";
import EmptyState from "../components/EmptyState.vue";
import ErrorState from "../components/ErrorState.vue";
import LoadingState from "../components/LoadingState.vue";
import MovieCard from "../components/MovieCard.vue";
import type { Movie, PageResult } from "../types";

const hotMovies = ref<Movie[]>([]);
const movies = ref<PageResult<Movie>>({ list: [], pageNum: 1, pageSize: 8, total: 0, totalPages: 0 });
const loading = ref(true);
const listLoading = ref(false);
const error = ref("");
const filters = reactive({ genre: "", region: "", year: "", minScore: "" });

async function loadHome() {
  loading.value = true;
  error.value = "";
  try {
    const [hot, all] = await Promise.all([movieApi.hot(4), movieApi.list({ pageNum: 1, pageSize: 8 })]);
    hotMovies.value = hot.data.data;
    movies.value = all.data.data;
  } catch (e) { error.value = errorMessage(e); }
  finally { loading.value = false; }
}

async function search(pageNum = 1) {
  listLoading.value = true;
  error.value = "";
  try {
    const result = await movieApi.list({
      genre: filters.genre || undefined,
      region: filters.region || undefined,
      year: filters.year ? Number(filters.year) : undefined,
      minScore: filters.minScore ? Number(filters.minScore) : undefined,
      pageNum, pageSize: 8
    });
    movies.value = result.data.data;
  } catch (e) { error.value = errorMessage(e); }
  finally { listLoading.value = false; }
}

function reset() {
  Object.assign(filters, { genre: "", region: "", year: "", minScore: "" });
  search(1);
}

onMounted(loadHome);
</script>

<template>
  <div data-testid="home-page">
    <section class="hero">
      <div class="container hero-inner">
        <div class="hero-copy">
          <span class="eyebrow">NOW SHOWING · 正在热映</span>
          <h1>让每一次观影<br /><em>从期待开始</em></h1>
          <p>发现好电影，选择理想座位，在 CineFlow 完成轻松而可靠的购票体验。</p>
          <a href="#all-movies" class="button button-primary" data-testid="hero-browse-button">浏览全部电影</a>
        </div>
        <div class="hero-art" aria-hidden="true">
          <div class="orb orb-one"></div><div class="orb orb-two"></div>
          <div class="ticket-art"><span>CF</span><strong>CINEMA</strong><small>ADMIT ONE</small></div>
        </div>
      </div>
    </section>

    <div class="container page-content">
      <LoadingState v-if="loading" />
      <ErrorState v-else-if="error && !movies.list.length" :message="error" @retry="loadHome" />
      <template v-else>
        <section class="content-section" data-testid="hot-movies-section">
          <div class="section-heading"><div><span class="eyebrow">TRENDING</span><h2>本周热门</h2></div><RouterLink to="/recommendations">更多推荐 →</RouterLink></div>
          <div class="movie-grid movie-grid-featured">
            <MovieCard v-for="(movie, index) in hotMovies" :key="movie.id" :movie="movie" :index="index" />
          </div>
        </section>

        <section id="all-movies" class="content-section" data-testid="all-movies-section">
          <div class="section-heading"><div><span class="eyebrow">EXPLORE</span><h2>全部电影</h2></div><span class="result-count">共 {{ movies.total }} 部</span></div>
          <form class="filter-bar" data-testid="movie-filter-form" @submit.prevent="search(1)">
            <label><span>类型</span><input v-model.trim="filters.genre" data-testid="filter-genre" placeholder="如：科幻" /></label>
            <label><span>地区</span><input v-model.trim="filters.region" data-testid="filter-region" placeholder="如：中国大陆" /></label>
            <label><span>年份</span><input v-model="filters.year" data-testid="filter-year" type="number" min="1888" max="2200" placeholder="2024" /></label>
            <label><span>最低评分</span><input v-model="filters.minScore" data-testid="filter-min-score" type="number" min="0" max="10" step="0.1" placeholder="8.0" /></label>
            <button class="button button-primary" data-testid="filter-submit" :disabled="listLoading">筛选</button>
            <button type="button" class="button button-ghost" data-testid="filter-reset" @click="reset">重置</button>
          </form>
          <p v-if="error" class="inline-alert error" role="alert" data-testid="movie-list-error">{{ error }}</p>
          <LoadingState v-if="listLoading" />
          <EmptyState v-else-if="!movies.list.length" title="没有找到电影" description="请尝试调整筛选条件" />
          <div v-else class="movie-grid">
            <MovieCard v-for="(movie, index) in movies.list" :key="movie.id" :movie="movie" :index="index" />
          </div>
          <div v-if="movies.totalPages > 1" class="pagination" data-testid="pagination">
            <button class="button button-ghost" data-testid="previous-page" :disabled="movies.pageNum <= 1" @click="search(movies.pageNum - 1)">上一页</button>
            <span>第 {{ movies.pageNum }} / {{ movies.totalPages }} 页</span>
            <button class="button button-ghost" data-testid="next-page" :disabled="movies.pageNum >= movies.totalPages" @click="search(movies.pageNum + 1)">下一页</button>
          </div>
        </section>
      </template>
    </div>
  </div>
</template>
