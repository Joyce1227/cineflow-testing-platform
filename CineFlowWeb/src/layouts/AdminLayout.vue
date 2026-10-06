<script setup lang="ts">
import { ref } from "vue";
import { useRouter } from "vue-router";
import { useAuthStore } from "../stores/auth";

const auth = useAuthStore();
const router = useRouter();
const collapsed = ref(false);

function logout() {
  auth.logout();
  router.replace("/login");
}
</script>

<template>
  <div class="admin-shell" :class="{ collapsed }" data-testid="admin-layout">
    <aside class="admin-sidebar">
      <RouterLink to="/admin" class="admin-brand" data-testid="admin-logo"><i>C</i><span>CineFlow <small>ADMIN</small></span></RouterLink>
      <nav class="admin-nav" aria-label="管理端导航">
        <RouterLink to="/admin" exact-active-class="active" data-testid="admin-nav-dashboard"><b>◫</b><span>控制台</span></RouterLink>
        <RouterLink to="/admin/movies" data-testid="admin-nav-movies"><b>▣</b><span>电影管理</span></RouterLink>
        <RouterLink to="/admin/cinemas" data-testid="admin-nav-cinemas"><b>⌂</b><span>影院管理</span></RouterLink>
        <RouterLink to="/admin/schedules" data-testid="admin-nav-schedules"><b>◷</b><span>场次管理</span></RouterLink>
      </nav>
      <RouterLink to="/" class="admin-back" data-testid="back-to-user-site"><b>←</b><span>返回用户端</span></RouterLink>
    </aside>
    <section class="admin-main">
      <header class="admin-topbar">
        <button class="sidebar-toggle" aria-label="切换侧边栏" data-testid="sidebar-toggle" @click="collapsed = !collapsed">☰</button>
        <div class="admin-topbar-right"><span class="system-dot"></span><span>系统在线</span><span class="admin-avatar">{{ auth.user?.username.slice(0, 1).toUpperCase() }}</span><strong>{{ auth.user?.username }}</strong><button data-testid="admin-logout" @click="logout">退出</button></div>
      </header>
      <main class="admin-content"><RouterView /></main>
    </section>
  </div>
</template>
