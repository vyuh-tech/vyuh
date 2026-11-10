<script setup lang="ts">
import { onMounted, onBeforeUnmount, ref } from 'vue';
const canvas = ref<HTMLCanvasElement>();
const loaded = ref(false);
let disposed = false;
let runtime: import('@rive-app/canvas').Rive | undefined;
let observer: IntersectionObserver | undefined;
let resizeObserver: ResizeObserver | undefined;
let visible = false;
let motion: MediaQueryList | undefined;
function updatePlayback() {
  if (!runtime || !loaded.value) return;
  if (visible && !document.hidden && !motion?.matches) runtime.play('Hover');
  else runtime.pause();
}
onMounted(() => {
  motion = window.matchMedia('(prefers-reduced-motion: reduce)');
  motion.addEventListener('change', updatePlayback);
  document.addEventListener('visibilitychange', updatePlayback);
  observer = new IntersectionObserver(async entries => {
    visible = entries.some(entry => entry.isIntersecting);
    if (visible && !runtime && !motion?.matches) {
      const { Rive, RuntimeLoader } = await import('@rive-app/canvas');
      if (disposed || !canvas.value || runtime) return;
      RuntimeLoader.setWasmUrl('/rive.wasm');
      runtime = new Rive({ src: '/vyuh-logo.riv', artboard: 'Logo', stateMachine: 'Hover', canvas: canvas.value, autoplay: true,
        onLoad: () => { if (disposed) return; runtime?.resizeDrawingSurfaceToCanvas(); loaded.value = true; updatePlayback(); },
        onLoadError: () => { loaded.value = false; },
      });
      resizeObserver = new ResizeObserver(() => runtime?.resizeDrawingSurfaceToCanvas());
      resizeObserver.observe(canvas.value);
    }
    updatePlayback();
  });
  if (canvas.value) observer.observe(canvas.value);
});
onBeforeUnmount(() => {
  disposed = true;
  observer?.disconnect(); resizeObserver?.disconnect(); runtime?.cleanup();
  motion?.removeEventListener('change', updatePlayback);
  document.removeEventListener('visibilitychange', updatePlayback);
});
</script>
<template><span class="brand-logo" :class="{ 'brand-logo--ready': loaded }" aria-hidden="true"><img src="/logo.svg" alt="" width="40" height="40" /><canvas ref="canvas" width="80" height="80" /></span></template>
