<script setup lang="ts">
import { onMounted, reactive, ref } from "vue";
import { adminApi, movieApi } from "../../api";
import { errorMessage } from "../../api/http";
import type { Cinema } from "../../types";

const cinemas = ref<Cinema[]>([]);
const loading = ref(true);
const submitting = ref(false);
const error = ref("");
const success = ref("");
const showForm = ref(false);
const form = reactive({ name: "", city: "", address: "" });

async function load() {
  loading.value = true; error.value = "";
  try { cinemas.value = (await movieApi.cinemas()).data.data; }
  catch (e) { error.value = errorMessage(e); }
  finally { loading.value = false; }
}
async function submit() {
  error.value = ""; success.value = "";
  if (!form.name.trim() || !form.city.trim() || !form.address.trim()) { error.value = "影院名称、城市和详细地址均不能为空"; return; }
  submitting.value = true;
  try {
    const result = await adminApi.createCinema({ name: form.name.trim(), city: form.city.trim(), address: form.address.trim() });
    success.value = `影院“${result.data.data.name}”创建成功`;
    Object.assign(form, { name: "", city: "", address: "" }); showForm.value = false; await load();
  } catch (e) { error.value = errorMessage(e); }
  finally { submitting.value = false; }
}
onMounted(load);
</script>

<template>
  <div data-testid="admin-cinemas-page">
    <div class="admin-page-heading"><div><span class="eyebrow">LOCATIONS</span><h1>影院管理</h1><p>维护影院位置，创建场次时可以直接选择</p></div><button class="button button-primary" data-testid="open-create-cinema" @click="showForm = !showForm">{{ showForm ? '收起表单' : '+ 新增影院' }}</button></div>
    <p v-if="success" class="inline-alert success" role="status" data-testid="create-cinema-success">{{ success }}</p><p v-if="error" class="inline-alert error" role="alert" data-testid="create-cinema-error">{{ error }}</p>
    <section v-if="showForm" class="admin-form-panel" data-testid="create-cinema-panel">
      <div class="panel-heading"><div><h2>新增影院</h2><p>填写影院的名称与营业地址</p></div></div>
      <form class="admin-form" @submit.prevent="submit"><div class="form-row"><label class="form-field"><span>影院名称 *</span><input v-model="form.name" data-testid="admin-cinema-name" maxlength="128" placeholder="如：CineFlow国际影城" /></label><label class="form-field"><span>所在城市 *</span><input v-model="form.city" data-testid="admin-cinema-city" maxlength="64" placeholder="如：北京" /></label></div><label class="form-field"><span>详细地址 *</span><input v-model="form.address" data-testid="admin-cinema-address" maxlength="255" placeholder="请输入街道、商场及楼层" /></label><div class="form-actions"><button type="button" class="button button-ghost" @click="showForm = false">取消</button><button class="button button-primary" data-testid="submit-create-cinema" :disabled="submitting">{{ submitting ? '正在创建…' : '确认创建' }}</button></div></form>
    </section>
    <section class="cinema-admin-grid" data-testid="admin-cinema-list"><article v-if="loading" class="admin-panel table-message">正在加载…</article><article v-for="cinema in cinemas" v-else :key="cinema.id" class="cinema-admin-card" :data-testid="`admin-cinema-card-${cinema.id}`"><div class="cinema-symbol">⌂</div><div><span class="table-status available">营业中</span><h2>{{ cinema.name }}</h2><p>{{ cinema.city }} · {{ cinema.address }}</p><small>影院编号 #{{ cinema.id }}</small></div></article><div v-if="!loading && !cinemas.length" class="admin-empty">暂无影院数据</div></section>
  </div>
</template>
