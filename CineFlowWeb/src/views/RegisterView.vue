<script setup lang="ts">
import { reactive, ref } from "vue";
import { useRouter } from "vue-router";
import { authApi } from "../api";
import { errorMessage } from "../api/http";

const router = useRouter();
const form = reactive({ username: "", phone: "", email: "", password: "", confirmPassword: "" });
const errors = reactive<Record<string, string>>({});
const submitError = ref("");
const loading = ref(false);

function validate() {
  errors.username = /^[A-Za-z0-9_]{3,32}$/.test(form.username) ? "" : "3-32位字母、数字或下划线";
  errors.phone = /^1[3-9]\d{9}$/.test(form.phone) ? "" : "请输入正确的11位手机号";
  errors.email = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(form.email) ? "" : "请输入正确的邮箱";
  errors.password = form.password.length >= 6 && /[A-Za-z]/.test(form.password) && /\d/.test(form.password) ? "" : "至少6位，且同时包含字母和数字";
  errors.confirmPassword = form.confirmPassword === form.password ? "" : "两次输入的密码不一致";
  return Object.values(errors).every((value) => !value);
}

async function submit() {
  submitError.value = "";
  if (!validate()) return;
  loading.value = true;
  try {
    await authApi.register({ username: form.username, phone: form.phone, email: form.email, password: form.password });
    await router.push({ name: "login", query: { registered: "1" } });
  } catch (e) { submitError.value = errorMessage(e); }
  finally { loading.value = false; }
}
</script>

<template>
  <div class="auth-page auth-page-register" data-testid="register-page">
    <div class="auth-visual"><div><span class="eyebrow">JOIN CINEFLOW</span><h1>下一场故事，<br />由你选择。</h1><p>创建账号，探索电影、快捷选座并管理你的每一张电影票。</p></div></div>
    <section class="auth-card">
      <RouterLink to="/" class="brand"><i>C</i> CineFlow</RouterLink>
      <div class="auth-heading"><h2>创建账号</h2><p>填写信息即可加入 CineFlow</p></div>
      <p v-if="submitError" class="inline-alert error" role="alert" data-testid="register-error">{{ submitError }}</p>
      <form novalidate data-testid="register-form" @submit.prevent="submit">
        <label class="form-field"><span>用户名</span><input v-model.trim="form.username" data-testid="register-username" autocomplete="username" placeholder="3-32位字母、数字或下划线" /><small v-if="errors.username" class="field-error">{{ errors.username }}</small></label>
        <div class="form-row">
          <label class="form-field"><span>手机号</span><input v-model.trim="form.phone" data-testid="register-phone" inputmode="numeric" placeholder="请输入手机号" /><small v-if="errors.phone" class="field-error">{{ errors.phone }}</small></label>
          <label class="form-field"><span>邮箱</span><input v-model.trim="form.email" data-testid="register-email" type="email" placeholder="name@example.com" /><small v-if="errors.email" class="field-error">{{ errors.email }}</small></label>
        </div>
        <div class="form-row">
          <label class="form-field"><span>密码</span><input v-model="form.password" data-testid="register-password" type="password" autocomplete="new-password" placeholder="至少6位字母和数字" /><small v-if="errors.password" class="field-error">{{ errors.password }}</small></label>
          <label class="form-field"><span>确认密码</span><input v-model="form.confirmPassword" data-testid="register-confirm-password" type="password" autocomplete="new-password" placeholder="再次输入密码" /><small v-if="errors.confirmPassword" class="field-error">{{ errors.confirmPassword }}</small></label>
        </div>
        <button class="button button-primary button-block" data-testid="register-submit" :disabled="loading">{{ loading ? "注册中…" : "创建账号" }}</button>
      </form>
      <p class="auth-switch">已有账号？<RouterLink to="/login" data-testid="go-login">返回登录</RouterLink></p>
    </section>
  </div>
</template>
