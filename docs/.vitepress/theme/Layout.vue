<script lang="ts" setup>
import DefaultTheme from 'vitepress/theme';
import SiteFooter from './components/SiteFooter.vue';
const { Layout } = DefaultTheme;
</script>

<template>
  <Layout>
    <template #layout-bottom><SiteFooter /></template>
  </Layout>
</template>
