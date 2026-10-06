<script setup lang="ts">
import { ref } from "vue";
import { useRouter } from "vue-router";
import { useAuthStore } from "../stores/auth";

const auth = useAuthStore();
const router = useRouter();
const menuOpen = ref(false);

function logout() {
  auth.logout();
  menuOpen.value = false;
  router.push({ name: "home" });
}
</script>

<template>
  <header class="site-header" data-testid="site-header">
    <div class="container nav-wrap">
      <RouterLink to="/" class="brand" data-testid="nav-logo"><i>C</i> CineFlow</RouterLink>
      <nav class="main-nav" aria-label="主导航">
        <RouterLink to="/" data-testid="nav-movies">电影</RouterLink>
        <RouterLink to="/recommendations" data-testid="nav-recommendations">发现</RouterLink>
        <RouterLink v-if="auth.isLoggedIn" to="/orders" data-testid="nav-orders">我的订单</RouterLink>
      </nav>
      <div class="nav-actions">
        <template v-if="auth.isLoggedIn">
          <button class="user-button" data-testid="user-menu-button" @click="menuOpen = !menuOpen">
            <span class="avatar">{{ auth.user?.username.slice(0, 1).toUpperCase() }}</span>
            <span>{{ auth.user?.username }}</span>
            <span aria-hidden="true">⌄</span>
          </button>
          <div v-if="menuOpen" class="user-menu" data-testid="user-menu">
            <RouterLink v-if="auth.user?.role === 'ADMIN'" to="/admin" data-testid="admin-console-link" @click="menuOpen = false">管理控制台</RouterLink>
            <RouterLink to="/orders" @click="menuOpen = false">订单中心</RouterLink>
            <button data-testid="logout-button" @click="logout">退出登录</button>
          </div>
        </template>
        <template v-else>
          <RouterLink to="/login" class="text-link" data-testid="nav-login">登录</RouterLink>
          <RouterLink to="/register" class="button button-primary button-small" data-testid="nav-register">免费注册</RouterLink>
        </template>
      </div>
    </div>
  </header>
</template>
