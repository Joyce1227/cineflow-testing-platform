<script setup lang="ts">
defineProps<{ message: string }>();
defineEmits<{ retry: [] }>();
</script>

<template>
  <div class="state-panel error-panel" role="alert" data-testid="error-state">
    <div class="error-icon">!</div>
    <h3>页面加载失败</h3>
    <p>{{ message }}</p>
    <button class="button button-secondary" data-testid="retry-button" @click="$emit('retry')">重新加载</button>
  </div>
</template>
