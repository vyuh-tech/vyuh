<script setup lang="ts">
import { computed, nextTick, onMounted, onBeforeUnmount, ref, watch } from 'vue';
import { useData } from 'vitepress';
import { renderSketch } from '../diagrams';

const props = withDefaults(defineProps<{ source: string; title?: string }>(), {
  title: 'How the pieces fit together',
});
const { isDark } = useData();
const source = computed(() => decodeURIComponent(props.source));
const figure = ref<HTMLElement>();
const svg = ref('');
const error = ref(false);
let visible = false;
let generation = 0;
let observer: IntersectionObserver | undefined;

async function render() {
  if (!visible) return;
  const revision = ++generation;
  error.value = false;
  try {
    await document.fonts.load('18px Kalam');
    await document.fonts.ready;
    const result = await renderSketch(source.value, isDark.value);
    if (revision === generation) {
      svg.value = result;
      if (dialog.value?.open) nextTick(fit);
    }
  } catch {
    if (revision === generation) error.value = true;
  }
}

onMounted(() => {
  observer = new IntersectionObserver(entries => {
    if (entries.some(entry => entry.isIntersecting)) {
      visible = true;
      observer?.disconnect();
      render();
    }
  }, { rootMargin: '200px' });
  if (figure.value) observer.observe(figure.value);
});
watch([source, isDark], render);
onBeforeUnmount(() => {
  generation++;
  observer?.disconnect();
  unlockScroll();
});

// Full-screen viewer: a native modal dialog with pan and zoom.
const dialog = ref<HTMLDialogElement>();
const stage = ref<HTMLElement>();
const content = ref<HTMLElement>();
const scale = ref(1);
const x = ref(0);
const y = ref(0);
const dragging = ref(false);
const MIN = 0.2;
const MAX = 8;
let natural = { width: 0, height: 0 };
let previousOverflow = '';

const clamp = (value: number) => Math.min(MAX, Math.max(MIN, value));

function open() {
  if (!svg.value || !dialog.value) return;
  previousOverflow = document.documentElement.style.overflow;
  document.documentElement.style.overflow = 'hidden';
  dialog.value.showModal();
  nextTick(fit);
}

function close() {
  dialog.value?.close();
}

function unlockScroll() {
  document.documentElement.style.overflow = previousOverflow;
}

/** Size the SVG to its own coordinates, then fit it to the stage. */
function fit() {
  const element = content.value?.querySelector('svg');
  const area = stage.value?.getBoundingClientRect();
  if (!element || !area) return;
  const box = element.viewBox.baseVal;
  natural = box && box.width
    ? { width: box.width, height: box.height }
    : { width: element.clientWidth, height: element.clientHeight };
  element.style.width = `${natural.width}px`;
  element.style.height = `${natural.height}px`;
  element.style.maxWidth = 'none';
  const padding = 48;
  scale.value = clamp(
    Math.min((area.width - padding) / natural.width, (area.height - padding) / natural.height, 3),
  );
  x.value = (area.width - natural.width * scale.value) / 2;
  y.value = (area.height - natural.height * scale.value) / 2;
}

/** Zoom by [factor], keeping the point at (cx, cy) on the stage still. */
function zoomAt(factor: number, cx?: number, cy?: number) {
  const area = stage.value?.getBoundingClientRect();
  if (!area) return;
  const px = cx ?? area.width / 2;
  const py = cy ?? area.height / 2;
  const next = clamp(scale.value * factor);
  const ratio = next / scale.value;
  x.value = px - (px - x.value) * ratio;
  y.value = py - (py - y.value) * ratio;
  scale.value = next;
}

function onWheel(event: WheelEvent) {
  const area = stage.value!.getBoundingClientRect();
  zoomAt(Math.exp(-event.deltaY * 0.0015), event.clientX - area.left, event.clientY - area.top);
}

// One pointer pans; two pointers pinch-zoom.
const pointers = new Map<number, { x: number; y: number }>();
let pinchDistance = 0;

function onPointerDown(event: PointerEvent) {
  stage.value?.setPointerCapture(event.pointerId);
  pointers.set(event.pointerId, { x: event.clientX, y: event.clientY });
  dragging.value = true;
  if (pointers.size === 2) pinchDistance = distance();
}

