<script setup lang="ts">
const props = defineProps<{
  package: string;
}>();
</script>

<template>
  <a
    :href="`https://pub.dev/packages/${props.package}`"
    target="_blank"
    rel="noopener noreferrer"
    class="pub-badge"
  >
    <img
      :src="`https://img.shields.io/pub/v/${props.package}.svg`"
      :alt="`${props.package} on pub.dev`"
      loading="lazy"
    />
  </a>
</template>

<style scoped>
@reference "../style.css";

.pub-badge {
  @apply inline-flex items-center no-underline;
}

.pub-badge img {
  @apply h-5;
}
</style>
