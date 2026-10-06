<script setup lang="ts">
import { onMounted, reactive, ref } from "vue";
import { adminApi, movieApi } from "../../api";
import { errorMessage } from "../../api/http";
import type { Movie } from "../../types";

const movies = ref<Movie[]>([]);
const total = ref(0);
const loading = ref(true);
const submitting = ref(false);
const error = ref("");
const success = ref("");
const showForm = ref(false);
const form = reactive({ name: "", genres: "", regions: "", releaseYear: new Date().getFullYear(), score: 0, status: "AVAILABLE" });

async function load() {
  loading.value = true; error.value = "";
  try { const result = await movieApi.list({ pageNum: 1, pageSize: 100 }); movies.value = result.data.data.list; total.value = result.data.data.total; }
  catch (e) { error.value = errorMessage(e); }
  finally { loading.value = false; }
}

async function submit() {
  error.value = ""; success.value = "";
  if (!form.name.trim()) { error.value = "请输入电影名称"; return; }
  submitting.value = true;
  try {
    const result = await adminApi.createMovie({ ...form, name: form.name.trim(), genres: form.genres.trim(), regions: form.regions.trim(), releaseYear: Number(form.releaseYear), score: Number(form.score) });
    success.value = `电影“${result.data.data.name}”创建成功`;
    Object.assign(form, { name: "", genres: "", regions: "", releaseYear: new Date().getFullYear(), score: 0, status: "AVAILABLE" });
    showForm.value = false;
    await load();
  } catch (e) { error.value = errorMessage(e); }
  finally { submitting.value = false; }
}
onMounted(load);
</script>

<template>
  <div data-testid="admin-movies-page">
    <div class="admin-page-heading"><div><span class="eyebrow">CONTENT</span><h1>电影管理</h1><p>维护用户端可查询和购票的电影基础信息</p></div><button class="button button-primary" data-testid="open-create-movie" @click="showForm = !showForm">{{ showForm ? '收起表单' : '+ 新增电影' }}</button></div>
    <p v-if="success" class="inline-alert success" role="status" data-testid="create-movie-success">{{ success }}</p>
    <p v-if="error" class="inline-alert error" role="alert" data-testid="create-movie-error">{{ error }}</p>
    <section v-if="showForm" class="admin-form-panel" data-testid="create-movie-panel">
      <div class="panel-heading"><div><h2>新增电影</h2><p>带 * 的字段为必填项</p></div></div>
      <form class="admin-form" @submit.prevent="submit">
        <label class="form-field"><span>电影名称 *</span><input v-model="form.name" data-testid="admin-movie-name" maxlength="255" placeholder="请输入电影名称" /></label>
        <div class="form-row"><label class="form-field"><span>类型</span><input v-model="form.genres" data-testid="admin-movie-genres" maxlength="255" placeholder="科幻/剧情" /></label><label class="form-field"><span>地区</span><input v-model="form.regions" data-testid="admin-movie-regions" maxlength="255" placeholder="中国大陆" /></label></div>
        <div class="form-row three"><label class="form-field"><span>上映年份</span><input v-model="form.releaseYear" data-testid="admin-movie-year" type="number" min="1888" max="2200" /></label><label class="form-field"><span>初始评分</span><input v-model="form.score" data-testid="admin-movie-score" type="number" min="0" max="10" step="0.1" /></label><label class="form-field"><span>上架状态</span><select v-model="form.status" data-testid="admin-movie-status"><option value="AVAILABLE">可售</option><option value="OFF_SHELF">下架</option></select></label></div>
        <div class="form-actions"><button type="button" class="button button-ghost" data-testid="cancel-create-movie" @click="showForm = false">取消</button><button class="button button-primary" data-testid="submit-create-movie" :disabled="submitting">{{ submitting ? '正在创建…' : '确认创建' }}</button></div>
      </form>
    </section>
    <section class="admin-panel">
      <div class="panel-heading"><div><h2>电影列表</h2><p>共 {{ total }} 条记录</p></div><button class="table-refresh" data-testid="refresh-movies" @click="load">↻ 刷新</button></div>
      <div class="admin-table-wrap"><table class="admin-table" data-testid="admin-movie-table"><thead><tr><th>ID</th><th>电影名称</th><th>类型</th><th>地区</th><th>年份</th><th>评分</th><th>状态</th></tr></thead><tbody><tr v-if="loading"><td colspan="7" class="table-message">正在加载…</td></tr><tr v-else-if="!movies.length"><td colspan="7" class="table-message">暂无电影数据</td></tr><tr v-for="movie in movies" v-else :key="movie.id" :data-testid="`admin-movie-row-${movie.id}`"><td>#{{ movie.id }}</td><td><strong>{{ movie.name }}</strong></td><td>{{ movie.genres || '-' }}</td><td>{{ movie.regions || '-' }}</td><td>{{ movie.releaseYear || '-' }}</td><td>{{ Number(movie.score).toFixed(1) }}</td><td><span class="table-status" :class="movie.status.toLowerCase()">{{ movie.status === 'AVAILABLE' ? '可售' : '下架' }}</span></td></tr></tbody></table></div>
    </section>
  </div>
</template>
