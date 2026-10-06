<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted } from "vue";
import { useRoute, useRouter } from "vue-router";
import AppHeader from "./components/AppHeader.vue";
import { useAuthStore } from "./stores/auth";

const auth = useAuthStore();
const router = useRouter();
const route = useRoute();
const isAdminPage = computed(() => Boolean(route.meta.admin));
const onUnauthorized = () => {
  auth.logout();
  if (router.currentRoute.value.name !== "login") {
    router.push({ name: "login", query: { expired: "1", redirect: router.currentRoute.value.fullPath } });
  }
};

onMounted(() => window.addEventListener("cineflow:unauthorized", onUnauthorized));
onBeforeUnmount(() => window.removeEventListener("cineflow:unauthorized", onUnauthorized));
</script>

<template>
  <div class="app-shell">
    <AppHeader v-if="!isAdminPage" />
    <main>
      <RouterView />
    </main>
    <footer v-if="!isAdminPage" class="footer">
      <div class="container footer-inner">
        <span class="brand brand-small"><i>C</i> CineFlow</span>
        <span>电影购票与推荐系统 · Web 测试演示端</span>
      </div>
    </footer>
  </div>
</template>
