<script setup lang="ts">
import { computed, reactive, ref } from "vue";
import { useRoute, useRouter } from "vue-router";
import { errorMessage } from "../api/http";
import { useAuthStore } from "../stores/auth";

const auth = useAuthStore();
const route = useRoute();
const router = useRouter();
const form = reactive({ username: "", password: "" });
const errors = reactive({ username: "", password: "" });
const submitError = ref("");
const loading = ref(false);
const expired = computed(() => route.query.expired === "1");
const registered = computed(() => route.query.registered === "1");

function validate() {
  errors.username = form.username.trim() ? "" : "请输入用户名";
  errors.password = form.password ? "" : "请输入密码";
  return !errors.username && !errors.password;
}

async function submit() {
  submitError.value = "";
  if (!validate()) return;
  loading.value = true;
  try {
    await auth.login(form.username.trim(), form.password);
    const target = typeof route.query.redirect === "string" ? route.query.redirect : "/";
    await router.replace(target);
  } catch (e) { submitError.value = errorMessage(e); }
  finally { loading.value = false; }
}
</script>

<template>
  <div class="auth-page" data-testid="login-page">
    <div class="auth-visual"><div><span class="eyebrow">WELCOME BACK</span><h1>好电影，<br />不必等待。</h1><p>登录后即可选座购票、管理订单并获得个性化推荐。</p></div></div>
    <section class="auth-card">
      <RouterLink to="/" class="brand"><i>C</i> CineFlow</RouterLink>
      <div class="auth-heading"><h2>欢迎回来</h2><p>使用你的 CineFlow 账号登录</p></div>
      <p v-if="registered" class="inline-alert success" role="status" data-testid="register-success-alert">注册成功，请使用新账号登录</p>
      <p v-if="expired" class="inline-alert warning" role="alert" data-testid="session-expired-alert">登录状态已失效，请重新登录</p>
      <p v-if="submitError" class="inline-alert error" role="alert" data-testid="login-error">{{ submitError }}</p>
      <form novalidate data-testid="login-form" @submit.prevent="submit">
        <label class="form-field"><span>用户名</span><input v-model="form.username" data-testid="login-username" autocomplete="username" placeholder="请输入用户名" @blur="validate" /><small v-if="errors.username" class="field-error">{{ errors.username }}</small></label>
        <label class="form-field"><span>密码</span><input v-model="form.password" data-testid="login-password" type="password" autocomplete="current-password" placeholder="请输入密码" @blur="validate" /><small v-if="errors.password" class="field-error">{{ errors.password }}</small></label>
        <button class="button button-primary button-block" data-testid="login-submit" :disabled="loading">{{ loading ? "登录中…" : "登录" }}</button>
      </form>
      <p class="auth-switch">还没有账号？<RouterLink to="/register" data-testid="go-register">立即注册</RouterLink></p>
      <div class="demo-account"><strong>演示账号</strong><code>test_user / Test1234</code></div>
    </section>
  </div>
</template>
