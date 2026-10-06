<script setup lang="ts">
import type { Movie } from "../types";

defineProps<{ movie: Movie; index?: number }>();

const gradients = [
  "linear-gradient(145deg,#172033,#e9b762)",
  "linear-gradient(145deg,#1d3440,#58a6a6)",
  "linear-gradient(145deg,#43242a,#d56f65)",
  "linear-gradient(145deg,#23213a,#8d78ca)"
];
</script>

<template>
  <article class="movie-card" :data-testid="`movie-card-${movie.id}`">
    <RouterLink :to="`/movies/${movie.id}`" class="poster-link" :aria-label="`查看${movie.name}`">
      <img v-if="movie.cover" :src="movie.cover" :alt="`${movie.name}海报`" class="poster-image" />
      <div v-else class="poster-fallback" :style="{ background: gradients[(index || 0) % gradients.length] }">
        <span>{{ movie.name }}</span>
        <small>CINEFLOW</small>
      </div>
      <span class="score-badge">{{ Number(movie.score || 0).toFixed(1) }}</span>
    </RouterLink>
    <div class="movie-card-body">
      <RouterLink :to="`/movies/${movie.id}`" class="movie-title" :data-testid="`movie-title-${movie.id}`">
        {{ movie.name }}
      </RouterLink>
      <p>{{ movie.genres || "类型待定" }} · {{ movie.releaseYear || "年份待定" }}</p>
      <RouterLink :to="`/movies/${movie.id}`" class="card-action" :data-testid="`movie-detail-${movie.id}`">查看场次 →</RouterLink>
    </div>
  </article>
</template>