function onPointerMove(event: PointerEvent) {
  const last = pointers.get(event.pointerId);
  if (!last) return;
  const current = { x: event.clientX, y: event.clientY };
  pointers.set(event.pointerId, current);
  if (pointers.size === 1) {
    x.value += current.x - last.x;
    y.value += current.y - last.y;
  } else if (pointers.size === 2 && pinchDistance) {
    const area = stage.value!.getBoundingClientRect();
    const [a, b] = [...pointers.values()];
    const next = distance();
    zoomAt(next / pinchDistance, (a.x + b.x) / 2 - area.left, (a.y + b.y) / 2 - area.top);
    pinchDistance = next;
  }
}

function onPointerUp(event: PointerEvent) {
  pointers.delete(event.pointerId);
  if (pointers.size < 2) pinchDistance = 0;
  if (pointers.size === 0) dragging.value = false;
}

function distance() {
  const [a, b] = [...pointers.values()];
  return Math.hypot(a.x - b.x, a.y - b.y);
}

function onKeydown(event: KeyboardEvent) {
  if (event.key === '+' || event.key === '=') zoomAt(1.25);
  else if (event.key === '-' || event.key === '_') zoomAt(1 / 1.25);
  else if (event.key === '0') fit();
  else return;
  event.preventDefault();
}

/** A click on the backdrop lands on the dialog element itself. */
function onDialogClick(event: MouseEvent) {
  if (event.target === dialog.value) close();
}
</script>

<template>
  <figure ref="figure" class="sketch-diagram" :data-diagram-state="error ? 'error' : svg ? 'ready' : 'pending'">
    <template v-if="svg">
      <button
        class="sketch-expand"
        type="button"
        aria-label="Open diagram full screen"
        title="Full screen"
        @click="open"
      >
        <svg viewBox="0 0 24 24" width="16" height="16" aria-hidden="true">
          <path d="M4 9V4h5M20 9V4h-5M4 15v5h5M20 15v5h-5" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
        </svg>
      </button>
      <div class="sketch-canvas" role="img" :aria-label="title" v-html="svg" @click="open" />
    </template>
    <p v-else class="sketch-loading">{{ error ? 'Unable to render this diagram.' : title }}</p>

    <dialog
      ref="dialog"
      class="sketch-dialog"
      :aria-label="title"
      @click="onDialogClick"
      @close="unlockScroll"
      @keydown="onKeydown"
    >
      <div class="sketch-dialog-toolbar">
        <span class="sketch-dialog-hint">Scroll or pinch to zoom · Drag to move · Esc to close</span>
        <div class="sketch-dialog-actions">
          <button type="button" aria-label="Zoom out" title="Zoom out (−)" @click="zoomAt(1 / 1.25)">
            <svg viewBox="0 0 24 24" width="16" height="16" aria-hidden="true"><path d="M5 12h14" stroke="currentColor" stroke-width="2" stroke-linecap="round" /></svg>
          </button>
          <button type="button" class="sketch-zoom-level" aria-label="Fit to screen" title="Fit to screen (0)" @click="fit">
            {{ Math.round(scale * 100) }}%
          </button>
          <button type="button" aria-label="Zoom in" title="Zoom in (+)" @click="zoomAt(1.25)">
            <svg viewBox="0 0 24 24" width="16" height="16" aria-hidden="true"><path d="M5 12h14M12 5v14" stroke="currentColor" stroke-width="2" stroke-linecap="round" /></svg>
          </button>
          <button type="button" class="sketch-close" aria-label="Close" title="Close (Esc)" @click="close">
            <svg viewBox="0 0 24 24" width="16" height="16" aria-hidden="true"><path d="M6 6l12 12M18 6L6 18" stroke="currentColor" stroke-width="2" stroke-linecap="round" /></svg>
          </button>
        </div>
      </div>
      <div
        ref="stage"
        class="sketch-dialog-stage"
        :class="{ 'is-dragging': dragging }"
        @wheel.prevent="onWheel"
        @pointerdown="onPointerDown"
        @pointermove="onPointerMove"
        @pointerup="onPointerUp"
        @pointercancel="onPointerUp"
      >
        <div
          ref="content"
          class="sketch-dialog-content"
          :style="{ transform: `translate(${x}px, ${y}px) scale(${scale})` }"
          v-html="svg"
        />
      </div>
    </dialog>
  </figure>
</template>
