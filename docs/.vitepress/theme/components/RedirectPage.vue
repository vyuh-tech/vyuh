<script setup lang="ts">
import { onMounted } from 'vue';

const props = defineProps<{ to: string }>();
onMounted(() => {
  window.location.replace(props.to + window.location.search + window.location.hash);
});
</script>

<template>
  <p>This page has moved. <a :href="to">Continue to the documentation</a>.</p>
</template>
