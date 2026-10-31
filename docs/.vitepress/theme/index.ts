import DefaultTheme from 'vitepress/theme';
import type { Theme } from 'vitepress';
import Layout from './Layout.vue';
import HomePage from './HomePage.vue';
import PubBadge from './components/PubBadge.vue';
import SketchDiagram from './components/SketchDiagram.vue';
import ActionLink from './components/ActionLink.vue';
import FrameworkLayers from './components/FrameworkLayers.vue';
import TechStack from './components/TechStack.vue';
import RedirectPage from './components/RedirectPage.vue';
import './style.css';

export default {
  extends: DefaultTheme,
  Layout,
  enhanceApp({ app }) {
    app.component('HomePage', HomePage);
    app.component('PubBadge', PubBadge);
    app.component('SketchDiagram', SketchDiagram);
    app.component('ActionLink', ActionLink);
    app.component('FrameworkLayers', FrameworkLayers);
    app.component('TechStack', TechStack);
    app.component('RedirectPage', RedirectPage);
  },
} satisfies Theme;
