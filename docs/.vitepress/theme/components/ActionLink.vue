<script setup lang="ts">
withDefaults(defineProps<{ href: string; variant?: 'primary' | 'secondary'; external?: boolean }>(), { variant: 'secondary', external: false });
</script>

<template>
  <a :href="href" class="action-link" :class="`action-link--${variant}`" :target="external ? '_blank' : undefined" :rel="external ? 'noopener noreferrer' : undefined">
    <span><slot /></span>
    <svg class="action-arrow" :class="{ 'action-arrow--external': external }" aria-hidden="true" viewBox="0 0 24 24" width="20" height="20"><path d="M4 12h15M13 6l6 6-6 6" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" /></svg>
  </a>
</template>
