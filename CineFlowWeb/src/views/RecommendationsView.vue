<script setup lang="ts">
import { onMounted, ref } from "vue";
import { recommendationApi } from "../api";
import { errorMessage } from "../api/http";
import ErrorState from "../components/ErrorState.vue";
import LoadingState from "../components/LoadingState.vue";
import MovieCard from "../components/MovieCard.vue";
import { useAuthStore } from "../stores/auth";
import type { Movie } from "../types";

const auth = useAuthStore();
const movies = ref<Movie[]>([]);
const loading = ref(true);
const error = ref("");

async function load() {
  loading.value = true; error.value = "";
  try {
    movies.value = auth.isLoggedIn
      ? (await recommendationApi.mine(8)).data.data
      : (await recommendationApi.hot(8)).data.data;
  } catch (e) { error.value = errorMessage(e); }
  finally { loading.value = false; }
}
onMounted(load);
</script>

<template>
  <div class="container page-content" data-testid="recommendations-page">
    <div class="recommendation-banner"><span class="eyebrow">CURATED FOR YOU</span><h1>{{ auth.isLoggedIn ? `为 ${auth.user?.username} 精选` : '发现热门佳片' }}</h1><p>{{ auth.isLoggedIn ? '根据你的评分偏好与热门趋势，为你推荐下一部电影。' : '登录并评价电影后，即可获得更贴合你的个性化推荐。' }}</p><RouterLink v-if="!auth.isLoggedIn" to="/login" class="button button-primary">登录获取专属推荐</RouterLink></div>
    <LoadingState v-if="loading" />
    <ErrorState v-else-if="error" :message="error" @retry="load" />
    <div v-else class="movie-grid" data-testid="recommendation-list"><MovieCard v-for="(movie, index) in movies" :key="movie.id" :movie="movie" :index="index" /></div>
  </div>
</template>
