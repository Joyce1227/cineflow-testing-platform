<script setup lang="ts">
withDefaults(defineProps<{ title?: string; description?: string }>(), {
  title: "暂无内容",
  description: "暂时没有符合条件的数据"
});
</script>

<template>
  <div class="state-panel empty-panel" data-testid="empty-state">
    <div class="empty-icon">◇</div>
    <h3>{{ title }}</h3>
    <p>{{ description }}</p>
    <slot />
  </div>
</template>
